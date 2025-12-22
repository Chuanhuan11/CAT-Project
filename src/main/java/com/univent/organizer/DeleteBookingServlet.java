package com.univent.organizer;

import com.univent.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/DeleteBookingServlet")
public class DeleteBookingServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String eventIdStr = request.getParameter("eventId");
        String userIdStr = request.getParameter("userId");

        if (eventIdStr != null && userIdStr != null) {
            int eventId = Integer.parseInt(eventIdStr);
            int userId = Integer.parseInt(userIdStr);

            Connection con = null;
            try {
                con = DBConnection.getConnection();
                con.setAutoCommit(false); // Start Transaction

                // 1. Delete the Booking
                String deleteSql = "DELETE FROM bookings WHERE event_id = ? AND user_id = ?";
                try (PreparedStatement psDelete = con.prepareStatement(deleteSql)) {
                    psDelete.setInt(1, eventId);
                    psDelete.setInt(2, userId);
                    int rowsAffected = psDelete.executeUpdate();

                    if (rowsAffected > 0) {
                        // 2. If deletion worked, Restore the Seat
                        String updateSql = "UPDATE events SET available_seats = available_seats + 1 WHERE id = ?";
                        try (PreparedStatement psUpdate = con.prepareStatement(updateSql)) {
                            psUpdate.setInt(1, eventId);
                            psUpdate.executeUpdate();
                        }
                    }
                }

                con.commit(); // Save Changes

            } catch (Exception e) {
                if (con != null) {
                    try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
                }
                e.printStackTrace();
            } finally {
                if (con != null) {
                    try { con.setAutoCommit(true); con.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
            }
        }

        // Redirect back to the attendees list
        response.sendRedirect(request.getContextPath() + "/EventAttendeesServlet?eventId=" + eventIdStr);
    }
}