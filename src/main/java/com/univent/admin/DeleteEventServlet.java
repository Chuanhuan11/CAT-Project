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

@WebServlet("/DeleteEventServlet")
public class DeleteEventServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        Integer userId = (Integer) session.getAttribute("userId");

        if (idParam != null) {
            try (Connection con = DBConnection.getConnection()) {
                // 1. Ownership Check
                if (!"ADMIN".equals(role)) {
                    String checkSql = "SELECT organizer_id FROM events WHERE id = ?";
                    PreparedStatement checkPs = con.prepareStatement(checkSql);
                    checkPs.setInt(1, Integer.parseInt(idParam));
                    ResultSet rs = checkPs.executeQuery();
                    if (rs.next()) {
                        if (rs.getInt("organizer_id") != userId) {
                            // Not the owner -> Deny Access
                            response.sendRedirect(request.getContextPath() + "/OrganiserDashboardServlet");
                            return;
                        }
                    }
                }

                // 2. Perform Delete
                String sql = "DELETE FROM events WHERE id = ?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(idParam));
                ps.executeUpdate();

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/OrganiserDashboardServlet");
    }
}