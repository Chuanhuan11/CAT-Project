package com.univent.admin;

import com.univent.model.Event; // Ensure your Event model has get/setOrganizerId
import com.univent.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/AddEventServlet")
@MultipartConfig
public class AddEventServlet extends HttpServlet {

    // DISPLAY FORM (Check Permissions for Edit)
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");

        if (idParam != null) {
            // EDIT MODE: Fetch event details
            int eventId = Integer.parseInt(idParam);
            try (Connection con = DBConnection.getConnection()) {
                String sql = "SELECT * FROM events WHERE id = ?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, eventId);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    // OWNERSHIP CHECK
                    HttpSession session = request.getSession();
                    String role = (String) session.getAttribute("role");
                    int userId = (Integer) session.getAttribute("userId");
                    int eventOwnerId = rs.getInt("organizer_id");

                    if (!"ADMIN".equals(role) && userId != eventOwnerId) {
                        response.sendRedirect(request.getContextPath() + "/OrganiserDashboardServlet"); // Block Access
                        return;
                    }

                    // Load Data
                    Event event = new Event();
                    event.setId(rs.getInt("id"));
                    event.setTitle(rs.getString("title"));
                    event.setDescription(rs.getString("description"));
                    event.setEventDate(rs.getDate("event_date"));
                    event.setLocation(rs.getString("location"));
                    event.setPrice(rs.getDouble("price"));
                    event.setTotalSeats(rs.getInt("total_seats"));
                    event.setImageUrl(rs.getString("image_url"));

                    request.setAttribute("event", event);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        request.getRequestDispatcher("/admin/add_event.jsp").forward(request, response);
    }

    // PROCESS FORM (Save/Update)
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId"); // The logged-in Organizer/Admin

        String idParam = request.getParameter("id");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String date = request.getParameter("eventDate");
        String location = request.getParameter("location");
        double price = Double.parseDouble(request.getParameter("price"));
        int totalSeats = Integer.parseInt(request.getParameter("totalSeats"));

        // Image Upload Logic (Simplified)
        Part filePart = request.getPart("imageFile");
        String fileName = filePart.getSubmittedFileName();
        String finalImageName = request.getParameter("currentImage");

        if (fileName != null && !fileName.isEmpty()) {
            finalImageName = fileName;
            String uploadPath = getServletContext().getRealPath("") + File.separator + "assets" + File.separator + "img";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();
            filePart.write(uploadPath + File.separator + fileName);
        }

        try (Connection con = DBConnection.getConnection()) {
            if (idParam == null || idParam.isEmpty()) {
                // --- CREATE NEW EVENT ---
                String sql = "INSERT INTO events (title, description, event_date, location, price, total_seats, available_seats, image_url, organizer_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, title);
                ps.setString(2, description);
                ps.setString(3, date);
                ps.setString(4, location);
                ps.setDouble(5, price);
                ps.setInt(6, totalSeats);
                ps.setInt(7, totalSeats); // Available starts same as Total
                ps.setString(8, finalImageName);
                ps.setInt(9, userId); // <--- ASSIGN OWNER HERE
                ps.executeUpdate();
            } else {
                // --- UPDATE EXISTING EVENT ---
                String sql = "UPDATE events SET title=?, description=?, event_date=?, location=?, price=?, total_seats=?, image_url=? WHERE id=?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, title);
                ps.setString(2, description);
                ps.setString(3, date);
                ps.setString(4, location);
                ps.setDouble(5, price);
                ps.setInt(6, totalSeats);
                ps.setString(7, finalImageName);
                ps.setInt(8, Integer.parseInt(idParam));
                ps.executeUpdate();
                // Note: For strict security, you should add "AND (organizer_id = ? OR role='ADMIN')" to the WHERE clause here too.
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/OrganiserDashboardServlet");
    }
}