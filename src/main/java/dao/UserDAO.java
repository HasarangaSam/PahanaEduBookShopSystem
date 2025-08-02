package dao;

import model.User;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Provides data access methods for the User table.
 */
public class UserDAO {

    /**
     * Retrieves a user by username and hashed password.
     */
    public User getUserByCredentials(String username, String hashedPassword) {
        User user = null;

        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
            PreparedStatement stmt = con.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, hashedPassword);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getString("role"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return user;
    }

    /**
     * Inserts a new user (cashier or storekeeper).
     */
    public boolean insertUser(User user) {
        String sql = "INSERT INTO users (username, password, role) VALUES (?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, user.getRole());

            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Updates user information.
     * If password is null or empty, only username and role are updated.
     */
    public boolean updateUser(User user) {
        String sql;

        if (user.getPassword() != null && !user.getPassword().isEmpty()) {
            sql = "UPDATE users SET username = ?, password = ?, role = ? WHERE user_id = ?";
        } else {
            sql = "UPDATE users SET username = ?, role = ? WHERE user_id = ?";
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setString(1, user.getUsername());

            if (user.getPassword() != null && !user.getPassword().isEmpty()) {
                stmt.setString(2, user.getPassword());
                stmt.setString(3, user.getRole());
                stmt.setInt(4, user.getUserId());
            } else {
                stmt.setString(2, user.getRole());
                stmt.setInt(3, user.getUserId());
            }

            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Deletes a user by ID.
     */
    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM users WHERE user_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Gets all users except admin.
     */
    public List<User> getAllUsersExceptAdmin() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role IN ('cashier', 'storekeeper')";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement stmt = con.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setRole(rs.getString("role"));
                users.add(user);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return users;
    }
}
