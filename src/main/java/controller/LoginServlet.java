package controller;

import dao.UserDAO;
import model.User;
import util.DBConnection;

import java.io.IOException;
import java.security.MessageDigest;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

/**
 * Handles login logic for all user roles using DAO pattern.
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    // Hash the password using SHA-256
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

        // Get form inputs
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String hashedPassword = hashPassword(password);

        // Use UserDAO to fetch the user
        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserByCredentials(username, hashedPassword);

        if (user != null) {
            // Valid user found — start session
            HttpSession session = request.getSession();
            session.setAttribute("user_id", user.getUserId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());

            // Redirect based on role
            switch (user.getRole()) {
                case "admin":
                    response.sendRedirect("admin/dashboard.jsp");
                    break;
                case "cashier":
                    response.sendRedirect("cashier/dashboard.jsp");
                    break;
                case "storekeeper":
                    response.sendRedirect("storekeeper/dashboard.jsp");
                    break;
                default:
                    response.sendRedirect("error.jsp");
            }
        } else {
            // Invalid login
            response.sendRedirect("login.jsp?error=1");
        }
    }
}
