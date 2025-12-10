package com.univent.booking;

import com.univent.model.Event;
import com.univent.model.User;
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
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            // Redirect to login if user is not logged in
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }

        request.getRequestDispatcher("/booking/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        List<Event> cart = (List<Event>) session.getAttribute("cart");

        String cardNumber = request.getParameter("cardNumber");
        String expiry = request.getParameter("expiry");
        String cvv = request.getParameter("cvv");

        if (cardNumber == null || cardNumber.trim().isEmpty() || expiry == null || expiry.trim().isEmpty()
                || cvv == null || cvv.trim().isEmpty()) {
            request.setAttribute("error", "Please fill in all payment fields.");
            request.getRequestDispatcher("/booking/checkout.jsp").forward(request, response);
            return;
        }

        if (user != null && cart != null && !cart.isEmpty()) {
            boolean success = saveBookings(user.getId(), cart);
            if (success) {
                session.removeAttribute("cart");
                request.setAttribute("message", "Booking confirmed successfully!");
                request.getRequestDispatcher("/booking/checkout.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Booking failed. Please try again.");
                request.getRequestDispatcher("/booking/checkout.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/CartServlet");
        }
    }

    private boolean saveBookings(int userId, List<Event> cart) {
        String sql = "INSERT INTO bookings (user_id, event_id, booking_date, status) VALUES (?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            String date = LocalDate.now().toString();
            for (Event event : cart) {
                ps.setInt(1, userId);
                ps.setInt(2, event.getId());
                ps.setString(3, date);
                ps.setString(4, "CONFIRMED");
                ps.addBatch();
            }
            ps.executeBatch();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}