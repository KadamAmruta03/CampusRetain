package com.lostfound.servlets;

import com.lostfound.connection.DBConnection;
import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/DeleteServlet")
public class DeleteServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String itemId = request.getParameter("id");
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("uid");
        String userRole = (String) session.getAttribute("role"); // Get role from session

        if (userId == null || itemId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false); 

            // 1. Delete associated claims first
            String sqlClaims = "DELETE FROM claims WHERE item_id = ?";
            try (PreparedStatement pst1 = con.prepareStatement(sqlClaims)) {
                pst1.setString(1, itemId);
                pst1.executeUpdate();
            }

            // 2. Updated Item Delete Logic
            String sqlItem;
            PreparedStatement pst2;

            if ("admin".equals(userRole)) {
                // If Admin, delete by ID only (Master Power)
                sqlItem = "DELETE FROM items WHERE item_id = ?";
                pst2 = con.prepareStatement(sqlItem);
                pst2.setString(1, itemId);
            } else {
                // If regular user, must match posted_by (Security)
                sqlItem = "DELETE FROM items WHERE item_id = ? AND posted_by = ?";
                pst2 = con.prepareStatement(sqlItem);
                pst2.setString(1, itemId);
                pst2.setInt(2, userId);
            }

            pst2.executeUpdate();
            pst2.close();

            con.commit(); 
            response.sendRedirect("index.jsp?msg=deleted");

        } catch (Exception e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            response.sendRedirect("index.jsp?msg=error");
        } finally {
            if (con != null) {
                try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }
}