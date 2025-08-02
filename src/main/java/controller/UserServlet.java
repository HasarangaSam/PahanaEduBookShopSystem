package controller;

import dao.UserDAO;
import model.User;

import java.io.IOException;
import java.security.MessageDigest;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

/**
 * Handles user creation and update for Admin (Manage Users).
 */
@WebServlet("/controller/UserServlet")
public class UserServlet extends HttpServlet {

    // Hash password using SHA-256
    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Extract form parameters
        int userId = 0;
        String userIdStr = request.getParameter("user_id");
        if (userIdStr != null && !userIdStr.isEmpty()) {
            userId = Integer.parseInt(userIdStr);
        }

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        try {
            UserDAO userDAO = new UserDAO();

            // Prepare User object
            User user = new User();
            user.setUserId(userId);
            user.setUsername(username);
            user.setRole(role);

            if (password != null && !password.isEmpty()) {
                user.setPassword(hashPassword(password));
            }

            // Insert or update
            boolean success;
            if (userId == 0) {
                success = userDAO.insertUser(user);
            } else {
                success = userDAO.updateUser(user);
            }

            if (success) {
                response.sendRedirect("../admin/manage_users.jsp");
            } else {
                response.sendRedirect("../error.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("../error.jsp");
        }
    }
}
