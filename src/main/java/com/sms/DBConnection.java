
package com.sms;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import io.github.cdimascio.dotenv.Dotenv;

public class DBConnection {

    private static final Dotenv dotenv = Dotenv.configure()
            .ignoreIfMissing()
            .load();

    private static final String URL =
            getSetting("DB_URL");

    private static final String USER =
            getSetting("DB_USER");

    private static final String PASSWORD =
            getSetting("DB_PASSWORD");

    private static String getSetting(String key) {
        String value = System.getenv(key);

        if (value == null || value.isBlank()) {
            value = dotenv.get(key);
        }

        if (value == null || value.isBlank()) {
            throw new IllegalStateException(
                    "Missing database configuration: " + key);
        }

        return value;
    }

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException(
                    "MySQL JDBC driver could not be loaded.", e);
        }

        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
