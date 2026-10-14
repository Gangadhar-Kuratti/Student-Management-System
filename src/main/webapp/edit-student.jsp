
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String[] student = (String[]) request.getAttribute("student");

    if (student == null) {
        response.sendRedirect("students");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Student</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<div class="container">
    <h1>Edit Student</h1>

    <form action="edit-student" method="post">
        <input type="hidden" name="id" value="<%= student[0] %>">

        <label for="full_name">Full Name</label>
        <input type="text" id="full_name" name="full_name"
               maxlength="100" required
               value="<%= student[1] %>">

        <label for="email">Email</label>
        <input type="email" id="email" name="email"
               maxlength="100" required
               value="<%= student[2] %>">

        <label for="phone">Phone</label>
        <input type="tel" id="phone" name="phone"
               maxlength="15"
               value="<%= student[3] == null ? "" : student[3] %>">

        <label for="course">Course</label>
        <input type="text" id="course" name="course"
               maxlength="50" required
               value="<%= student[4] %>">

        <button type="submit">Update Student</button>
    </form>

    <p><a href="students">Back to Students</a></p>
</div>

</body>
</html>
