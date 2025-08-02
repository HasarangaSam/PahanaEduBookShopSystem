package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
	
	private static Connection connection;

    // Database credentials
    private static final String URL = "jdbc:mysql://localhost:3306/pahanedu_db";
    private static final String USER = "root";  
    private static final String PASSWORD = ""; 

    // Private constructor to prevent instantiation
    private DBConnection() {}

    // Public method to get the single connection instance
    public static Connection getConnection() throws SQLException {
        if (connection == null || connection.isClosed()) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                connection = DriverManager.getConnection(URL, USER, PASSWORD);
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
                throw new SQLException("JDBC Driver not found.");
            }
        }
        return connection;
    }
}
