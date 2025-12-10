package com.univent.user;

import com.univent.models.User;
import com.univent.util.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        // Basic Validation
        if (password == null || !password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match!");
            request.getRequestDispatcher("user/register.jsp").forward(request, response);
            return;
        }

        if (!email.endsWith("usm.my")) {
            request.setAttribute("errorMessage", "Please use a valid USM email address.");
            request.getRequestDispatcher("user/register.jsp").forward(request, response);
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            String sql = "INSERT INTO users (fullname, email, password, role) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, fullname);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, "student");

            int rows = ps.executeUpdate();
            if (rows > 0) {
                User newUser = new User(fullname, email, password, "student");
                HttpSession session = request.getSession();
                session.setAttribute("user", newUser);
                response.sendRedirect(request.getContextPath() + "/user/login.jsp?registration=success");
            } else {
                request.setAttribute("errorMessage", "Registration failed.");
                request.getRequestDispatcher("user/register.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            request.getRequestDispatcher("user/register.jsp").forward(request, response);
        }
    }
}