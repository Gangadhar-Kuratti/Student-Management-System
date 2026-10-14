
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account | Student Management</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <main class="login-container">
        <section class="login-card">
            <h1>Create Account</h1>
            <p class="subtitle">Set up your student management account</p>

            <% if ("exists".equals(request.getParameter("error"))) { %>
                <p class="error">This email is already registered.</p>
            <% } %>

            <form action="auth" method="post">
                <input type="hidden" name="action" value="register">

                <label for="full_name">Full Name</label>
                <input type="text" id="full_name" name="full_name"
                       maxlength="100" placeholder="Enter your full name"
                       required>

                <label for="email">Email Address</label>
                <input type="email" id="email" name="email"
                       maxlength="100" placeholder="you@example.com"
                       required>

                <label for="password">Password</label>
                <input type="password" id="password" name="password"
                       minlength="10" placeholder="At least 10 characters"
                       required>

                <button type="submit">Create Account</button>
            </form>

            <p class="signup-link">
                Already have an account?
                <a href="login.jsp">Login</a>
            </p>
        </section>
    </main>
</body>
</html>
