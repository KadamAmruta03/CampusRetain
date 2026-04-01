package com.lostfound.servlets;

import com.lostfound.connection.DBConnection;
import org.mindrot.jbcrypt.BCrypt;
import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("uname");
        String email = request.getParameter("uemail");
        String rollNo = request.getParameter("uroll"); // NEW: Capture Roll Number
        String pass = request.getParameter("upass");
        String phone = request.getParameter("uphone");

        // Hash the password using BCrypt
        String hashedPassword = BCrypt.hashpw(pass, BCrypt.gensalt());

        try (Connection con = DBConnection.getConnection()) {
            // UPDATED: Added roll_no to the columns and a 5th '?' placeholder
            String sql = "INSERT INTO users(name, email, roll_no, password, phone) VALUES(?,?,?,?,?)";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, name);
            pst.setString(2, email);
            pst.setString(3, rollNo);      // NEW: Set Roll Number
            pst.setString(4, hashedPassword); 
            pst.setString(5, phone);
            
            pst.executeUpdate();
            response.sendRedirect("login.jsp");
        } catch (Exception e) { 
            e.printStackTrace(); 
            response.sendRedirect("register.jsp?error=true");
        }
    }
}