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

@WebServlet("/EventDetailsServlet")
public class EventDetailsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String idParam = request.getParameter("id");

        if (idParam != null) {
            int requestedId = Integer.parseInt(idParam);
            Event selectedEvent = null;

            List<Event> allEvents = new ArrayList<>();
            allEvents.add(new Event(1, "Java Workshop", "Master Java logic without a database first!", Date.valueOf("2026-02-10"), "DK F", 10.00, "event1.jpg", 50, 50));
            allEvents.add(new Event(2, "USM Color Run", "Join the most colorful 5km run on campus.", Date.valueOf("2026-03-15"), "Stadium", 25.00, "event2.jpg", 200, 198));
            allEvents.add(new Event(3, "AI Seminar", "Talk by Google Expert on GenAI.", Date.valueOf("2026-01-20"), "Dewan Budaya", 0.00, "event3.jpg", 300, 50));

            for (Event e : allEvents) {
                if (e.getId() == requestedId) {
                    selectedEvent = e;
                    break;
                }
            }

            if (selectedEvent != null) {
                request.setAttribute("event", selectedEvent);
                request.getRequestDispatcher("/catalog/event_details.jsp").forward(request, response);
            } else {
                response.sendRedirect("EventListServlet");
            }
        } else {
            response.sendRedirect("EventListServlet");
        }
    }
}