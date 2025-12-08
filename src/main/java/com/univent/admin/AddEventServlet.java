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
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/AddEventServlet")
public class AddEventServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.isEmpty()) {
            try (Connection con = DBConnection.getConnection()) {
                String sql = "SELECT * FROM events WHERE id = ?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(idParam));
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    Event event = new Event();
                    event.setId(rs.getInt("id"));
                    event.setTitle(rs.getString("title"));
                    event.setDescription(rs.getString("description"));
                    event.setEventDate(rs.getDate("event_date"));
                    event.setLocation(rs.getString("location"));
                    event.setPrice(rs.getDouble("price"));
                    event.setTotalSeats(rs.getInt("total_seats"));
                    request.setAttribute("event", event);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        request.getRequestDispatcher("/admin/add_event.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

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
                sql = "INSERT INTO events (title, description, event_date, location, price, total_seats, available_seats, image_url, organizer_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                ps = con.prepareStatement(sql);
                ps.setString(1, title);
                ps.setString(2, description);
                ps.setDate(3, Date.valueOf(dateStr));
                ps.setString(4, location);
                ps.setDouble(5, price);
                ps.setInt(6, totalSeats);
                ps.setInt(7, totalSeats);
                ps.setString(8, imageUrl);
                ps.setInt(9, userId);
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

        response.sendRedirect("OrganiserDashboardServlet");
    }
}