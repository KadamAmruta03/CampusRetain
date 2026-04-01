package com.lostfound.connection;
import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Grabbing values from Render's Environment Variables
            String host = "mysql-173aebe3-kadamamruta0555-3fd6.b.aivencloud.com"; 
            String port = "24457";
            String user = "avnadmin";
            String pass = "AVNS_zSnDo4Ld4oaziuQbsuK";

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