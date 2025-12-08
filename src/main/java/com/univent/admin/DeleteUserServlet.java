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

@WebServlet("/DeleteUserServlet")
public class DeleteUserServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.isEmpty()) {
            int userId = Integer.parseInt(idParam);

            try (Connection con = DBConnection.getConnection()) {
                con.setAutoCommit(false);

                try {
                    String deleteBookings = "DELETE FROM bookings WHERE user_id = ?";
                    PreparedStatement psBookings = con.prepareStatement(deleteBookings);
                    psBookings.setInt(1, userId);
                    psBookings.executeUpdate();

                    String deleteUser = "DELETE FROM users WHERE id = ?";
                    PreparedStatement psUser = con.prepareStatement(deleteUser);
                    psUser.setInt(1, userId);
                    psUser.executeUpdate();

                    con.commit();
                } catch (SQLException e) {
                    con.rollback();
                    System.err.println("Error deleting user: " + e.getMessage());
                }

            } catch (Exception e) {
                System.err.println("Database connection error: " + e.getMessage());
            }
        }

        response.sendRedirect("ManageUsersServlet");
    }
}