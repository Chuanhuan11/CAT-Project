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

        if (role == null || (!role.equals("ADMIN") && !role.equals("ORGANIZER"))) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }

        List<Event> events = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {
            String sql;
            PreparedStatement ps;

            if ("ADMIN".equals(role)) {
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

                // --- FIX: FETCH MISSING COLUMNS ---
                e.setTotalSeats(rs.getInt("total_seats"));
                e.setImageUrl(rs.getString("image_url"));
                e.setDescription(rs.getString("description"));
                // ----------------------------------

                events.add(e);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("eventList", events);
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}