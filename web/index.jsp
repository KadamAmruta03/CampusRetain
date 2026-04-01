<%@page import="java.sql.*, java.text.SimpleDateFormat, com.lostfound.connection.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Found-IT | Campus Dashboard</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .status-badge {
            padding: 10px; 
            border-radius: 5px; 
            font-size: 0.8em;
            font-weight: bold;
            text-transform: uppercase;
            margin-top: 5px; 
            display: block; 
            text-align: center;
            width: 100%;
            box-sizing: border-box;
        }
        .badge-available { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; } 
        .badge-pending { background: #fff3cd; color: #856404; border: 1px solid #ffeeba; }    
        .badge-claimed { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }    
        .badge-returned { background: #e9ecef; color: #495057; border: 1px solid #ced4da; }

        .admin-tag {
            background: #ff4d4d;
            color: white;
            padding: 2px 6px;
            border-radius: 4px;
            font-size: 10px;
            margin-left: 5px;
            vertical-align: middle;
        }
        
        .empty-state {
            grid-column: 1 / -1;
            text-align: center;
            padding: 50px;
            background: rgba(255, 255, 255, 0.05);
            border: 2px dotted rgba(255, 255, 255, 0.2);
            border-radius: 15px;
            margin-top: 20px;
        }
        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 12px;
        }
        .header-left {
            display: flex;
            flex-direction: column;
            align-items: flex-start;
        }
        .post-date {
            font-size: 0.75em;
            color: #999;
            font-weight: 500;
        }
    </style>
</head>
<body>
    <%
        if (session.getAttribute("name") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        int loggedInUser = (int) session.getAttribute("uid");
        String userRole = (String) session.getAttribute("role");
    %>

    <div class="navbar">
        <div class="logo">CampusRetain</div>
        
        <div style="display: flex; align-items: center; white-space: nowrap;">
            <span>Welcome, <strong><%= session.getAttribute("name") %></strong>
                <% if("admin".equals(userRole)) { %><span class="admin-tag">ADMIN</span><% } %>
            </span>
            
            <span style="margin: 0 10px; color: rgba(255,255,255,0.3);">|</span>

            <%-- ADMIN TOOLS --%>
            <% if("admin".equals(userRole)) { %>
                <a href="admin_logs.jsp" style="color: palegoldenrod; text-decoration: none; ">Return Logs</a>
                <span style="margin: 0 15px; color: rgba(255,255,255,0.3);">|</span>
                <a href="manage_users.jsp" style="color: palegoldenrod; text-decoration: none; ">Users</a>
                <span style="margin: 0 15px; color: rgba(255,255,255,0.3);">|</span>
            <% } else { %>
                <%-- STUDENT TOOLS --%>
                <a href="myactivity.jsp" style="color: palegoldenrod; text-decoration: none;">My Activity</a>
                <span style="margin: 0 15px; color: rgba(255,255,255,0.3);">|</span>
                <button id="openModal" style="background: none; border: none; color: palegoldenrod; font-size: 16px; font-family: inherit; cursor: pointer; font-weight: 500;">Post New Item</button>
                <span style="margin: 0 15px; color: rgba(255,255,255,0.3);">|</span>
            <% } %>

            <a href="logout.jsp" style="color: #ff4d4d; text-decoration: none;">Logout</a>
        </div>
    </div>

    <div style="max-width: 1200px; margin: 20px auto 0; padding: 0 20px;">
        <form action="index.jsp" method="GET" style="display: flex; gap: 10px;">
            <input type="text" name="search" placeholder="Search items..." 
                   value="<%= (request.getParameter("search") != null) ? request.getParameter("search") : "" %>"
                   style="flex-grow: 1; padding: 12px 20px; border-radius: 25px; border: 1px solid #ddd; outline: none; font-family: inherit; box-shadow: 0 2px 5px rgba(0,0,0,0.05);">
            
            <select name="category" onchange="this.form.submit()" 
                    style="padding: 0 20px; border-radius: 25px; border: 1px solid #ddd; outline: none; font-family: inherit; background: white; cursor: pointer; color: #666;">
                <option value="">All Categories</option>
                <option value="Electronics" <%= "Electronics".equals(request.getParameter("category")) ? "selected" : "" %>>Electronics</option>
                <option value="Keys" <%= "Keys".equals(request.getParameter("category")) ? "selected" : "" %>>Keys</option>
                <option value="Wallets" <%= "Wallets".equals(request.getParameter("category")) ? "selected" : "" %>>Wallets</option>
                <option value="Books" <%= "Books".equals(request.getParameter("category")) ? "selected" : "" %>>Books</option>
                <option value="Other" <%= "Other".equals(request.getParameter("category")) ? "selected" : "" %>>Other</option>
            </select>
        </form>
    </div>

    <% if(!"admin".equals(userRole)) { %>
    <div id="postModal" class="modal-overlay">
        <div class="modal-content glass-box">
            <span id="closeModal" class="close-btn">&times;</span>
            <h2 style="color: white; margin-bottom: 15px;">Report Item</h2>
            <form action="PostItemServlet" method="POST">
                <input type="text" name="title" class="input-field" placeholder="Item Name" required>
                <select name="category" class="input-field">
                    <option value="Electronics">Electronics</option>
                    <option value="ID Cards">ID Cards</option>
                    <option value="Keys">Keys</option>
                    <option value="Wallets">Wallets</option>
                    <option value="Books">Books</option>
                    <option value="Clothing">Clothing</option>
                    <option value="Other">Other</option>
                </select>
                <select name="type" class="input-field">
                    <option value="LOST">I Lost This</option>
                    <option value="FOUND">I Found This</option>
                </select>
                <textarea name="desc" class="input-field" placeholder="Description..." rows="3" required></textarea>
                <button type="submit" class="btn-submit-dark">Post Item</button>
            </form>
        </div>
    </div>
    <% } %>

    <div id="claimModal" class="modal-overlay" style="display:none;">
        <div class="modal-content glass-box" style="max-width: 420px; text-align: center;">
            <h2 style="color: white; margin-bottom: 15px;">Privacy Consent</h2>
            <p style="color: #ddd; margin-bottom: 25px; line-height: 1.6; font-size: 0.95em;">
                By clicking "Agree", your <strong>Name and Contact info</strong> will be sent to the founder. 
                They must approve your request before you can see their contact details.
            </p>
            <form action="ClaimServlet" method="POST">
                <input type="hidden" name="itemId" id="modalItemId">
                <div style="display: flex; gap: 15px; justify-content: center;">
                    <button type="submit" class="btn-claim" style="background: #28a745; border:none; padding: 10px 25px; cursor:pointer; border-radius: 5px; color: white;">I Agree</button>
                    <button type="button" onclick="closeClaimModal()" class="btn-submit-dark" style="background: #555; margin-top:0; padding: 10px 25px; cursor:pointer;">Cancel</button>
                </div>
            </form>
        </div>
    </div>

    <div class="container">
        <% if(request.getParameter("msg") != null) { %>
            <% if(request.getParameter("msg") != null) { %>
    <div id="toastMessage" class="floating-alert">
        <span style="font-size: 1.2em;">✔</span>
        <span>
            <% 
               String msg = request.getParameter("msg");
               if(msg.equals("claimed")) out.print("Item request sent to founder!"); 
               else if(msg.equals("approved")) out.print("Claim approved! Details visible."); 
               else if(msg.equals("returned")) out.print("Item marked as successfully returned."); 
               else if(msg.equals("deleted")) out.print("Post removed successfully."); 
               else if(msg.equals("posted")) out.print("Item successfully reported!"); 
            %>
        </span>
    </div>
<% } %>
        <% } %>

        <div class="item-grid">
            <% 
                Connection con = null;
                boolean hasItems = false; 
                SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy | hh:mm a");
                sdf.setTimeZone(java.util.TimeZone.getTimeZone("IST"));
                try {
                    con = DBConnection.getConnection();
                    String search = request.getParameter("search");
                    String cat = request.getParameter("category");
                    
                    StringBuilder baseSql = new StringBuilder(
    "SELECT i.*, u1.name as owner_name, u1.phone as owner_phone, u1.email as owner_email, u1.roll_no as owner_roll, " +
    "u2.uid as claimant_id, u2.name as claimant_name, u2.phone as claimant_phone, u2.email as claimant_email, u2.roll_no as claimant_roll " +
    "FROM items i " +
    "JOIN users u1 ON i.posted_by = u1.uid " +
    "LEFT JOIN claims c ON i.item_id = c.item_id " +
    "LEFT JOIN users u2 ON c.claimant_id = u2.uid WHERE 1=1 "
);

                    baseSql.append(" AND i.status != 'RETURNED' ");

                    if(search != null && !search.trim().isEmpty()) baseSql.append(" AND (i.title LIKE ? OR i.description LIKE ?) ");
                    if(cat != null && !cat.trim().isEmpty()) baseSql.append(" AND i.category = ? ");
                    baseSql.append(" ORDER BY i.item_id DESC");

                    PreparedStatement st = con.prepareStatement(baseSql.toString());
                    int pIdx = 1;
                    if(search != null && !search.trim().isEmpty()) {
                        st.setString(pIdx++, "%" + search + "%");
                        st.setString(pIdx++, "%" + search + "%");
                    }
                    if(cat != null && !cat.trim().isEmpty()) st.setString(pIdx++, cat);
                    
                    ResultSet rs = st.executeQuery();
                    while(rs.next()) { 
                        hasItems = true;
                        String desc = rs.getString("description");
                        if(desc == null || desc.trim().isEmpty()) desc = "No additional details provided.";
                        Timestamp ts = rs.getTimestamp("created_at");
                        String dateStr = (ts != null) ? sdf.format(ts) : "Recently";
                        int currentItemId = rs.getInt("item_id");
                        int postedBy = rs.getInt("posted_by");
                        int claimantIdFromDb = rs.getInt("claimant_id");
                        String status = rs.getString("status");
                        String typeClass = rs.getString("type").equalsIgnoreCase("LOST") ? "type-lost" : "type-found";
                        String badgeClass = status.equals("PENDING") ? "badge-pending" : (status.equals("CLAIMED") ? "badge-claimed" : "badge-available");
            %>
                <div class="card">
                    <div class="card-header">
                        <div class="header-left"><span class="post-date"><%= dateStr %></span></div>
                        <div class="card-type <%= typeClass %>"><%= rs.getString("type") %></div>
                    </div>
                    <h3 style="margin-top: 5px;"><%= rs.getString("title") %></h3>
                    <p style="color: #888; font-size: 0.8em; margin-bottom: 8px;">Posted by: <strong><%= rs.getString("owner_name") %></strong></p>
                    <p style="font-size: 0.9em; color: #444; min-height: 40px; margin: 10px 0;"><%= desc %></p>
                    <hr style="border: 0; border-top: 1px solid #eee; margin: 12px 0;">

                    <div style="display: flex; flex-direction: column; gap: 8px;">
                        <% if(status.equals("AVAILABLE")) { %>
                            <% if(postedBy != loggedInUser && !"admin".equals(userRole)) { %>
                                <button type="button" class="btn-claim" onclick="openClaimModal('<%= currentItemId %>')">Claim This Item</button>
                            <% } else if (postedBy == loggedInUser) { %>
                                <div class="badge-claimed" style="background: #f8f9fa; color: #6c757d; border: 1px solid #dee2e6; text-align: center; font-size: 0.8em; padding: 10px; border-radius: 5px;">Awaiting Requests</div>
                            <% } %>
                        <% } else if(status.equals("PENDING")) { %>
                            <% if(loggedInUser == postedBy) { %>
                                <div style="background: #fff3cd; padding: 10px; border-radius: 8px; border: 1px solid #ffeeba;">
                                    <p style="font-size: 0.85em; color: #856404; font-weight: bold;">Request from: <%= rs.getString("claimant_name") %></p>
                                    <form action="ApproveClaimServlet" method="POST" style="margin-top:8px;">
                                        <input type="hidden" name="itemId" value="<%= currentItemId %>">
                                        <button type="submit" class="btn-claim" style="background:#28a745; font-size: 0.8em; padding: 10px; width:100%; border:none; color:white; border-radius:5px; cursor:pointer;">Approve & Show Contact</button>
                                    </form>
                                </div>
                            <% } else if(loggedInUser == claimantIdFromDb) { %>
                                <div class="badge-claimed" style="background: #6c757d; color: white; text-align: center; font-size: 0.8em; padding: 10px; border-radius: 5px;">⌛ Request Sent. Waiting...</div>
                            <% } else { %>
                                <div class="badge-claimed" style="background: #eee; color:#999; text-align: center; font-size: 0.8em; padding: 10px; border-radius: 5px;">Item being verified</div>
                            <% } %>
                        <% } else if(status.equals("CLAIMED")) { %>
                            <div class="badge-claimed" style="background: #28a745; color: white; text-align: center; font-size: 0.8em; padding: 10px; border-radius: 5px;">✔ Handover Ready</div>
                            <% if(loggedInUser == postedBy || loggedInUser == claimantIdFromDb) { %>
                                <div style="background: #e8f5e9; padding: 10px; border-radius: 8px; font-size: 0.85em; margin-top:5px; border: 1px solid #c8e6c9; color: #2e7d32;">
                                     👤 <%= (loggedInUser == postedBy) ? rs.getString("claimant_name") : rs.getString("owner_name") %><br>
                                     🆔 Roll: <%= (loggedInUser == postedBy) ? rs.getString("claimant_roll") : rs.getString("owner_roll") %><br>
                                     📞 <%= (loggedInUser == postedBy) ? rs.getString("claimant_phone") : rs.getString("owner_phone") %>
                                </div>
                                <% if(loggedInUser == postedBy) { %>
                                    <form action="CompleteHandoverServlet" method="POST" style="margin-top:5px;">
                                        <input type="hidden" name="itemId" value="<%= currentItemId %>">
                                        <button type="submit" class="btn-claim" style="background: #007bff; border:none; width:100%; color:white; padding:10px; cursor:pointer; border-radius:5px;">Handover Completed</button>
                                    </form>
                                <% } %>
                            <% } %>
                        <% } %>

                        <span class="status-badge <%= badgeClass %>"><%= status %></span>

                        <% if(postedBy == loggedInUser || "admin".equals(userRole)) { %>
                            <a href="DeleteServlet?id=<%= currentItemId %>" 
                               style="text-align:center; font-size:0.8em; margin-top:5px; color: #dc3545; text-decoration: none; display:block;" 
                               onclick="return confirm('Delete this post permanently?')">
                               🗑 <%= ("admin".equals(userRole) && postedBy != loggedInUser) ? "Admin Delete" : "Remove Post" %>
                            </a>
                        <% } %>
                    </div>
                </div>
            <%  } 
                if (!hasItems) { %>
                <div class="empty-state">
                    <img src="https://cdn-icons-png.flaticon.com/512/7486/7486744.png" width="150" style="opacity: 0.2;">
                    <p style="color: #999; margin-top: 15px; font-size: 1.1em;">No active items.<br>Admins can view historical data in Return Logs.</p>
                </div>
            <% } 
                } catch(Exception e) { out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>"); } 
                finally { if(con!=null) con.close(); }
            %>
        </div>
    </div>

    <script>
        const postModal = document.getElementById("postModal");
        const claimModal = document.getElementById("claimModal");
        const modalInput = document.getElementById("modalItemId");

        const openBtn = document.getElementById("openModal");
        if(openBtn) openBtn.onclick = () => postModal.style.display = "flex";
        
        const closeBtn = document.getElementById("closeModal");
        if(closeBtn) closeBtn.onclick = () => postModal.style.display = "none";

        function openClaimModal(itemId) {
            modalInput.value = itemId;
            claimModal.style.display = "flex";
        }
        function closeClaimModal() {
            claimModal.style.display = "none";
        }
        window.onclick = (e) => {
            if (postModal && e.target == postModal) postModal.style.display = "none";
            if (e.target == claimModal) claimModal.style.display = "none";
        }
        // Auto-hide the floating message after 4 seconds
window.onload = function() {
    const toast = document.getElementById("toastMessage");
    if(toast) {
        setTimeout(() => {
            toast.classList.add("fade-out");
            setTimeout(() => {
                toast.remove();
            }, 500); // Wait for transition to finish
        }, 4000); // 4 seconds
    }
};
    </script>
</body>
</html>