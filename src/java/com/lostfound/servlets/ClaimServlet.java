package com.lostfound.servlets;

import com.lostfound.connection.DBConnection;
import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/ClaimServlet")
public class ClaimServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("uid");
        String itemId = request.getParameter("itemId");

        Connection con = null; // Declare outside to use in catch/rollback
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false); // Start Transaction

            // 1. Update item status to PENDING
            String updateItem = "UPDATE items SET status = 'PENDING' WHERE item_id = ?";
            try (PreparedStatement pst1 = con.prepareStatement(updateItem)) {
                pst1.setString(1, itemId);
                pst1.executeUpdate();
            }

            // 2. Insert into claims table
            String insertClaim = "INSERT INTO claims (item_id, claimant_id) VALUES (?, ?)";
            try (PreparedStatement pst2 = con.prepareStatement(insertClaim)) {
                pst2.setInt(1, Integer.parseInt(itemId));
                pst2.setInt(2, userId);
                pst2.executeUpdate();
            }

            con.commit(); // Success! Save changes
            response.sendRedirect("index.jsp?msg=claimed");
            
        } catch (Exception e) {
            if (con != null) {
                try {
                    con.rollback(); // Undo changes on the SAME connection
                    System.out.println("Transaction rolled back successfully.");
                } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            response.sendRedirect("index.jsp?msg=error");
        } finally {
            // Ensure connection is closed properly
            if (con != null) {
                try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }
}