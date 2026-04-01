package com.lostfound.connection;
import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    public static Connection getConnection() {
        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 1. Replace [HOST] and [PORT] with the values from your Aiven Dashboard
            // 2. The database name is 'defaultdb' for Aiven
            String host = "mysql-173aebe3-kadamamruta0555-3fd6.b.aivencloud.com"; 
            String port = "24457";
            String user = "avnadmin";
            String pass = "AVNS_zSnDo4Ld4oaziuQbsuK";

            // The URL MUST include ssl-mode=REQUIRED for Aiven to work
            String url = "jdbc:mysql://" + host + ":" + port + "/defaultdb?ssl-mode=REQUIRED&serverTimezone=UTC";

            con = DriverManager.getConnection(url, user, pass);
            
            System.out.println("Cloud Database Connected Successfully!");
            
        } catch (Exception e) {
            System.out.println("Connection Failed! Check Aiven details or SSL setting.");
            e.printStackTrace();
        }
        return con;
    }
}