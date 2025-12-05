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

@WebServlet("/EventListServlet")
public class EventListServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        List<Event> events = new ArrayList<>();

        events.add(new Event(1,
                "Java Workshop",
                "Master Java logic without a database first!",
                Date.valueOf("2026-02-10"),
                "SCL, School of Computer Sciences",
                10.00,
                "event1.jpg",
                50, 50));

        events.add(new Event(2,
                "USM Color Run",
                "Join the most colorful 5km run on campus.",
                Date.valueOf("2026-03-15"),
                "Padang Kawad",
                25.00,
                "event2.jpg",
                200, 198));

        events.add(new Event(3,
                "AI Seminar",
                "Talk by Google Expert on GenAI.",
                Date.valueOf("2026-01-20"),
                "DTSP",
                0.00,
                "event3.jpg",
                300, 50));

        request.setAttribute("eventList", events);
        request.getRequestDispatcher("/catalog/home.jsp").forward(request, response);
    }
}