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
import java.util.regex.Pattern;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("fullname");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");
        String role = request.getParameter("role");

        // --- 1. SERVER-SIDE INPUT VALIDATION ---

        // Check for empty fields
        if (username == null || username.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {

            request.setAttribute("errorMessage", "All fields are required.");
            request.getRequestDispatcher("/user/register.jsp").forward(request, response);
            return;
        }

        // Validate Email Domain (Must contain .usm.my)
        // Regex: Anything + @ + Anything + .usm.my
        if (!Pattern.matches(".+@.+\\.usm\\.my", email)) {
            request.setAttribute("errorMessage", "Invalid Email. Please use a valid USM email address (ending in .usm.my).");
            request.getRequestDispatcher("/user/register.jsp").forward(request, response);
            return;
        }

        // Validate Password Length
        if (password.length() < 6) {
            request.setAttribute("errorMessage", "Password must be at least 6 characters long.");
            request.getRequestDispatcher("/user/register.jsp").forward(request, response);
            return;
        }

        // Validate Password Match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match!");
            request.getRequestDispatcher("/user/register.jsp").forward(request, response);
            return;
        }

        // Default role safety
        if (role == null || role.isEmpty()) {
            role = "STUDENT";
        }

        // --- 2. DATABASE LOGIC ---
        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                request.setAttribute("errorMessage", "Database connection failed.");
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
                request.setAttribute("errorMessage", "Username or Email already taken!");
                request.getRequestDispatcher("/user/register.jsp").forward(request, response);
            } else {
                String insertSql = "INSERT INTO users (username, email, password, role) VALUES (?, ?, ?, ?)";
                PreparedStatement ps = con.prepareStatement(insertSql);
                ps.setString(1, username);
                ps.setString(2, email);
                ps.setString(3, password);
                ps.setString(4, role);

                int result = ps.executeUpdate();
                if (result > 0) {
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