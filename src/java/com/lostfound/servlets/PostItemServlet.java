package com.lostfound.servlets;

import com.lostfound.connection.DBConnection;
import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/PostItemServlet")
public class PostItemServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        Object uidAttr = session.getAttribute("uid");
        if (uidAttr == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int userId = (int) uidAttr; 
        String title = request.getParameter("title");
        String cat = request.getParameter("category");
        String type = request.getParameter("type");
        String desc = request.getParameter("desc");

        String sql = "INSERT INTO items (title, category, type, description, posted_by, created_at) VALUES (?,?,?,?,?,?)";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            
            pst.setString(1, title);
            pst.setString(2, cat);
            pst.setString(3, type);
            pst.setString(4, desc);
            pst.setInt(5, userId);
            
            Timestamp currentTimestamp = new Timestamp(System.currentTimeMillis());
            pst.setTimestamp(6, currentTimestamp);
            
            pst.executeUpdate();
            
            // --- SUCCESS REDIRECT ---
            // This triggers your floating "Item successfully reported!" message
            response.sendRedirect("index.jsp?msg=posted");
            
        } catch (Exception e) { 
            e.printStackTrace(); 
            // --- ERROR REDIRECT ---
            response.sendRedirect("index.jsp?msg=error");
        }
    }
}