package com.univent.user;

import com.univent.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the username and password the user typed in
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // --- VALIDATION ---
        // Make sure they didn't leave the fields empty
        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Please enter both username and password.");
            request.getRequestDispatcher("/user/login.jsp").forward(request, response);
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                request.setAttribute("errorMessage", "Database is offline.");
                request.getRequestDispatcher("/user/login.jsp").forward(request, response);
                return;
            }

            // Using Prepared Statement prevents SQL Injection
            String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // If we found a match, save their info in the session so they stay logged in
                HttpSession session = request.getSession();
                session.setAttribute("userId", rs.getInt("id"));
                session.setAttribute("username", rs.getString("username"));
                session.setAttribute("role", rs.getString("role"));

                String role = rs.getString("role");

                // Send them to the right page based on who they are
                if ("ADMIN".equals(role) || "ORGANIZER".equals(role)) {
                    response.sendRedirect(request.getContextPath() + "/OrganiserDashboardServlet");
                } else {
                    response.sendRedirect(request.getContextPath() + "/EventListServlet");
                }
            } else {
                // No match found, tell them it's wrong
                request.setAttribute("errorMessage", "Invalid Username or Password!");
                request.getRequestDispatcher("/user/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "System Error: " + e.getMessage());
            request.getRequestDispatcher("/user/login.jsp").forward(request, response);
        }
    }
}