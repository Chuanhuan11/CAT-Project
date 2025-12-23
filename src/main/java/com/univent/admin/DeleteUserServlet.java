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

@WebServlet("/DeleteUserServlet")
public class DeleteUserServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");

        if (idParam != null) {
            int userId = Integer.parseInt(idParam);

            try (Connection con = DBConnection.getConnection()) {
                // 1. RESTORE SEATS: Add +1 to available_seats for every event this user booked
                String restoreSql = "UPDATE events e " +
                        "JOIN bookings b ON e.id = b.event_id " +
                        "SET e.available_seats = e.available_seats + 1 " +
                        "WHERE b.user_id = ? AND b.status = 'CONFIRMED'";

                PreparedStatement psRestore = con.prepareStatement(restoreSql);
                psRestore.setInt(1, userId);
                psRestore.executeUpdate();

                // 2. DELETE USER: Bookings will be auto-deleted by Foreign Key Cascade
                String deleteSql = "DELETE FROM users WHERE id = ?";
                PreparedStatement psDelete = con.prepareStatement(deleteSql);
                psDelete.setInt(1, userId);
                psDelete.executeUpdate();

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect(request.getContextPath() + "/ManageUsersServlet");
    }
}