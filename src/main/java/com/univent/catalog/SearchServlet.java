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

        String keyword = request.getParameter("keyword");

        List<Event> allEvents = new ArrayList<>();
        allEvents.add(new Event(1, "Java Workshop", "Master Java logic without a database first!", Date.valueOf("2026-02-10"), "DK F", 10.00, "event1.jpg", 50, 50, 1));
        allEvents.add(new Event(2, "USM Color Run", "Join the most colorful 5km run on campus.", Date.valueOf("2026-03-15"), "Stadium", 25.00, "event2.jpg", 200, 198, 1));
        allEvents.add(new Event(3, "AI Seminar", "Talk by Google Expert on GenAI.", Date.valueOf("2026-01-20"), "Dewan Budaya", 0.00, "event3.jpg", 300, 50, 1));

        List<Event> filteredList;

        if (keyword != null && !keyword.trim().isEmpty()) {
            String lowerKey = keyword.toLowerCase();
            filteredList = allEvents.stream()
                    .filter(e -> e.getTitle().toLowerCase().contains(lowerKey) ||
                            e.getDescription().toLowerCase().contains(lowerKey))
                    .collect(Collectors.toList());
        } else {
            filteredList = allEvents;
        }

        request.setAttribute("eventList", filteredList);

        request.getRequestDispatcher("/catalog/home.jsp").forward(request, response);
    }
}