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

@WebServlet("/AdminDashboardServlet")
public class AdminDashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Login function dummy
        /*
        if (role == null || !role.equals("ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }
        */

        List<Event> events = new ArrayList<>();
        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT * FROM events";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Event e = new Event();
                e.setId(rs.getInt("id"));
                e.setTitle(rs.getString("title"));
                e.setEventDate(rs.getDate("event_date"));
                e.setLocation(rs.getString("location"));
                e.setPrice(rs.getDouble("price"));
                e.setAvailableSeats(rs.getInt("available_seats"));
                events.add(e);
            }
        } catch (Exception e) {
            System.err.println("Error fetching event list: " + e.getMessage());
        }

        request.setAttribute("eventList", events);
        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}