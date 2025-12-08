package com.univent.organizer;

import com.univent.model.User;
import com.univent.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/EventAttendeesServlet")
public class EventAttendeesServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String eventIdParam = request.getParameter("eventId");

        // Basic Validation
        if (eventIdParam == null || eventIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/AdminDashboardServlet");
            return;
        }

        int eventId;
        try {
            eventId = Integer.parseInt(eventIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/AdminDashboardServlet");
            return;
        }

        String eventTitle = "Unknown Event";
        List<User> attendees = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {
            // QUERY 1: Fetch Event Title Securely from DB (Fixes XSS)
            String titleSql = "SELECT title FROM events WHERE id = ?";
            try (PreparedStatement psTitle = con.prepareStatement(titleSql)) {
                psTitle.setInt(1, eventId);
                try (ResultSet rsTitle = psTitle.executeQuery()) {
                    if (rsTitle.next()) {
                        eventTitle = rsTitle.getString("title");
                    }
                }
            }

            // QUERY 2: Fetch Attendees
            String attendeesSql = "SELECT u.id, u.username, u.email FROM users u " +
                    "JOIN bookings b ON u.id = b.user_id " +
                    "WHERE b.event_id = ?";
            try (PreparedStatement psAttendees = con.prepareStatement(attendeesSql)) {
                psAttendees.setInt(1, eventId);
                try (ResultSet rsAttendees = psAttendees.executeQuery()) {
                    while (rsAttendees.next()) {
                        User u = new User();
                        u.setId(rsAttendees.getInt("id"));
                        u.setUsername(rsAttendees.getString("username"));
                        u.setEmail(rsAttendees.getString("email"));
                        attendees.add(u);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("attendees", attendees);
        request.setAttribute("eventTitle", eventTitle); // Now contains safe DB data
        request.getRequestDispatcher("/organizer/view_attendees.jsp").forward(request, response);
    }
}