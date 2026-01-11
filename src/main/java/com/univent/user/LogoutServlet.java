package com.univent.user;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // --- SESSION INVALIDATION ---
        HttpSession session = request.getSession(false); // Get current session
        if (session != null) {
            session.invalidate(); // Destroy session
        }
        // ----------------------------

        // --- REDIRECTION ---
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        // -------------------
    }
}