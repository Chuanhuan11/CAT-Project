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
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/EventListServlet")
public class EventListServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Event> allEvents = new ArrayList<>();

        // Fetch ONLY APPROVED events for the catalog
        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT * FROM events WHERE status = 'APPROVED'";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ResultSet rs = ps.executeQuery();
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
                    e.setStatus(rs.getString("status"));
                    allEvents.add(e);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Separate Logic in Java
        LocalDate today = LocalDate.now();

        // Upcoming (Future + Available Seats) -> Sort Ascending (Soonest first)
        List<Event> upcomingEvents = allEvents.stream()
                .filter(e -> !e.getEventDate().toLocalDate().isBefore(today) && e.getAvailableSeats() > 0)
                .sorted(Comparator.comparing(Event::getEventDate))
                .collect(Collectors.toList());

        // Sold Out (Future + No Seats) -> Sort Ascending
        List<Event> soldOutEvents = allEvents.stream()
                .filter(e -> !e.getEventDate().toLocalDate().isBefore(today) && e.getAvailableSeats() <= 0)
                .sorted(Comparator.comparing(Event::getEventDate))
                .collect(Collectors.toList());

        // Past (Past Date) -> Sort Descending (Most recent past first)
        List<Event> pastEvents = allEvents.stream()
                .filter(e -> e.getEventDate().toLocalDate().isBefore(today))
                .sorted((e1, e2) -> e2.getEventDate().compareTo(e1.getEventDate()))
                .collect(Collectors.toList());

        request.setAttribute("upcomingEvents", upcomingEvents);
        request.setAttribute("soldOutEvents", soldOutEvents);
        request.setAttribute("pastEvents", pastEvents);

        request.getRequestDispatcher("/catalog/home.jsp").forward(request, response);
    }
}