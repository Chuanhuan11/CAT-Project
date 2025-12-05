package com.univent.catalog;

import com.univent.model.Event;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/EventDetailsServlet")
public class EventDetailsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String idParam = request.getParameter("id");

        if(idParam != null) {
            Event mockEvent = new Event();
            mockEvent.setId(Integer.parseInt(idParam));
            mockEvent.setTitle("Mock Event (ID: " + idParam + ")");
            mockEvent.setDescription("This is a hardcoded description. The database is NOT connected yet, but the page layout is working!");
            mockEvent.setEventDate(Date.valueOf("2026-12-31"));
            mockEvent.setLocation("Virtual Location");
            mockEvent.setPrice(50.00);
            mockEvent.setImageUrl("event1.jpg");
            mockEvent.setTotalSeats(100);
            mockEvent.setAvailableSeats(99);

            request.setAttribute("event", mockEvent);
            request.getRequestDispatcher("/catalog/event_details.jsp").forward(request, response);
        } else {
            response.sendRedirect("EventListServlet");
        }
    }
}