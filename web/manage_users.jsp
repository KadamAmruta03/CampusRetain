<%@page import="java.sql.*, com.lostfound.connection.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Manage Users | Found-IT Admin</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
      


        h1 { font-size: 24px; color: #212529; margin-bottom: 5px; }
        .sub-text { color: #666; font-size: 14px; margin-bottom: 20px; }

        
        .log-table { width: 100%; border-collapse: collapse; margin-top: 20px; background: white; border-radius: 8px; overflow: hidden; }
        .log-table th, .log-table td { padding: 12px; text-align: left; border-bottom: 1px solid #eee; }
        .log-table th { background: #343a40; color: white; }
        
        /* Status Pill Badge: Using your exact CSS logic */
        .status-pill { 
            padding: 4px 12px; 
            border-radius: 20px; 
            font-size: 0.8em; 
            background: #d4edda; 
            color: #155724; 
            font-weight: 500;
            display: inline-block;
        }

        .status-pill-admin {
            background: #f8d7da;
            color: #721c24;
        }
    </style>
</head>
<body>
    <%
        // Security check
        if (session.getAttribute("name") == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }
    %>

    <div class="navbar">
        <div class="logo">Admin Control Panel</div>
        <a href="index.jsp" style="color: white; text-decoration: none;">← Back to Dashboard</a>
    </div>

    <div style="max-width: 1100px; margin: 30px auto; padding: 0 20px;">
        <h2>Registered Users</h2>
        <p style="color: #666;">A historical log of all registered campus profiles.</p>

 
        <table class="log-table">
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Email Address</th>
                    <th>Roll Number</th>
                    <th>Phone</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection con = null;
                    try {
                        con = DBConnection.getConnection();
                        String sql = "SELECT name, email, roll_no, phone, role FROM users ORDER BY name ASC";
                        PreparedStatement ps = con.prepareStatement(sql);
                        ResultSet rs = ps.executeQuery();

                        while(rs.next()) {
                            String role = rs.getString("role");
                %>
                <tr>
                    <td class="user-name-bold"><%= rs.getString("name") %></td>
                    <td><%= rs.getString("email") %></td>
                    <td><%= (rs.getString("roll_no") != null) ? rs.getString("roll_no") : "N/A" %></td>
                    <td><%= rs.getString("phone") %></td>
                    <td>
                        <span class="status-pill <%= role.equalsIgnoreCase("admin") ? "status-pill-admin" : "" %>">
                            <%= role.equalsIgnoreCase("admin") ? "Admin" : "Student" %>
                        </span>
                    </td>
                </tr>
                <%
                        }
                    } catch(Exception e) {
                        out.println("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>");
                    } finally {
                        if(con != null) con.close();
                    }
                %>
            </tbody>
        </table>
    </div>
</body>
</html>