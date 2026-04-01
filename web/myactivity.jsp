<%@page import="java.sql.*, com.lostfound.connection.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>My Activity | Found-IT</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .activity-header { padding: 20px; color: white; text-align: center; }
        .section-title { color: palegoldenrod; margin: 20px 0; border-left: 4px solid; padding-left: 10px; }
    </style>
</head>
<body>
    <%
        if (session.getAttribute("name") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        int loggedInUser = (int) session.getAttribute("uid");
    %>

    <div class="navbar">
        <div class="logo">Found-IT Activity</div>
        <div>
            <a href="index.jsp" style="color: white; text-decoration: none; margin-right: 20px;">Back to Feed</a>
            <a href="logout.jsp" style="color: #ff4d4d; text-decoration: none;">Logout</a>
        </div>
    </div>

    <div class="container">
        <div class="activity-header">
          
            <p>Track your lost items and found reports here.</p>
        </div>

        <div class="item-grid">
            <% 
                Connection con = null;
                boolean hasActivity = false;
                try {
                    con = DBConnection.getConnection();
                    
                    // COMPLEX QUERY: Get items POSTED by user OR CLAIMED by user
                    String sql = "SELECT i.*, u1.name as owner_name, u1.phone as owner_phone, " +
                                 "u2.uid as claimant_id, u2.name as claimant_name " +
                                 "FROM items i " +
                                 "JOIN users u1 ON i.posted_by = u1.uid " +
                                 "LEFT JOIN claims c ON i.item_id = c.item_id " +
                                 "LEFT JOIN users u2 ON c.claimant_id = u2.uid " +
                                 "WHERE i.posted_by = ? OR c.claimant_id = ? " +
                                 "ORDER BY i.item_id DESC";

                    PreparedStatement st = con.prepareStatement(sql);
                    st.setInt(1, loggedInUser);
                    st.setInt(2, loggedInUser);
                    
                    ResultSet rs = st.executeQuery();
                    while(rs.next()) { 
                        hasActivity = true;
                        int postedBy = rs.getInt("posted_by");
                        String status = rs.getString("status");
            %>
                <div class="card">
                    <div class="card-type <%= rs.getString("type").toLowerCase() %>">
                        <%= (postedBy == loggedInUser) ? "MY POST" : "MY CLAIM" %>
                    </div>
                    <h3><%= rs.getString("title") %></h3>
                    <p style="font-size: 0.85em; color: #666;">Status: <strong><%= status %></strong></p>
                    
                    <hr style="border: 0; border-top: 1px solid #eee; margin: 10px 0;">

                    <% if(status.equals("PENDING") && postedBy == loggedInUser) { %>
                        <div style="background: #fff3cd; padding: 10px; border-radius: 8px;">
                            <p style="font-size: 0.8em;">Request from: <strong><%= rs.getString("claimant_name") %></strong></p>
                            <form action="ApproveClaimServlet" method="POST">
                                <input type="hidden" name="itemId" value="<%= rs.getInt("item_id") %>">
                                <button type="submit" class="btn-claim" style="background:#28a745; margin-top:5px;">Approve Request</button>
                            </form>
                        </div>
                    <% } else if(status.equals("CLAIMED")) { %>
                        <div class="badge-claimed" style="background: #d4edda; color: #155724;">Verified & Closed</div>
                    <% } else { %>
                        <p style="font-size: 0.8em; color: #888;"><%= rs.getString("description") %></p>
                    <% } %>

                    <% if(postedBy == loggedInUser) { %>
                        <a href="DeleteServlet?id=<%= rs.getInt("item_id") %>" class="delete-link" onclick="return confirm('Delete this post?')">🗑 Delete Post</a>
                    <% } %>
                </div>
            <% 
                    }
                    if (!hasActivity) {
            %>
                <div class="empty-state" style="grid-column: 1/-1;">
                    <p style="color: #999;">No personal activity yet. Go help someone!</p>
                </div>
            <%
                    }
                } catch(Exception e) { out.println(e); } 
                finally { if(con!=null) con.close(); }
            %>
        </div>
    </div>
</body>
</html>