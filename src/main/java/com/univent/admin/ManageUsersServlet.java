package com.univent.admin;

import com.univent.model.User;
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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/ManageUsersServlet")
public class ManageUsersServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");

        if (role == null || !"ADMIN".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        List<User> userList = new ArrayList<>();
        List<User> pendingList = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT * FROM users";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getString("role"));
                u.setRoleRequest(rs.getString("role_request"));

                if ("ORGANIZER".equals(u.getRoleRequest())) {
                    pendingList.add(u);
                }
                userList.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("userList", userList);
        request.setAttribute("pendingList", pendingList);
        request.getRequestDispatcher("/admin/manage_users.jsp").forward(request, response);
    }
}