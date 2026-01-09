package com.univent.organizer;

import com.univent.model.Booking;
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

@WebServlet("/EventAttendeesServlet")
public class EventAttendeesServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Role Validation
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");

        if (role == null || (!"ADMIN".equals(role) && !"ORGANIZER".equals(role))) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String eventIdParam = request.getParameter("eventId");

        if (eventIdParam == null || eventIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/OrganiserDashboardServlet");
            return;
        }

        int eventId;
        try {
            eventId = Integer.parseInt(eventIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/OrganiserDashboardServlet");
            return;
        }

        String eventTitle = "Unknown Event";
        List<Booking> bookingList = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {
            // Fetch Event Title
            String titleSql = "SELECT title FROM events WHERE id = ?";
            try (PreparedStatement ps = con.prepareStatement(titleSql)) {
                ps.setInt(1, eventId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) eventTitle = rs.getString("title");
                }
            }

            // Fetch Bookings + User Info
            String sql = "SELECT b.id, b.status, b.booking_date, u.username, u.email, u.id as user_id " +
                    "FROM bookings b " +
                    "JOIN users u ON b.user_id = u.id " +
                    "WHERE b.event_id = ? " +
                    "ORDER BY b.id ASC";

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, eventId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Booking b = new Booking();
                        b.setId(rs.getInt("id"));
                        b.setStatus(rs.getString("status"));
                        b.setBookingDate(rs.getString("booking_date"));
                        b.setUserId(rs.getInt("user_id"));

                        b.setAttendeeName(rs.getString("username"));
                        b.setAttendeeEmail(rs.getString("email"));

                        bookingList.add(b);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("attendees", bookingList);
        request.setAttribute("eventTitle", eventTitle);
        request.setAttribute("eventId", eventId);

        request.getRequestDispatcher("/organizer/view_attendees.jsp").forward(request, response);
    }
}