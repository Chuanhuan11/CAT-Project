package com.univent.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    // --- CONFIGURATION ---
    // Read from Environment Variables, fallback to localhost for local testing
    private static final String DB_HOST = System.getenv("DB_HOST") != null ? System.getenv("DB_HOST") : "localhost";
    private static final String DB_PORT = System.getenv("DB_PORT") != null ? System.getenv("DB_PORT") : "3306";
    private static final String DB_NAME = System.getenv("DB_NAME") != null ? System.getenv("DB_NAME") : "univent_db";
    private static final String DB_USER = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : "root";
    private static final String DB_PASSWORD = System.getenv("DB_PASSWORD") != null ? System.getenv("DB_PASSWORD") : "";
    // ---------------------

    // --- CONNECTION METHOD ---
    public static Connection getConnection() {
        Connection con = null;
        // Construct the URL dynamically
        String url = "jdbc:mysql://" + DB_HOST + ":" + DB_PORT + "/" + DB_NAME + "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";

        try {
            // --- LOAD DRIVER & CONNECT ---
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(url, DB_USER, DB_PASSWORD);
            // -----------------------------
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            System.out.println("Database Connection Failed");
        }
        return con;
    }
}