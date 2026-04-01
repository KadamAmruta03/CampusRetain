<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Registration | Found-IT</title>
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
                <h2>Registration</h2>
                <form action="RegisterServlet" method="POST">
                    <input type="text" name="uname" class="input-field" placeholder="Full Name" required>
                    <input type="email" name="uemail" class="input-field" placeholder="Email" required>
                    
                    <%-- NEW: Roll Number Field --%>
                    <input type="text" name="uroll" class="input-field" placeholder="Roll Number (e.g. 21CS001)" required>
                    
                    <input type="password" name="upass" class="input-field" placeholder="Password" required>
                    <input type="text" name="uphone" class="input-field" placeholder="Phone Number" required>
                    
                    <button type="submit" class="btn-dark">Register</button>
                </form>

                <p class="auth-switch">Already have an account? <a href="login.jsp">Login</a></p>
            </div>
        </div>
    </div>
</body>
</html>