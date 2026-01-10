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
        // Ensure you add a <select name="accountType"> in your register.jsp
        String accountType = request.getParameter("accountType");

        String role = "STUDENT"; // Default role is always STUDENT
        String roleRequest = null;

        // If user wants to be an organizer, mark it in role_request
        if ("ORGANIZER".equals(accountType)) {
            roleRequest = "ORGANIZER";
        }

        // --- Validation Logic (Same as before) ---
        if (username == null || username.trim().isEmpty() || email == null || password == null) {
            request.setAttribute("errorMessage", "All fields are required.");
            request.getRequestDispatcher("/user/register.jsp").forward(request, response);
            return;
        }
        if (!Pattern.matches(".+@.+\\.usm\\.my", email)) {
            request.setAttribute("errorMessage", "Invalid Email. Please use a valid USM email address.");
            request.getRequestDispatcher("/user/register.jsp").forward(request, response);
            return;
        }
        if (password.length() < 6) {
            request.setAttribute("errorMessage", "Password must be at least 6 characters.");
            request.getRequestDispatcher("/user/register.jsp").forward(request, response);
            return;
        }
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match!");
            request.getRequestDispatcher("/user/register.jsp").forward(request, response);
            return;
        }

        // --- Database Logic ---
        try (Connection con = DBConnection.getConnection()) {
            // Check existence
            String checkSql = "SELECT id FROM users WHERE username = ? OR email = ?";
            PreparedStatement checkPs = con.prepareStatement(checkSql);
            checkPs.setString(1, username);
            checkPs.setString(2, email);
            ResultSet rs = checkPs.executeQuery();

            if (rs.next()) {
                request.setAttribute("errorMessage", "Username or Email already taken!");
                request.getRequestDispatcher("/user/register.jsp").forward(request, response);
            } else {
                // INSERT with role_request
                String insertSql = "INSERT INTO users (username, email, password, role, role_request) VALUES (?, ?, ?, ?, ?)";
                PreparedStatement ps = con.prepareStatement(insertSql);
                ps.setString(1, username);
                ps.setString(2, email);
                ps.setString(3, password);
                ps.setString(4, role);
                ps.setString(5, roleRequest);

                int result = ps.executeUpdate();
                if (result > 0) {
                    response.sendRedirect(request.getContextPath() + "/user/login.jsp?success=1");
                } else {
                    request.setAttribute("errorMessage", "Registration failed.");
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