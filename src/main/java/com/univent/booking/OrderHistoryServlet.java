package com.univent.booking;

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
import java.util.Date;
import java.util.List;

@WebServlet("/OrderHistoryServlet")
public class OrderHistoryServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/user/login.jsp");
            return;
        }

        List<Ticket> tickets = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {
            // Join Bookings with Events to get all details
            String sql = "SELECT b.id AS booking_id, b.booking_date, b.status, " +
                    "e.title, e.event_date, e.location, e.price, e.image_url " +
                    "FROM bookings b " +
                    "JOIN events e ON b.event_id = e.id " +
                    "WHERE b.user_id = ? " +
                    "ORDER BY b.booking_date DESC";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Ticket t = new Ticket();
                t.setBookingId(rs.getInt("booking_id"));
                t.setBookingDate(rs.getTimestamp("booking_date"));
                t.setStatus(rs.getString("status"));
                t.setEventTitle(rs.getString("title"));
                t.setEventDate(rs.getDate("event_date"));
                t.setLocation(rs.getString("location"));
                t.setPrice(rs.getDouble("price"));
                t.setImageUrl(rs.getString("image_url"));
                tickets.add(t);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("ticketList", tickets);
        request.getRequestDispatcher("/booking/my_tickets.jsp").forward(request, response);
    }

    // --- Inner DTO Class for easier data handling ---
    public static class Ticket {
        private int bookingId;
        private Date bookingDate;
        private String status;
        private String eventTitle;
        private Date eventDate;
        private String location;
        private double price;
        private String imageUrl;

        // Getters and Setters
        public int getBookingId() { return bookingId; }
        public void setBookingId(int bookingId) { this.bookingId = bookingId; }
        public Date getBookingDate() { return bookingDate; }
        public void setBookingDate(Date bookingDate) { this.bookingDate = bookingDate; }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
        public String getEventTitle() { return eventTitle; }
        public void setEventTitle(String eventTitle) { this.eventTitle = eventTitle; }
        public Date getEventDate() { return eventDate; }
        public void setEventDate(Date eventDate) { this.eventDate = eventDate; }
        public String getLocation() { return location; }
        public void setLocation(String location) { this.location = location; }
        public double getPrice() { return price; }
        public void setPrice(double price) { this.price = price; }
        public String getImageUrl() { return imageUrl; }
        public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    }
}