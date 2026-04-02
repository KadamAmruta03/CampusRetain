# CampusRetain: A Digital Asset Recovery Hub 

CampusRetain is a centralized web-based platform designed for educational institutions to manage "Lost and Found" items efficiently. It replaces manual registers with a real-time digital network, allowing students to report lost items, claim found items, and coordinate returns securely.

**Live Demo:** [https://campusretain.onrender.com/](https://campusretain.onrender.com/)

## Tech Stack
- **Backend:** Java Servlets (Jakarta EE 10+), Tomcat 10
- **Frontend:** JSP, CSS3 (Glassmorphism), JavaScript
- **Database:** MySQL 8.0 (Hosted on Aiven Cloud)
- **Security:** BCrypt Password Hashing, Session-based Access Control
- **Deployment:** Render Cloud Platform

## Project Structure & Directory Map
This project follows the standard Jakarta EE directory structure. Compiled `.class` files are included in the `WEB-INF/classes` directory to facilitate direct deployment on Render.

## Security Features
- **Password Hashing:** Uses `jBCrypt` to ensure no plain-text passwords are stored in the database.
- **Session Management:** Restricts access to posting and claiming items to logged-in users only.
- **Transaction Safety:** Uses SQL `COMMIT` and `ROLLBACK` to ensure data integrity during item claims.
- **Method Protection:** Custom `doGet` implementations to prevent `405 Method Not Allowed` errors during browser refreshes.

## Workflows (The "Circle of Life")
1. **Report:** User posts a found item (Status: `AVAILABLE`).
2. **Claim:** Another user claims the item (Status: `PENDING`).
3. **Approve:** The finder approves the claim (Status: `CLAIMED` - revealing contact details).
4. **Handover:** The item is physically returned (Status: `RETURNED`).

## Cloud Deployment (Render + Aiven)
To run this project in the cloud, the following Environment Variables must be configured in Render:
- `DB_HOST`: The Aiven service URI.
- `DB_PORT`: Typically `24567` for Aiven.
- `DB_USER`: Database username (default: `avnadmin`).
- `DB_PASS`: Secure password from Aiven dashboard.

## Installation
1. Clone the repository.
2. Add `mysql-connector-j` and `jbcrypt` jars to `WEB-INF/lib`.
3. Open in **NetBeans 21** (or higher).
4. Set Source/Binary format to **Java 21**.
5. Clean and Build to generate the `WEB-INF/classes` folder.
```text
CampusRetain/
├── src/                                 <-- Source Code Directory
│   └── java/
│       └── com/
│           └── lostfound/
│               ├── connection/
│               │   └── DBConnection.java       <-- Database logic (JDBC)
│               └── servlets/
│                   ├── LoginServlet.java       <-- Authentication logic
│                   ├── RegisterServlet.java    <-- User registration
│                   ├── PostItemServlet.java    <-- Reporting new items
│                   ├── ClaimServlet.java       <-- Item claim transactions
│                   ├── ApproveClaimServlet.java <-- Finder approval logic
│                   ├── DeleteServlet.java      <-- Post removal
│                   └── CompleteHandoverServlet.java <-- Final status update
├── web/                                 <-- Web Content Root
│   ├── index.jsp                        <-- Main Dashboard (Home)
│   ├── login.jsp                        <-- User Login UI
│   ├── register.jsp                     <-- User Registration UI
│   ├── css/
│   │   └── style.css                    <-- Custom Glassmorphism UI
│   ├── WEB-INF/
│   │   ├── web.xml                      <-- Deployment Descriptor
│   │   ├── lib/                         <-- External Libraries (.JAR)
│   │   │   ├── mysql-connector-j-9.x.x.jar
│   │   │   └── jbcrypt-0.4.jar
│   │   └── classes/                     <-- Compiled Bytecode (Auto-generated)
│   │       └── com/
│   │           └── lostfound/
│   │               ├── connection/
│   │               │   └── DBConnection.class
│   │               └── servlets/
│   │                   └── (All compiled Servlet .class files)
├── README.md                            <-- Documentation
└── .gitignore                           <-- Git exclusion file
```
