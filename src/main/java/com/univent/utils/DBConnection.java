package com.univent.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // Using SQLite for simplicity/portability in this project.
    // User needs to add sqlite-jdbc jar to the classpath.
    private static final String URL = "jdbc:sqlite:univent.db";

    // If using MySQL:
    // private static final String URL = "jdbc:mysql://localhost:3306/unitrade";
    // private static final String USER = "root";
    // private static final String PASS = "password";

    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        // Load driver
        try {
            Class.forName("org.sqlite.JDBC");
        } catch (ClassNotFoundException e) {
            // Fallback or specific error handling
            System.err.println("SQLite JDBC Driver not found. Make sure to include the library.");
            throw e;
        }
        return DriverManager.getConnection(URL);
    }
}
