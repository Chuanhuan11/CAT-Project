package com.univent.admin;

import com.univent.util.DBConnection;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/ProcessOrganizerRequestServlet")
public class ProcessOrganizerRequestServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) {
        try {
            HttpSession session = request.getSession();
            if (!"ADMIN".equals(session.getAttribute("role"))) return;

            int userId = Integer.parseInt(request.getParameter("userId"));
            String action = request.getParameter("action"); // "approve" or "reject"

            try (Connection con = DBConnection.getConnection()) {
                String sql;
                if ("approve".equals(action)) {
                    // Promote to ORGANIZER and clear request
                    sql = "UPDATE users SET role = 'ORGANIZER', role_request = NULL WHERE id = ?";
                } else {
                    // Keep as STUDENT but clear request
                    sql = "UPDATE users SET role_request = NULL WHERE id = ?";
                }

                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, userId);
                ps.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        try {
            response.sendRedirect(request.getContextPath() + "/ManageUsersServlet");
        } catch (Exception e) { e.printStackTrace(); }
    }
}