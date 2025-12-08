package com.univent.admin;

import com.univent.util.DBConnection;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/DeleteEventServlet")
public class DeleteEventServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {

        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.isEmpty()) {
            int eventId = Integer.parseInt(idParam);

            try (Connection con = DBConnection.getConnection()) {
                con.setAutoCommit(false);

                try {
                    String deleteBookingsSql = "DELETE FROM bookings WHERE event_id = ?";
                    PreparedStatement psBookings = con.prepareStatement(deleteBookingsSql);
                    psBookings.setInt(1, eventId);
                    psBookings.executeUpdate();

                    String deleteEventSql = "DELETE FROM events WHERE id = ?";
                    PreparedStatement psEvent = con.prepareStatement(deleteEventSql);
                    psEvent.setInt(1, eventId);
                    psEvent.executeUpdate();

                    con.commit();

                } catch (SQLException e) {
                    con.rollback();
                    System.err.println("Error deleting event: " + e.getMessage());
                }

            } catch (Exception e) {
                System.err.println("Error deleting event: " + e.getMessage());
            }
        }

        response.sendRedirect("OrganiserDashboardServlet");
    }
}