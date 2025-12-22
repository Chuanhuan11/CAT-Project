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
import java.util.List;

@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            addToCart(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/CartServlet");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("remove".equals(action)) {
            removeFromCart(request, response);
        } else {
            // Default Action: VIEW CART
            // Load from DB first so we see items even after logging out and back in
            loadCartFromDatabase(request);
            request.getRequestDispatcher("/booking/cart.jsp").forward(request, response);
        }
    }

    // --- 1. ADD TO DATABASE ---
    private void addToCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId"); // Uses Integer ID, not User object

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }

        int eventId = Integer.parseInt(request.getParameter("eventId"));

        try (Connection con = DBConnection.getConnection()) {
            // Check if item already exists to prevent duplicates
            String checkSql = "SELECT id FROM cart WHERE user_id = ? AND event_id = ?";
            PreparedStatement checkPs = con.prepareStatement(checkSql);
            checkPs.setInt(1, userId);
            checkPs.setInt(2, eventId);
            ResultSet rs = checkPs.executeQuery();

            if (!rs.next()) {
                // Insert into DB if not exists
                String insertSql = "INSERT INTO cart (user_id, event_id) VALUES (?, ?)";
                PreparedStatement ps = con.prepareStatement(insertSql);
                ps.setInt(1, userId);
                ps.setInt(2, eventId);
                ps.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/CartServlet");
    }

    // --- 2. REMOVE FROM DATABASE ---
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

    // --- 3. LOAD FROM DATABASE (Persist on Logout) ---
    private void loadCartFromDatabase(HttpServletRequest request) {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        List<Event> cart = new ArrayList<>();

        if (userId != null) {
            try (Connection con = DBConnection.getConnection()) {
                // Join cart with events to get titles/prices
                String sql = "SELECT e.* FROM events e JOIN cart c ON e.id = c.event_id WHERE c.user_id = ?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, userId);
                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
                    Event event = new Event();
                    event.setId(rs.getInt("id"));
                    event.setTitle(rs.getString("title"));
                    event.setEventDate(rs.getDate("event_date"));
                    event.setLocation(rs.getString("location"));
                    event.setPrice(rs.getDouble("price"));
                    event.setImageUrl(rs.getString("image_url"));
                    cart.add(event);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        // Save list to session so JSP can display it
        session.setAttribute("cart", cart);
    }
}