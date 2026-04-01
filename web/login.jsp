<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login | Found-IT</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;800&display=swap" rel="stylesheet">
</head>
<body class="auth-body">
    <div class="auth-overlay">
        <div class="auth-side-text">
            <h1>Helping Students, <br>One Item at a Time</h1>
            <p>Lost something? Found something? Join the network and help keep our campus organized.</p>
        </div>

        <div class="auth-side-form">
            <div class="glass-box">
                <h2>Login</h2>
                
                <% if(request.getParameter("msg") != null && request.getParameter("msg").equals("error")) { %>
                    <p style="color: #ff6b6b; text-align: center; margin-bottom: 10px; font-weight: bold;">Invalid Credentials!</p>
                <% } %>

                <%-- Change the form section of login.jsp to this --%>
                <form action="LoginServlet" method="POST">
                <input type="text" name="uroll" class="input-field" placeholder="Roll Number" required>
                <input type="password" name="upass" class="input-field" placeholder="••••••••" required>
                <button type="submit" class="btn-dark">Login</button>
                </form>

                <p class="auth-switch">Don't have an account? <a href="register.jsp">Register</a></p>
            </div>
        </div>
    </div>
</body>
</html>