package com.univent.organizer;

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

@WebServlet("/DeleteBookingServlet")
@SuppressWarnings("serial")
public class DeleteBookingServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Role Validation
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");

        if (role == null || (!"ADMIN".equals(role) && !"ORGANIZER".equals(role))) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        // Get Parameters
        String bookingIdParam = request.getParameter("bookingId");
        String eventIdParam = request.getParameter("eventId");

        // Variable to hold the "Safe" Integer
        int eventId = -1;

        if (bookingIdParam != null && !bookingIdParam.isEmpty() && eventIdParam != null) {
            try {
                int bookingId = Integer.parseInt(bookingIdParam);
                eventId = Integer.parseInt(eventIdParam);

                try (Connection con = DBConnection.getConnection()) {
                    // Delete Logic
                    String deleteSql = "DELETE FROM bookings WHERE id = ?";
                    try (PreparedStatement ps = con.prepareStatement(deleteSql)) {
                        ps.setInt(1, bookingId);
                        int rowsAffected = ps.executeUpdate();

                        if (rowsAffected > 0) {
                            String updateSql = "UPDATE events SET available_seats = available_seats + 1 WHERE id = ?";
                            try (PreparedStatement psUpdate = con.prepareStatement(updateSql)) {
                                psUpdate.setInt(1, eventId);
                                psUpdate.executeUpdate();
                            }
                        }
                    }
                }
            } catch (NumberFormatException | java.sql.SQLException e) {
                e.printStackTrace();
            }
        }

        // Safe Redirect
        if (eventId > 0) {
            response.sendRedirect(request.getContextPath() + "/EventAttendeesServlet?eventId=" + eventId);
        } else {
            response.sendRedirect(request.getContextPath() + "/OrganiserDashboardServlet");
        }
    }
}