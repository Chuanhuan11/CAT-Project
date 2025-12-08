package com.univent.admin;

import com.univent.util.DBConnection;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;

@WebServlet("/AddEventServlet")
public class AddEventServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idParam = request.getParameter("id");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String dateStr = request.getParameter("eventDate");
        String location = request.getParameter("location");
        double price = Double.parseDouble(request.getParameter("price"));
        int totalSeats = Integer.parseInt(request.getParameter("totalSeats"));

        String imageUrl = "event1.jpg";

        try (Connection con = DBConnection.getConnection()) {
            String sql;
            PreparedStatement ps;

            if (idParam == null || idParam.isEmpty()) {
                sql = "INSERT INTO events (title, description, event_date, location, price, total_seats, available_seats, image_url) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                ps = con.prepareStatement(sql);
                ps.setString(1, title);
                ps.setString(2, description);
                ps.setDate(3, Date.valueOf(dateStr));
                ps.setString(4, location);
                ps.setDouble(5, price);
                ps.setInt(6, totalSeats);
                ps.setInt(7, totalSeats);
                ps.setString(8, imageUrl);
            } else {
                sql = "UPDATE events SET title=?, description=?, event_date=?, location=?, price=?, total_seats=? WHERE id=?";
                ps = con.prepareStatement(sql);
                ps.setString(1, title);
                ps.setString(2, description);
                ps.setDate(3, Date.valueOf(dateStr));
                ps.setString(4, location);
                ps.setDouble(5, price);
                ps.setInt(6, totalSeats);
                ps.setInt(7, Integer.parseInt(idParam));
            }

            ps.executeUpdate();

        } catch (Exception e) {
            System.err.println("Error saving event: " + e.getMessage());
        }

        response.sendRedirect("AdminDashboardServlet");
    }
}