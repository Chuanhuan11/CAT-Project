package com.univent.admin;

import com.univent.model.Event;
import com.univent.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/AddEventServlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class AddEventServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.isEmpty()) {
            try (Connection con = DBConnection.getConnection()) {
                String sql = "SELECT * FROM events WHERE id = ?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(idParam));
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    Event e = new Event();
                    e.setId(rs.getInt("id"));
                    e.setTitle(rs.getString("title"));
                    e.setDescription(rs.getString("description"));
                    e.setEventDate(rs.getDate("event_date"));
                    e.setLocation(rs.getString("location"));
                    e.setPrice(rs.getDouble("price"));
                    e.setTotalSeats(rs.getInt("total_seats"));
                    e.setImageUrl(rs.getString("image_url")); // Load existing image
                    request.setAttribute("event", e);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        request.getRequestDispatcher("/admin/add_event.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String idParam = request.getParameter("id");
        String currentImage = request.getParameter("currentImage"); // Retrieve old image name
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String dateStr = request.getParameter("eventDate");
        String location = request.getParameter("location");

        double price = 0.0;
        int totalSeats = 0;
        try {
            price = Double.parseDouble(request.getParameter("price"));
            totalSeats = Integer.parseInt(request.getParameter("totalSeats"));
        } catch (NumberFormatException e) {
            System.err.println("Invalid number format: " + e.getMessage());
        }

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        String imageUrl = "event1.jpg";
        if (currentImage != null && !currentImage.isEmpty()) {
            imageUrl = currentImage;
        }

        Part filePart = request.getPart("imageFile"); // Matches <input name="imageFile">

        if (filePart != null && filePart.getSize() > 0) {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

            String uniqueFileName = System.currentTimeMillis() + "_" + fileName;

            String uploadPath = request.getServletContext().getRealPath("") + File.separator + "assets" + File.separator + "img";

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();

            filePart.write(uploadPath + File.separator + uniqueFileName);

            imageUrl = uniqueFileName;
        }

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps;

            if (idParam == null || idParam.isEmpty()) {
                // INSERT
                String sql = "INSERT INTO events (title, description, event_date, location, price, total_seats, available_seats, image_url, organizer_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                ps = con.prepareStatement(sql);
                ps.setString(1, title);
                ps.setString(2, description);
                ps.setDate(3, Date.valueOf(dateStr));
                ps.setString(4, location);
                ps.setDouble(5, price);
                ps.setInt(6, totalSeats);
                ps.setInt(7, totalSeats);
                ps.setString(8, imageUrl);

                if (userId != null) ps.setInt(9, userId);
                else ps.setNull(9, java.sql.Types.INTEGER);

            } else {
                // UPDATE
                String sql = "UPDATE events SET title=?, description=?, event_date=?, location=?, price=?, total_seats=?, image_url=? WHERE id=?";
                ps = con.prepareStatement(sql);
                ps.setString(1, title);
                ps.setString(2, description);
                ps.setDate(3, Date.valueOf(dateStr));
                ps.setString(4, location);
                ps.setDouble(5, price);
                ps.setInt(6, totalSeats);
                ps.setString(7, imageUrl);
                ps.setInt(8, Integer.parseInt(idParam));
            }

            ps.executeUpdate();

        } catch (Exception e) {
            System.err.println("Error saving event: " + e.getMessage());
        }

        response.sendRedirect("OrganiserDashboardServlet");
    }
}