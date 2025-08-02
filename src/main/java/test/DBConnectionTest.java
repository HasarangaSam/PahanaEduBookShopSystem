package test;

import util.DBConnection;

import java.sql.Connection;
import java.sql.SQLException;

public class DBConnectionTest {
    public static void main(String[] args) {
        try {
            Connection con = DBConnection.getConnection();
            if (con != null && !con.isClosed()) {
                System.out.println("✅ Database connection successful!");
            } else {
                System.out.println("❌ Database connection failed.");
            }
        } catch (SQLException e) {
            System.out.println("❌ SQL Exception occurred: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("❌ Unexpected Exception: " + e.getMessage());
        }
    }
}