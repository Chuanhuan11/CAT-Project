package com.univent.admin;

import com.univent.model.Event;
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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/OrganiserDashboardServlet")
public class OrganiserDashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");
        Integer userId = (Integer) session.getAttribute("userId");

        // 1. Security Check
        if (role == null || (!role.equals("ADMIN") && !role.equals("ORGANIZER"))) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }

        List<Event> events = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {
            String sql;
            PreparedStatement ps;

            // 2. Role-Based Logic
            if ("ADMIN".equals(role)) {
                // Admin sees EVERYTHING
                sql = "SELECT * FROM events";
                ps = con.prepareStatement(sql);
            } else {
                // Organizer sees ONLY their own events
                sql = "SELECT * FROM events WHERE organizer_id = ?";
                ps = con.prepareStatement(sql);
                ps.setInt(1, userId);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Event e = new Event();
                e.setId(rs.getInt("id"));
                e.setTitle(rs.getString("title"));
                e.setEventDate(rs.getDate("event_date"));
                e.setLocation(rs.getString("location"));
                e.setPrice(rs.getDouble("price"));
                e.setAvailableSeats(rs.getInt("available_seats"));
                e.setOrganizerId(rs.getInt("organizer_id")); // Ensure Event model has this setter
                events.add(e);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("eventList", events);
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}