package com.univent.admin;

import com.univent.util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/UpdateEventStatusServlet")
public class UpdateEventStatusServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");

        // Security: Only Admins can approve/reject
        if (role == null || !"ADMIN".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/OrganiserDashboardServlet");
            return;
        }

        int eventId = Integer.parseInt(request.getParameter("eventId"));
        String newStatus = request.getParameter("status"); // "APPROVED" or "REJECTED"

        try (Connection con = DBConnection.getConnection()) {
            String sql = "UPDATE events SET status = ? WHERE id = ?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, newStatus);
                ps.setInt(2, eventId);
                ps.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error updating status.");
        }

        response.sendRedirect(request.getContextPath() + "/OrganiserDashboardServlet");
    }
}