package com.univent.user;

import com.univent.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/register") // This matches the action in your register.jsp
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Retrieve parameters from the form
        String username = request.getParameter("fullname"); // Maps 'fullname' input to 'username' column
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        // Optional: Role selection (Default to STUDENT if not provided)
        String role = request.getParameter("role");
        if (role == null || role.isEmpty()) {
            role = "STUDENT";
        }

        // 2. Validate Password Match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match!");
            request.getRequestDispatcher("/user/register.jsp").forward(request, response);
            return;
        }

        // 3. Database Operation
        try (Connection con = DBConnection.getConnection()) {

            // --- FIX FOR YOUR ERROR: Handle Null Connection ---
            if (con == null) {
                request.setAttribute("errorMessage", "Database connection failed. Check server logs.");
                request.getRequestDispatcher("/user/register.jsp").forward(request, response);
                return;
            }

            // Check if user already exists
            String checkSql = "SELECT id FROM users WHERE username = ? OR email = ?";
            PreparedStatement checkPs = con.prepareStatement(checkSql);
            checkPs.setString(1, username);
            checkPs.setString(2, email);
            ResultSet rs = checkPs.executeQuery();

            if (rs.next()) {
                // User exists
                request.setAttribute("errorMessage", "Username or Email already taken!");
                request.getRequestDispatcher("/user/register.jsp").forward(request, response);
            } else {
                // Insert new user
                String insertSql = "INSERT INTO users (username, email, password, role) VALUES (?, ?, ?, ?)";
                PreparedStatement ps = con.prepareStatement(insertSql);
                ps.setString(1, username);
                ps.setString(2, email);
                ps.setString(3, password); // Note: In production, hash this password!
                ps.setString(4, role);

                int result = ps.executeUpdate();

                if (result > 0) {
                    // Success: Redirect to login
                    response.sendRedirect(request.getContextPath() + "/user/login.jsp?success=1");
                } else {
                    request.setAttribute("errorMessage", "Registration failed. Please try again.");
                    request.getRequestDispatcher("/user/register.jsp").forward(request, response);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "System Error: " + e.getMessage());
            request.getRequestDispatcher("/user/register.jsp").forward(request, response);
        }
    }
}