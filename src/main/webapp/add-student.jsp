
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Student</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<div class="container">
    <h1>Add New Student</h1>

    <form action="add-student" method="post">
        <label for="full_name">Full Name</label>
        <input type="text" id="full_name" name="full_name"
               maxlength="100" required>

        <label for="email">Email</label>
        <input type="email" id="email" name="email"
               maxlength="100" required>

        <label for="phone">Phone</label>
        <input type="tel" id="phone" name="phone"
               maxlength="15">

        <label for="course">Course</label>
        <input type="text" id="course" name="course"
               maxlength="50" required>

        <button type="submit">Save Student</button>
    </form>

    <p><a href="students">Back to Students</a></p>
</div>

</body>
</html>
