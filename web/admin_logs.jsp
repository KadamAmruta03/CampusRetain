<%@page import="java.sql.*, java.text.SimpleDateFormat, com.lostfound.connection.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Logs | Found-IT</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .log-table { width: 100%; border-collapse: collapse; margin-top: 20px; background: white; border-radius: 8px; overflow: hidden; }
        .log-table th, .log-table td { padding: 12px; text-align: left; border-bottom: 1px solid #eee; }
        .log-table th { background: #343a40; color: white; }
        .status-pill { padding: 4px 8px; border-radius: 20px; font-size: 0.8em; background: #d4edda; color: #155724; }
    </style>
</head>
<body style="background: #f4f7f6;">
    <%
        String role = (String) session.getAttribute("role");
        if (session.getAttribute("name") == null || !"admin".equals(role)) {
            response.sendRedirect("login.jsp");
            return;
        }
    %>

    <div class="navbar">
        <div class="logo">Admin Control Panel</div>
        <a href="index.jsp" style="color: white; text-decoration: none;">← Back to Dashboard</a>
    </div>

    <div style="max-width: 1100px; margin: 30px auto; padding: 0 20px;">
        <h2>Successfully Returned Items</h2>
        <p style="color: #666;">A historical log of all items that reached their rightful owners.</p>

        <table class="log-table">
            <thead>
                <tr>
                    <th>Date</th>
                    <th>Item Name</th>
                    <th>Founder</th>
                    <th>Claimant</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try (Connection con = DBConnection.getConnection();
                         PreparedStatement st = con.prepareStatement(
                            "SELECT i.title, i.created_at, u1.name as founder, u2.name as claimant " +
                            "FROM items i " +
                            "JOIN users u1 ON i.posted_by = u1.uid " +
                            "JOIN claims c ON i.item_id = c.item_id " +
                            "JOIN users u2 ON c.claimant_id = u2.uid " +
                            "WHERE i.status = 'RETURNED' ORDER BY i.item_id DESC")) {
                        
                        ResultSet rs = st.executeQuery();
                        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");
                        
                        while(rs.next()) {
                %>
                    <tr>
                        <td><%= sdf.format(rs.getTimestamp("created_at")) %></td>
                        <td><strong><%= rs.getString("title") %></strong></td>
                        <td><%= rs.getString("founder") %></td>
                        <td><%= rs.getString("claimant") %></td>
                        <td><span class="status-pill">Completed</span></td>
                    </tr>
                <% 
                        }
                    } catch(Exception e) { e.printStackTrace(); }
                %>
            </tbody>
        </table>
    </div>
</body>
</html>