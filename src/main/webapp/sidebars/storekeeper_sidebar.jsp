<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session == null || !"storekeeper".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp?error=Unauthorized+access");
        return;
    }
%>

<style>
    .sidebar {
        position: fixed;
        top: 0;
        left: 0;
        width: 240px;
        height: 100vh;
        background-color: #1a237e; /* deep indigo */
        color: #ffffff;
        padding-top: 2rem;
        z-index: 100;
    }

    .sidebar h4 {
        text-align: center;
        font-weight: bold;
        margin-bottom: 2rem;
    }

    .sidebar a {
        display: block;
        padding: 12px 24px;
        color: #c5cae9;
        text-decoration: none;
        font-size: 15px;
        transition: background 0.2s ease;
    }

    .sidebar a:hover,
    .sidebar a.active {
        background-color: #3949ab;
        color: #ffffff;
    }

    .main-content {
        margin-left: 240px;
        padding: 2rem;
    }
</style>

<!-- Storekeeper Sidebar -->
<div class="sidebar">
    <h4>📘 Pahana Edu</h4>
    <a href="../storekeeper/dashboard.jsp">📊 Dashboard</a>
    <a href="../storekeeper/manage_items.jsp">🛠️ Manage Items</a>
    <a href="../storekeeper/manage_categories.jsp">🗂️ Manage Categories</a>
    <a href="../common/help.jsp">❓ Help</a>
    <a href="../logout.jsp">🚪 Logout</a>
</div>
