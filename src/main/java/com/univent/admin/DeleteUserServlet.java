package com.univent.admin;

import com.univent.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/DeleteUserServlet")
public class DeleteUserServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userIdParam = request.getParameter("id");

        if (userIdParam != null && !userIdParam.isEmpty()) {
            int userId = Integer.parseInt(userIdParam);

            try (Connection con = DBConnection.getConnection()) {

                // --- STEP 1: COUNT AND RESTORE SEATS ---
                // We find all CONFIRMED bookings for this user, grouped by event.
                // This ensures we know exactly how many seats to give back.
                String findBookingsSql = "SELECT event_id, COUNT(*) as ticket_count " +
                        "FROM bookings " +
                        "WHERE user_id = ? AND status = 'CONFIRMED' " +
                        "GROUP BY event_id";

                try (PreparedStatement psFind = con.prepareStatement(findBookingsSql)) {
                    psFind.setInt(1, userId);
                    ResultSet rs = psFind.executeQuery();

                    while (rs.next()) {
                        int eventId = rs.getInt("event_id");
                        int ticketsToRestore = rs.getInt("ticket_count");

                        // Add seats back to the event
                        String restoreSql = "UPDATE events SET available_seats = available_seats + ? WHERE id = ?";
                        try (PreparedStatement psRestore = con.prepareStatement(restoreSql)) {
                            psRestore.setInt(1, ticketsToRestore);
                            psRestore.setInt(2, eventId);
                            psRestore.executeUpdate();
                        }
                    }
                }

                // --- STEP 2: DELETE USER ---
                // Deleting the user will cascade delete the bookings (cleaning up the booking table)
                // but we have already safely restored the seat counts above.
                String deleteUserSql = "DELETE FROM users WHERE id = ?";
                try (PreparedStatement psDel = con.prepareStatement(deleteUserSql)) {
                    psDel.setInt(1, userId);
                    psDel.executeUpdate();
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect(request.getContextPath() + "/ManageUsersServlet");
    }
}