package com.unitrade.servlets;

import com.unitrade.dao.UserDAO;
import com.unitrade.models.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private UserDAO userDAO;

    public void init() {
        userDAO = new UserDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        // Basic Validation
        if (password == null || !password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (!email.endsWith("usm.my")) {
            request.setAttribute("errorMessage", "Please use a valid USM email address.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        User newUser = new User(fullname, email, password, "student");

        if (userDAO.registerUser(newUser)) {
            // Registration success
            HttpSession session = request.getSession();
            session.setAttribute("user", newUser);
            response.sendRedirect("index.jsp");
        } else {
            // Registration failed
            request.setAttribute("errorMessage", "Registration failed. Email might already be in use.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}
