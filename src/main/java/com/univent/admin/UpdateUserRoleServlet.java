package com.univent.admin;

import com.univent.util.DBConnection;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/UpdateUserRoleServlet")
public class UpdateUserRoleServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // Role Validation
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");

        if (role == null || !"ADMIN".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String userId = request.getParameter("userId");
        String newRole = request.getParameter("role");

        try (Connection con = DBConnection.getConnection()) {
            String sql = "UPDATE users SET role = ? WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, newRole);
            ps.setInt(2, Integer.parseInt(userId));
            ps.executeUpdate();
        } catch (Exception e) {
            System.err.println("Error updating role: " + e.getMessage());
        }
        response.sendRedirect("ManageUsersServlet");
    }
}