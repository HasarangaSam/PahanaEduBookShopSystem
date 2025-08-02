<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
    if (session == null || !"storekeeper".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp?error=Unauthorized+access");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Storekeeper Dashboard - Pahana Edu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background: url("../assets/img/backgroundNew.jpg") no-repeat center center fixed;
            background-size: cover;
        }

        .overlay {
            position: fixed;
            top: 0;
            left: 240px;
            width: calc(100% - 240px);
            height: 100vh;
            background-color: rgba(26, 35, 126, 0.2); /* deep indigo overlay */
            z-index: 1;
        }

        .main-content {
            margin-left: 240px;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            position: relative;
            z-index: 2;
            padding: 2rem;
        }

        .welcome-box {
            background-color: rgba(255, 255, 255, 0.95);
            border-radius: 12px;
            padding: 2.5rem 3rem;
            width: 100%;
            max-width: 600px;
            text-align: center;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
        }

        .welcome-box h2 {
            font-weight: 600;
            color: #1a237e;
        }

        .welcome-box p {
            color: #3949ab;
            margin-bottom: 0.75rem;
        }

        .welcome-box hr {
            border-top: 1px solid #c5cae9;
            margin: 1.5rem 0;
        }
    </style>
</head>
<body>

    <%@ include file="../sidebars/storekeeper_sidebar.jsp" %>

    <div class="overlay"></div>

    <div class="main-content">
        <div class="welcome-box">
            <h2>📦 Welcome, Storekeeper</h2>
            <p>This dashboard gives you control over item and category management in the Pahana Edu system.</p>
            <p>Use the left sidebar to manage inventory items and their categories.</p>
            <hr>
            <p><strong>System Version:</strong> 1.0.0</p>
            <p><strong>Role:</strong> Storekeeper</p>
        </div>
    </div>

    <%@ include file="../common/footer.jsp" %>

</body>
</html>
