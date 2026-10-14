```jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String fullName = (String) session.getAttribute("fullName");
    if (fullName == null || fullName.trim().isEmpty()) {
        fullName = "Student";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | Student Management System</title>
    <link rel="stylesheet" href="style.css">
</head>
<body class="dashboard-page">

<div class="dashboard-layout">

    <aside class="sidebar">
        <div class="brand">
            <div class="brand-icon">S</div>
            <div>
                <h2>Student<span>Hub</span></h2>
                <small>Management System</small>
            </div>
        </div>

        <p class="menu-label">MAIN MENU</p>

        <nav class="sidebar-nav">
            <a class="nav-link active" href="dashboard.jsp">
                <span>▦</span> Dashboard
            </a>
            <a class="nav-link" href="students">
                <span>♙</span> Manage Students
            </a>
            <a class="nav-link" href="students">
                <span>＋</span> Register Student
            </a>
        </nav>

        <div class="sidebar-bottom">
            <div class="sidebar-user">
                <div class="avatar"><%= fullName.substring(0, 1).toUpperCase() %></div>
                <div class="user-info">
                    <strong><%= fullName %></strong>
                    <small>Logged-in User</small>
                </div>
            </div>
            <a class="logout-link" href="logout">↪ Logout</a>
        </div>
    </aside>

    <main class="dashboard-main">

        <header class="topbar">
            <div>
                <p class="breadcrumb">Pages / Dashboard</p>
                <h2>Dashboard</h2>
            </div>
            <div class="topbar-user">
                <div class="avatar"><%= fullName.substring(0, 1).toUpperCase() %></div>
                <div>
                    <strong><%= fullName %></strong>
                    <small>Welcome back!</small>
                </div>
            </div>
        </header>

        <section class="welcome-banner">
            <div>
                <p class="eyebrow">STUDENT MANAGEMENT</p>
                <h1>Welcome back, <%= fullName %>!</h1>
                <p>Manage student records and keep everything organized in one place.</p>
                <a class="primary-button" href="students">Manage Students <span>→</span></a>
            </div>
            <div class="welcome-art" aria-hidden="true">
                <div class="art-circle">S</div>
                <div class="art-card">✓ &nbsp; Records organized</div>
            </div>
        </section>

        <section class="section-heading">
            <div>
                <h2>Quick Overview</h2>
                <p>Access your student management tools.</p>
            </div>
        </section>

        <section class="dashboard-cards">
            <a class="dashboard-card" href="students">
                <div class="card-icon blue">♙</div>
                <div>
                    <h3>Manage Students</h3>
                    <p>View and manage student records.</p>
                </div>
                <span class="card-arrow">→</span>
            </a>

            <a class="dashboard-card" href="students">
                <div class="card-icon purple">＋</div>
                <div>
                    <h3>Student Registration</h3>
                    <p>Open the student management section to add records.</p>
                </div>
                <span class="card-arrow">→</span>
            </a>

            <a class="dashboard-card" href="logout">
                <div class="card-icon orange">↪</div>
                <div>
                    <h3>Sign Out</h3>
                    <p>Securely end your current session.</p>
                </div>
                <span class="card-arrow">→</span>
            </a>
        </section>

        <section class="notice-panel">
            <div class="notice-icon">i</div>
            <div>
                <h3>Your workspace is ready</h3>
                <p>Use Manage Students to access your student records. Statistics and recent records can be connected to MySQL next.</p>
            </div>
        </section>

        <footer class="dashboard-footer">
            StudentHub · Student Management System
        </footer>

    </main>
</div>

</body>
</html>
```