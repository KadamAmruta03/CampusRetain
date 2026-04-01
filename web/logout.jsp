<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Logging out...</title>
    </head>
    <body>
        <%
            // Unit 1.3: Session Tracking & Invalidation
            
            // 1. Get the current session if it exists
            HttpSession userSession = request.getSession(false);
            
            if (userSession != null) {
                // 2. Remove all session attributes
                userSession.removeAttribute("uid");
                userSession.removeAttribute("name");
                
                // 3. Completely destroy the session
                userSession.invalidate();
            }
            
            // 4. Redirect the user back to the login page
            response.sendRedirect("login.jsp?msg=loggedout");
        %>
    </body>
</html>