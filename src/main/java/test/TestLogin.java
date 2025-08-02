package test;

import dao.UserDAO;
import model.User;

import java.security.MessageDigest;

public class TestLogin {


    public static void main(String[] args) {
        String username = "gayan";
        String rawPassword = "gayan123";

        // Hash the password
        String hashedPassword = hashPassword(rawPassword);

        // Print debug output
        System.out.println("Raw password: " + rawPassword);
        System.out.println("Hashed password: " + hashedPassword);

        // Use DAO to check login
        UserDAO dao = new UserDAO();
        User user = dao.getUserByCredentials(username, hashedPassword);

        if (user != null) {
            System.out.println("✅ Login success for: " + user.getUsername());
            System.out.println("Role: " + user.getRole());
        } else {
            System.out.println("❌ Login failed.");
        }
    }

    // Hash using SHA-256
    private static String hashPassword(String password) {
        try {
            password = password.trim(); // remove leading/trailing whitespace
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes("UTF-8"));

            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }

            return sb.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
