package com.univent.admin;

import com.univent.util.DBConnection;

// --- CLOUDINARY IMPORTS ---
import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import java.util.Map;
import java.io.InputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
// ------------------------

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

        // --- IMAGE UPLOAD LOGIC ---
        Part filePart = request.getPart("imageFile");
        String finalImageName = request.getParameter("currentImage");
        // ------------------------

        // Check if a NEW file was uploaded
        if (filePart != null && filePart.getSize() > 0) {
            try {
                // 1. Check for Environment Variables
                String cloudName = System.getenv("CLOUDINARY_NAME");
                String apiKey = System.getenv("CLOUDINARY_KEY");
                String apiSecret = System.getenv("CLOUDINARY_SECRET");

                // 2. Decide Cloud Upload or Local Save
                if (cloudName != null && apiKey != null && apiSecret != null) {
                    // === A. CLOUD UPLOAD (Production) ===
                    Cloudinary cloudinary = new Cloudinary(ObjectUtils.asMap(
                            "cloud_name", cloudName,
                            "api_key", apiKey,
                            "api_secret", apiSecret
                    ));

                    // Read stream into buffer
                    InputStream fileContent = filePart.getInputStream();
                    ByteArrayOutputStream buffer = new ByteArrayOutputStream();
                    int nRead;
                    byte[] data = new byte[16384];
                    while ((nRead = fileContent.read(data, 0, data.length)) != -1) {
                        buffer.write(data, 0, nRead);
                    }
                    buffer.flush();
                    byte[] fileBytes = buffer.toByteArray();

                    // Upload
                    Map uploadResult = cloudinary.uploader().upload(fileBytes, ObjectUtils.asMap("resource_type", "auto"));
                    finalImageName = (String) uploadResult.get("secure_url");

                } else {
                    // === B. LOCAL SAVE (Localhost Fallback) ===
                    String fileName = getFileName(filePart);

                    // 1. Create path to "assets/img"
                    String uploadPath = request.getServletContext().getRealPath("") + File.separator + "assets" + File.separator + "img";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdirs();

                    // 2. Save the file
                    String fullSavePath = uploadPath + File.separator + fileName;
                    try (InputStream input = filePart.getInputStream();
                         OutputStream output = new FileOutputStream(fullSavePath)) {
                        byte[] buffer = new byte[1024];
                        int bytesRead;
                        while ((bytesRead = input.read(buffer)) != -1) {
                            output.write(buffer, 0, bytesRead);
                        }
                    }

                    // 3. Set the database value to just the filename
                    finalImageName = fileName;
                }

            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("errorMessage", "Image Upload Failed: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/OrganiserDashboardServlet");
                return;
            }
        }

        String status = "PENDING";
        if ("ADMIN".equals(role)) {
            status = "APPROVED";
        }

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

    // Helper to extract filename safely
    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "unknown.jpg";
    }
}