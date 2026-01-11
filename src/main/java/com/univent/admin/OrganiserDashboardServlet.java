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
        Integer userId = (Integer) session.getAttribute("userId");
        String sessionRole = (String) session.getAttribute("role");

        // --- BASIC LOGIN CHECK ---
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }

        // --- SMART ROLE CHECK (AUTO-PROMOTE) ---
        // Check DB to see if they were promoted while logged in
        String currentDbRole = getRoleFromDatabase(userId);

        if (currentDbRole != null && !currentDbRole.equals(sessionRole)) {
            // Role Mismatch Detected!
            if ("ORGANIZER".equals(currentDbRole)) {
                // They were promoted! Update session immediately.
                session.setAttribute("role", "ORGANIZER");
                session.setAttribute("successMessage", "Congratulations! Your application has been approved. You are now an Event Organizer.");
                sessionRole = "ORGANIZER"; // Update local variable so access check passes below
            } else if ("STUDENT".equals(currentDbRole)) {
                // Demoted? Update session for safety.
                session.setAttribute("role", "STUDENT");
                sessionRole = "STUDENT";
            }
        }
        // ---------------------------------------

        // --- ACCESS CONTROL ---
        if (!"ADMIN".equals(sessionRole) && !"ORGANIZER".equals(sessionRole)) {
            session.setAttribute("errorMessage", "Access Denied. You do not have permission to view the dashboard.");
            response.sendRedirect(request.getContextPath() + "/EventListServlet");
            return;
        }
        // ----------------------

        // --- FETCH EVENTS LOGIC ---
        List<Event> events = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {
            String sql;
            PreparedStatement ps;

            if ("ADMIN".equals(sessionRole)) {
                sql = "SELECT * FROM events";
                ps = con.prepareStatement(sql);
            } else {
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
                e.setOrganizerId(rs.getInt("organizer_id"));
                e.setTotalSeats(rs.getInt("total_seats"));
                e.setImageUrl(rs.getString("image_url"));
                e.setDescription(rs.getString("description"));

                // --- FETCH STATUS ---
                String status = rs.getString("status");
                if(status == null) status = "APPROVED"; // Handle legacy data
                e.setStatus(status);
                // --------------------

                events.add(e);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("eventList", events);
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }

    // --- HELPER METHOD TO CHECK DB ---
    private String getRoleFromDatabase(int userId) {
        String role = null;
        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT role FROM users WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                role = rs.getString("role");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return role;
    }
}