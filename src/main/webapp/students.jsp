
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String fullName = (String) session.getAttribute("fullName");
    if (fullName == null || fullName.trim().isEmpty()) {
        fullName = "Student";
    }

    List<String[]> students =
        (List<String[]>) request.getAttribute("students");

    if (students == null) {
        students = new ArrayList<>();
    }

    String initial = fullName.substring(0, 1).toUpperCase();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Students | StudentHub</title>
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
            <a class="nav-link" href="dashboard.jsp">
                <span>▦</span> Dashboard
            </a>
            <a class="nav-link active" href="students">
                <span>♙</span> Manage Students
            </a>
            <a class="nav-link" href="add-student.jsp">
                <span>＋</span> Register Student
            </a>
        </nav>

        <div class="sidebar-bottom">
            <div class="sidebar-user">
                <div class="avatar"><%= initial %></div>
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
                <p class="breadcrumb">Pages / Students</p>
                <h2>Manage Students</h2>
            </div>

            <div class="topbar-user">
                <div class="avatar"><%= initial %></div>
                <div>
                    <strong><%= fullName %></strong>
                    <small>Welcome back!</small>
                </div>
            </div>
        </header>

        <section class="welcome-banner students-banner">
            <div>
                <p class="eyebrow">STUDENT MANAGEMENT</p>
                <h1>Manage your students</h1>
                <p>View student information, update records, and keep your academic data organized.</p>
                <a class="primary-button" href="add-student.jsp">
                    + Register Student <span>→</span>
                </a>
            </div>

            <div class="welcome-art" aria-hidden="true">
                <div class="art-circle">S</div>
                <div class="art-card">✓ &nbsp; Student records</div>
            </div>
        </section>

        <section class="section-heading students-section-heading">
            <div>
                <h2>All Students</h2>
                <p>Browse and manage registered student records.</p>
            </div>
            <div class="student-count">
                <span><%= students.size() %></span> Records
            </div>
        </section>

        <section class="student-table-panel">
            <div class="table-toolbar">
                <div>
                    <h3>Student Directory</h3>
                    <p>Student details stored in your database</p>
                </div>
                <input
                    type="search"
                    id="studentSearch"
                    class="student-search"
                    placeholder="Search students..."
                    aria-label="Search students">
            </div>

            <div class="student-table-scroll">
                <table class="student-table" id="studentsTable">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Student</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Course</th>
                            <th>Actions</th>
                        </tr>
                    </thead>

                    <tbody>
                    <% for (String[] student : students) { %>
                        <tr>
                            <td>
                                <span class="student-id">#<%= student[0] %></span>
                            </td>
                            <td>
                                <div class="student-name-cell">
                                    <div class="student-mini-avatar">
                                        <%= student[1] != null && !student[1].isEmpty()
                                            ? student[1].substring(0, 1).toUpperCase()
                                            : "S" %>
                                    </div>
                                    <strong><%= student[1] == null ? "" : student[1] %></strong>
                                </div>
                            </td>
                            <td><%= student[2] == null ? "" : student[2] %></td>
                            <td><%= student[3] == null ? "" : student[3] %></td>
                            <td>
                                <span class="course-badge">
                                    <%= student[4] == null || student[4].isEmpty()
                                        ? "Not specified" : student[4] %>
                                </span>
                            </td>
                            <td>
                                <div class="student-actions">
                                    <a class="edit-action"
                                       href="edit-student?id=<%= student[0] %>">Edit</a>

                                    <form action="delete-student" method="post"
                                          onsubmit="return confirm('Delete this student?');">
                                        <input type="hidden" name="id"
                                               value="<%= student[0] %>">
                                        <button class="delete-action" type="submit">
                                            Delete
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    <% } %>

                    <% if (students.isEmpty()) { %>
                        <tr class="empty-row">
                            <td colspan="6">
                                <div class="empty-state">
                                    <div class="empty-state-icon">♙</div>
                                    <h3>No students yet</h3>
                                    <p>Register your first student to see records here.</p>
                                    <a class="primary-button" href="add-student.jsp">
                                        + Register Student
                                    </a>
                                </div>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>

            <div class="table-footer">
                Showing <strong><%= students.size() %></strong> student record(s)
            </div>
        </section>

        <footer class="dashboard-footer">
            StudentHub · Student Management System
        </footer>

    </main>
</div>

<script>
    const searchInput = document.getElementById("studentSearch");
    const studentRows = document.querySelectorAll(
        "#studentsTable tbody tr:not(.empty-row)"
    );

    searchInput.addEventListener("input", function () {
        const query = this.value.toLowerCase().trim();

        studentRows.forEach(function (row) {
            row.style.display = row.textContent.toLowerCase().includes(query)
                ? ""
                : "none";
        });
    });
</script>

</body>
</html>
