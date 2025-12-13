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
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addToCart(request, response);
        } else {
            response.sendRedirect("CartServlet");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("remove".equals(action)) {
            removeFromCart(request, response);
        } else {
            viewCart(request, response);
        }
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int eventId = Integer.parseInt(request.getParameter("eventId"));
        Event event = getEventById(eventId);

        if (event != null) {
            HttpSession session = request.getSession();
            List<Event> cart = (List<Event>) session.getAttribute("cart");
            if (cart == null) {
                cart = new ArrayList<>();
                session.setAttribute("cart", cart);
            }
            cart.add(event);
        }

        // Redirect back to catalog or cart
        response.sendRedirect("CartServlet");
    }

    private void removeFromCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int eventId = Integer.parseInt(request.getParameter("eventId"));
        HttpSession session = request.getSession();
        List<Event> cart = (List<Event>) session.getAttribute("cart");

        if (cart != null) {
            cart.removeIf(e -> e.getId() == eventId);
        }
        response.sendRedirect("CartServlet");
    }

    private void viewCart(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/booking/cart.jsp").forward(request, response);
    }

    private Event getEventById(int id) {
        Event event = null;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT * FROM events WHERE id = ?")) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    event = new Event();
                    event.setId(rs.getInt("id"));
                    event.setTitle(rs.getString("title"));
                    event.setDescription(rs.getString("description"));
                    event.setEventDate(rs.getDate("event_date"));
                    event.setLocation(rs.getString("location"));
                    event.setPrice(rs.getDouble("price"));
                    event.setImageUrl(rs.getString("image_url"));
                    event.setTotalSeats(rs.getInt("total_seats"));
                    event.setAvailableSeats(rs.getInt("available_seats"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return event;
    }
}