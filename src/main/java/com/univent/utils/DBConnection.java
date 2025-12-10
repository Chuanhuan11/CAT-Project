package com.univent.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // MySQL Configuration
    private static final String URL = "jdbc:mysql://localhost:3306/univent";
    private static final String USER = "root"; // UPDATE THIS
    private static final String PASS = "password"; // UPDATE THIS

    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found!");
            throw e;
        }
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
