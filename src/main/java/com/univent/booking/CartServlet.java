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
            loadCartFromDatabase(request);
            request.getRequestDispatcher("/booking/cart.jsp").forward(request, response);
        }
    }

    // --- 1. ADD TO DATABASE (Modified to allow multiples) ---
    private void addToCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }

        int eventId = Integer.parseInt(request.getParameter("eventId"));

        try (Connection con = DBConnection.getConnection()) {

            // VALIDATION: Only check if Sold Out
            // We removed the "Already Booked" and "Already in Cart" checks to allow multiple tickets.
            String availabilitySql = "SELECT title, available_seats FROM events WHERE id = ?";
            try (PreparedStatement checkPs = con.prepareStatement(availabilitySql)) {
                checkPs.setInt(1, eventId);
                ResultSet rs = checkPs.executeQuery();
                if (rs.next()) {
                    if (rs.getInt("available_seats") <= 0) {
                        session.setAttribute("errorMessage", "Sorry, " + rs.getString("title") + " is fully booked.");
                        response.sendRedirect(request.getContextPath() + "/CartServlet");
                        return;
                    }
                }
            }

            // INSERT NEW ROW (Allows multiple rows for same user & event)
            String insertSql = "INSERT INTO cart (user_id, event_id) VALUES (?, ?)";
            try (PreparedStatement ps = con.prepareStatement(insertSql)) {
                ps.setInt(1, userId);
                ps.setInt(2, eventId);
                ps.executeUpdate();
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error adding to cart: " + e.getMessage());
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
                // LIMIT 1 ensures we only remove ONE ticket if they have multiple of the same event
                String sql = "DELETE FROM cart WHERE user_id = ? AND event_id = ? LIMIT 1";
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

    // --- 3. LOAD FROM DATABASE ---
    private void loadCartFromDatabase(HttpServletRequest request) {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        List<Event> cart = new ArrayList<>();

        if (userId != null) {
            try (Connection con = DBConnection.getConnection()) {
                // Simple Join - will return multiple rows if multiple tickets exist
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
        session.setAttribute("cart", cart);
    }
}