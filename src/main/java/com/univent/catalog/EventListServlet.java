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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/EventListServlet")
public class EventListServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Create a list to hold the events
        List<Event> events = new ArrayList<>();

        // 2. Connect to Database using your DBConnection utility
        try (Connection con = DBConnection.getConnection()) {

            // --- UPDATED SQL QUERY ---
            // Filter 1: event_date >= CURDATE()  -> Hides past events
            // Filter 2: available_seats > 0      -> Hides sold-out events
            // Order by: event_date ASC           -> Shows soonest events first
            String sql = "SELECT * FROM events WHERE event_date >= CURDATE() AND available_seats > 0 ORDER BY event_date ASC";

            PreparedStatement ps = con.prepareStatement(sql);

            // 4. Execute and get results
            ResultSet rs = ps.executeQuery();

            // 5. Loop through every row in the database table
            while (rs.next()) {
                Event e = new Event();
                e.setId(rs.getInt("id"));
                e.setTitle(rs.getString("title"));
                e.setDescription(rs.getString("description"));
                e.setEventDate(rs.getDate("event_date"));
                e.setLocation(rs.getString("location"));
                e.setPrice(rs.getDouble("price"));
                e.setImageUrl(rs.getString("image_url"));
                e.setTotalSeats(rs.getInt("total_seats"));
                e.setAvailableSeats(rs.getInt("available_seats"));

                // Add to our list
                events.add(e);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // 6. Send the Filtered List to the JSP
        request.setAttribute("eventList", events);

        // 7. Forward to the Home Page
        request.getRequestDispatcher("/catalog/home.jsp").forward(request, response);
    }
}