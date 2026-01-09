package com.univent.booking;

import com.univent.model.Event;
import com.univent.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            addToCart(request, response);
        } else if ("update".equals(action)) {
            updateCart(request, response);
        } else if ("prepareCheckout".equals(action)) {
            prepareCheckout(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/CartServlet");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("remove".equals(action)) {
            removeFromCart(request, response);
        } else {
            loadCartFromDatabase(request);
            request.getRequestDispatcher("/booking/cart.jsp").forward(request, response);
        }
    }

    private void prepareCheckout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        // Login Validation
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }

        List<Event> fullCart = (List<Event>) session.getAttribute("cart");

        if (fullCart == null || fullCart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/CartServlet");
            return;
        }

        String[] selectedIds = request.getParameterValues("selectedEvents");
        if (selectedIds == null || selectedIds.length == 0) {
            session.setAttribute("errorMessage", "Please select at least one item to checkout.");
            response.sendRedirect(request.getContextPath() + "/CartServlet");
            return;
        }

        List<Event> checkoutCart = new ArrayList<>();
        // Filter fullCart to match selectedIds
        for (String idStr : selectedIds) {
            int id = Integer.parseInt(idStr);
            for (Event event : fullCart) {
                if (event.getId() == id) {
                    checkoutCart.add(event);
                    break;
                }
            }
        }

        session.setAttribute("cart", checkoutCart);
        response.sendRedirect(request.getContextPath() + "/CheckoutServlet");
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }

        int eventId = Integer.parseInt(request.getParameter("eventId"));
        int quantityToAdd = 1;

        String qtyParam = request.getParameter("quantity");
        if(qtyParam != null && !qtyParam.isEmpty()){
            try { quantityToAdd = Integer.parseInt(qtyParam); } catch(NumberFormatException e) { quantityToAdd = 1; }
        }

        try (Connection con = DBConnection.getConnection()) {
            String availSql = "SELECT title, available_seats FROM events WHERE id = ?";
            int availableSeats = 0;
            try (PreparedStatement ps = con.prepareStatement(availSql)) {
                ps.setInt(1, eventId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    availableSeats = rs.getInt("available_seats");
                }
            }

            String cartCountSql = "SELECT COUNT(*) FROM cart WHERE user_id = ? AND event_id = ?";
            int currentCartQty = 0;
            try (PreparedStatement ps = con.prepareStatement(cartCountSql)) {
                ps.setInt(1, userId);
                ps.setInt(2, eventId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) currentCartQty = rs.getInt(1);
            }

            if ((currentCartQty + quantityToAdd) > availableSeats) {
                session.setAttribute("errorMessage", "Cannot add " + quantityToAdd + " more ticket(s). You have " + currentCartQty + " in cart, and only " + availableSeats + " are available.");
                response.sendRedirect(request.getContextPath() + "/EventListServlet");
                return;
            }

            String insertSql = "INSERT INTO cart (user_id, event_id) VALUES (?, ?)";
            try (PreparedStatement ps = con.prepareStatement(insertSql)) {
                ps.setInt(1, userId);
                ps.setInt(2, eventId);
                for(int i=0; i < quantityToAdd; i++) ps.executeUpdate();
            }

            session.setAttribute("successMessage", "Added " + quantityToAdd + " ticket(s) to cart!");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/EventListServlet");
    }

    private void updateCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId != null) {
            int eventId = Integer.parseInt(request.getParameter("eventId"));
            int newQuantity = Integer.parseInt(request.getParameter("quantity"));

            try (Connection con = DBConnection.getConnection()) {
                String availSql = "SELECT available_seats FROM events WHERE id = ?";
                int availableSeats = 0;
                try (PreparedStatement ps = con.prepareStatement(availSql)) {
                    ps.setInt(1, eventId);
                    ResultSet rs = ps.executeQuery();
                    if(rs.next()) availableSeats = rs.getInt("available_seats");
                }

                if (newQuantity > availableSeats) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Exceeds available seats");
                    return;
                }

                String countSql = "SELECT COUNT(*) FROM cart WHERE user_id = ? AND event_id = ?";
                PreparedStatement psCount = con.prepareStatement(countSql);
                psCount.setInt(1, userId);
                psCount.setInt(2, eventId);
                ResultSet rs = psCount.executeQuery();
                int currentQty = 0;
                if (rs.next()) currentQty = rs.getInt(1);

                if (newQuantity > currentQty) {
                    int toAdd = newQuantity - currentQty;
                    String addSql = "INSERT INTO cart (user_id, event_id) VALUES (?, ?)";
                    PreparedStatement psAdd = con.prepareStatement(addSql);
                    psAdd.setInt(1, userId);
                    psAdd.setInt(2, eventId);
                    for(int i=0; i<toAdd; i++) psAdd.executeUpdate();
                } else if (newQuantity < currentQty) {
                    int toRemove = currentQty - newQuantity;
                    if (toRemove > 0) {
                        String delSql = "DELETE FROM cart WHERE user_id = ? AND event_id = ? LIMIT " + toRemove;
                        PreparedStatement psDel = con.prepareStatement(delSql);
                        psDel.setInt(1, userId);
                        psDel.setInt(2, eventId);
                        psDel.executeUpdate();
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.setStatus(HttpServletResponse.SC_OK);
    }

    private void removeFromCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId != null) {
            int eventId = Integer.parseInt(request.getParameter("eventId"));
            try (Connection con = DBConnection.getConnection()) {
                String sql = "DELETE FROM cart WHERE user_id = ? AND event_id = ?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, userId);
                ps.setInt(2, eventId);
                ps.executeUpdate();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/CartServlet");
    }

    private void loadCartFromDatabase(HttpServletRequest request) {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        Map<Integer, Event> cartMap = new HashMap<>();

        if (userId != null) {
            try (Connection con = DBConnection.getConnection()) {
                String sql = "SELECT e.* FROM events e JOIN cart c ON e.id = c.event_id WHERE c.user_id = ?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, userId);
                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
                    int id = rs.getInt("id");
                    if (cartMap.containsKey(id)) {
                        Event e = cartMap.get(id);
                        e.setQuantity(e.getQuantity() + 1);
                    } else {
                        Event e = new Event();
                        e.setId(id);
                        e.setTitle(rs.getString("title"));
                        e.setEventDate(rs.getDate("event_date"));
                        e.setLocation(rs.getString("location"));
                        e.setPrice(rs.getDouble("price"));
                        e.setImageUrl(rs.getString("image_url"));
                        e.setAvailableSeats(rs.getInt("available_seats"));
                        e.setQuantity(1);
                        cartMap.put(id, e);
                    }
                }
            } catch (Exception e) { e.printStackTrace(); }
        }
        session.setAttribute("cart", new ArrayList<>(cartMap.values()));
    }
}