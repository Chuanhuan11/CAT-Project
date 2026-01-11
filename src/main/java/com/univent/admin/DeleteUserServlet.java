package com.univent.admin;

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

@WebServlet("/DeleteUserServlet")
public class DeleteUserServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");

        // --- ROLE VALIDATION ---
        if (role == null || !"ADMIN".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        // -----------------------

        String userIdParam = request.getParameter("id");

        if (userIdParam != null && !userIdParam.isEmpty()) {
            int userId = Integer.parseInt(userIdParam);

            try (Connection con = DBConnection.getConnection()) {

                // --- RESTORE SEATS LOGIC ---
                // Before deleting user, return their confirmed tickets to the pool
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
                // ---------------------------

                // --- DELETE USER LOGIC ---
                String deleteUserSql = "DELETE FROM users WHERE id = ?";
                try (PreparedStatement psDel = con.prepareStatement(deleteUserSql)) {
                    psDel.setInt(1, userId);
                    psDel.executeUpdate();
                }
                // -------------------------

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect(request.getContextPath() + "/ManageUsersServlet");
    }
}