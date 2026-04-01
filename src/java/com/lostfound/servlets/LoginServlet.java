package com.lostfound.servlets;

import com.lostfound.connection.DBConnection;
import org.mindrot.jbcrypt.BCrypt;
import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // If someone types the URL directly or refreshes, take them back to login.jsp
        // This stops the "405 Method Not Allowed" error
        response.sendRedirect("login.jsp");
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // CHANGED: Match the 'name' attribute from your login.jsp
        String rollNo = request.getParameter("uroll"); 
        String pass = request.getParameter("upass");
        HttpSession session = request.getSession();

        try (Connection con = DBConnection.getConnection()) {
            // CHANGED: Query the roll_no column instead of email
            String sql = "SELECT * FROM users WHERE roll_no=?";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, rollNo);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                String storedHash = rs.getString("password");

                if (BCrypt.checkpw(pass, storedHash)) {
                    session.setAttribute("uid", rs.getInt("uid"));
                    session.setAttribute("name", rs.getString("name"));
                    session.setAttribute("role", rs.getString("role"));
                    response.sendRedirect("index.jsp");
                } else {
                    // Password mismatch
                    response.sendRedirect("login.jsp?msg=error");
                }
            } else {
                // Roll number not found
                response.sendRedirect("login.jsp?msg=error");
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
            response.sendRedirect("login.jsp?error=server");
        }
    }
}