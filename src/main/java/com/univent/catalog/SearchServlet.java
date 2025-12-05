package com.univent.catalog;

import com.univent.model.Event;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/SearchServlet")
public class SearchServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. Get the search keyword from the URL (e.g., ?keyword=Java)
        String keyword = request.getParameter("keyword");

        // 2. Create the SAME mock list as EventListServlet (so we have data to search)
        // In Phase 4 (Database), we will replace this with: "SELECT * FROM events WHERE title LIKE ?"
        List<Event> allEvents = new ArrayList<>();
        allEvents.add(new Event(1, "Java Workshop", "Master Java logic without a database first!", Date.valueOf("2026-02-10"), "DK F", 10.00, "event1.jpg", 50, 50));
        allEvents.add(new Event(2, "USM Color Run", "Join the most colorful 5km run on campus.", Date.valueOf("2026-03-15"), "Stadium", 25.00, "event2.jpg", 200, 198));
        allEvents.add(new Event(3, "AI Seminar", "Talk by Google Expert on GenAI.", Date.valueOf("2026-01-20"), "Dewan Budaya", 0.00, "event3.jpg", 300, 50));

        List<Event> filteredList;

        // 3. Filter Logic
        if (keyword != null && !keyword.trim().isEmpty()) {
            String lowerKey = keyword.toLowerCase();
            // Filter: Keep event if Title OR Description contains the keyword
            filteredList = allEvents.stream()
                    .filter(e -> e.getTitle().toLowerCase().contains(lowerKey) ||
                            e.getDescription().toLowerCase().contains(lowerKey))
                    .collect(Collectors.toList());
        } else {
            // If search is empty, show everything
            filteredList = allEvents;
        }

        // 4. Send the result to JSP
        request.setAttribute("eventList", filteredList);

        // 5. Forward back to Home Page
        request.getRequestDispatcher("/catalog/home.jsp").forward(request, response);
    }
}