package com.lostfound.servlets;

import com.lostfound.connection.DBConnection;
import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/ApproveClaimServlet")
public class ApproveClaimServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("index.jsp");
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String itemId = request.getParameter("itemId");

        try (Connection con = DBConnection.getConnection()) {
            // Update status from PENDING to CLAIMED
            // Now the index.jsp logic will reveal phone numbers to both users
            String sql = "UPDATE items SET status = 'CLAIMED' WHERE item_id = ?";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setString(1, itemId);
            
            int updated = pst.executeUpdate();
            
            if(updated > 0) {
                response.sendRedirect("index.jsp?msg=approved");
            } else {
                response.sendRedirect("index.jsp?msg=error");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp?msg=error");
        }
    }
}