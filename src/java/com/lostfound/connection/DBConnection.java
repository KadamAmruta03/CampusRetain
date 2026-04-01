package com.lostfound.connection;
import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Grabbing values from Render's Environment Variables
            String host = System.getenv("DB_HOST"); 
            String port = System.getenv("DB_PORT");
            String user = System.getenv("DB_USER");
            String pass = System.getenv("DB_PASS");

            // The URL construction remains the same
            String url = "jdbc:mysql://" + host + ":" + port + "/defaultdb?ssl-mode=REQUIRED&serverTimezone=UTC";

            con = DriverManager.getConnection(url, user, pass);
            System.out.println("Cloud Database Connected Successfully via Environment Variables!");
            
        } catch (Exception e) {
            System.out.println("Connection Failed! Check Render Environment Variables.");
            e.printStackTrace();
        }
        return con;
    }
}