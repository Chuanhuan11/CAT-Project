package com.univent.catalog;

import com.univent.model.Event;
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

@WebServlet("/EventDetailsServlet")
public class EventDetailsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // --- GET PARAMETERS ---
        String idParam = request.getParameter("id");

        if (idParam != null) {
            int eventId = Integer.parseInt(idParam);
            Event event = null;

            try (Connection con = DBConnection.getConnection()) {
                // --- FETCH EVENT DETAILS ---
                String sql = "SELECT * FROM events WHERE id = ?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, eventId);

                ResultSet rs = ps.executeQuery();

                // If found, create the Event object
                if (rs.next()) {
                    event = new Event();
                    event.setId(rs.getInt("id"));
                    event.setTitle(rs.getString("title"));
                    event.setDescription(rs.getString("description"));
                    event.setEventDate(rs.getDate("event_date"));
                    event.setLocation(rs.getString("location"));
                    event.setPrice(rs.getDouble("price"));
                    event.setImageUrl(rs.getString("image_url"));
                    event.setTotalSeats(rs.getInt("total_seats"));
                    event.setAvailableSeats(rs.getInt("available_seats"));
                }
                // ---------------------------
            } catch (Exception e) {
                e.printStackTrace();
            }

            // --- FORWARD TO JSP ---
            if (event != null) {
                request.setAttribute("event", event);
                request.getRequestDispatcher("/catalog/event_details.jsp").forward(request, response);
            } else {
                // ID not found in database? Go home.
                response.sendRedirect("EventListServlet");
            }
            // ----------------------
        } else {
            response.sendRedirect("EventListServlet");
        }
    }
}