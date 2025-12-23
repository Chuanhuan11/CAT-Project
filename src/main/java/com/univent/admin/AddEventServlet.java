package com.univent.admin;

import com.univent.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/AddEventServlet")
@MultipartConfig
public class AddEventServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/OrganiserDashboardServlet");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        String idParam = request.getParameter("id");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String date = request.getParameter("eventDate");
        String location = request.getParameter("location");
        String priceParam = request.getParameter("price");
        String seatsParam = request.getParameter("totalSeats");

        String errorMessage = null;
        double price = 0.0;
        int totalSeats = 0;

        // --- SERVER-SIDE SAFETY CHECKS ---
        if (title == null || title.trim().isEmpty()) {
            errorMessage = "Title is missing.";
        } else {
            try {
                price = Double.parseDouble(priceParam);
                totalSeats = Integer.parseInt(seatsParam);
                if (price < 0 || totalSeats < 1) errorMessage = "Invalid numerical values.";
            } catch (Exception e) {
                errorMessage = "Invalid number format.";
            }
        }

        if (errorMessage != null) {
            session.setAttribute("errorMessage", errorMessage);
            response.sendRedirect(request.getContextPath() + "/OrganiserDashboardServlet");
            return;
        }

        // Image Upload Logic
        Part filePart = request.getPart("imageFile");
        String finalImageName = request.getParameter("currentImage");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = filePart.getSubmittedFileName();
            if (fileName != null && !fileName.isEmpty()) {
                finalImageName = fileName;
                String uploadPath = getServletContext().getRealPath("") + File.separator + "assets" + File.separator + "img";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();
                filePart.write(uploadPath + File.separator + fileName);
            }
        }

        try (Connection con = DBConnection.getConnection()) {
            if (idParam == null || idParam.isEmpty()) {
                String sql = "INSERT INTO events (title, description, event_date, location, price, total_seats, available_seats, image_url, organizer_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, title);
                ps.setString(2, description);
                ps.setString(3, date);
                ps.setString(4, location);
                ps.setDouble(5, price);
                ps.setInt(6, totalSeats);
                ps.setInt(7, totalSeats);
                ps.setString(8, finalImageName);
                ps.setInt(9, userId);
                ps.executeUpdate();
            } else {
                String sql = "UPDATE events SET title=?, description=?, event_date=?, location=?, price=?, total_seats=?, image_url=?, available_seats = ? - (SELECT COUNT(*) FROM bookings WHERE event_id = events.id AND status='CONFIRMED') WHERE id=?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, title);
                ps.setString(2, description);
                ps.setString(3, date);
                ps.setString(4, location);
                ps.setDouble(5, price);
                ps.setInt(6, totalSeats);
                ps.setString(7, finalImageName);
                ps.setInt(8, totalSeats);
                ps.setInt(9, Integer.parseInt(idParam));
                ps.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Database Error: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/OrganiserDashboardServlet");
    }
}