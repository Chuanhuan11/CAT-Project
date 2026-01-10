package com.univent.admin;

import com.univent.util.DBConnection;

// --- CLOUDINARY IMPORTS ---
import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import java.util.Map;
import java.io.InputStream;
import java.io.ByteArrayOutputStream; // Import added
// --------------------------

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
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
        String role = (String) session.getAttribute("role");

        // Role Validation
        if (userId == null || role == null || (!"ADMIN".equals(role) && !"ORGANIZER".equals(role))) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

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

        // Server Side Safety Check
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

        // --- IMAGE UPLOAD LOGIC (CLOUDINARY) ---
        Part filePart = request.getPart("imageFile");
        String finalImageName = request.getParameter("currentImage"); // Keep existing URL by default

        // Check if a NEW file was uploaded
        if (filePart != null && filePart.getSize() > 0) {
            try {
                // 1. Configure Cloudinary
                String cloudName = System.getenv("CLOUDINARY_NAME");
                String apiKey = System.getenv("CLOUDINARY_KEY");
                String apiSecret = System.getenv("CLOUDINARY_SECRET");

                if (cloudName == null || apiKey == null || apiSecret == null) {
                    throw new Exception("Cloudinary environment variables not set!");
                }

                Cloudinary cloudinary = new Cloudinary(ObjectUtils.asMap(
                        "cloud_name", cloudName,
                        "api_key", apiKey,
                        "api_secret", apiSecret
                ));

                // 2. READ STREAM INTO BYTE ARRAY (Fixes "Unrecognized file parameter")
                InputStream fileContent = filePart.getInputStream();
                ByteArrayOutputStream buffer = new ByteArrayOutputStream();
                int nRead;
                byte[] data = new byte[16384]; // 16kb buffer
                while ((nRead = fileContent.read(data, 0, data.length)) != -1) {
                    buffer.write(data, 0, nRead);
                }
                buffer.flush();
                byte[] fileBytes = buffer.toByteArray();

                // 3. UPLOAD THE BYTES
                Map uploadResult = cloudinary.uploader().upload(fileBytes, ObjectUtils.asMap("resource_type", "auto"));

                // 4. Get the secure public URL
                finalImageName = (String) uploadResult.get("secure_url");

            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("errorMessage", "Image Upload Failed: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/OrganiserDashboardServlet");
                return;
            }
        }
        // ---------------------------------------

        // --- STATUS LOGIC ---
        String status = "PENDING";
        if ("ADMIN".equals(role)) {
            status = "APPROVED"; // Admins auto-approve
        }
        // --------------------

        try (Connection con = DBConnection.getConnection()) {
            if (idParam == null || idParam.isEmpty()) {
                // INSERT
                String sql = "INSERT INTO events (title, description, event_date, location, price, total_seats, available_seats, image_url, organizer_id, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
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
                ps.setString(10, status);
                ps.executeUpdate();
            } else {
                // UPDATE
                String sql = "UPDATE events SET title=?, description=?, event_date=?, location=?, price=?, total_seats=?, image_url=?, status=?, available_seats = ? - (SELECT COUNT(*) FROM bookings WHERE event_id = events.id AND status='CONFIRMED') WHERE id=?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, title);
                ps.setString(2, description);
                ps.setString(3, date);
                ps.setString(4, location);
                ps.setDouble(5, price);
                ps.setInt(6, totalSeats);
                ps.setString(7, finalImageName);
                ps.setString(8, status);
                ps.setInt(9, totalSeats);
                ps.setInt(10, Integer.parseInt(idParam));
                ps.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Database Error: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/OrganiserDashboardServlet");
    }
}