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

@WebServlet("/SearchServlet")
public class SearchServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        List<Event> eventList = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {
            String sql;
            PreparedStatement ps;

            if (keyword == null || keyword.trim().isEmpty()) {
                sql = "SELECT * FROM events";
                ps = con.prepareStatement(sql);
            } else {
                sql = "SELECT * FROM events WHERE title LIKE ? OR description LIKE ?";
                ps = con.prepareStatement(sql);
                String searchPattern = "%" + keyword + "%";
                ps.setString(1, searchPattern);
                ps.setString(2, searchPattern);
            }

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
                eventList.add(e);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("eventList", eventList);
        request.getRequestDispatcher("/catalog/home.jsp").forward(request, response);
    }
}