
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | Student Management</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <main class="login-container">
        <section class="login-card">
            <h1>Welcome Back</h1>
            <p class="subtitle">Sign in to your student dashboard</p>

            <% if ("1".equals(request.getParameter("error"))) { %>
                <p class="error">Invalid email or password.</p>
            <% } %>

            <% if ("1".equals(request.getParameter("registered"))) { %>
                <p class="success">Account created! Please log in.</p>
            <% } %>

            <form action="auth" method="post">
                <input type="hidden" name="action" value="login">

                <label for="email">Email Address</label>
                <input type="email" id="email" name="email"
                       placeholder="you@example.com" required>

                <label for="password">Password</label>
                <input type="password" id="password" name="password"
                       placeholder="Enter your password" required>

                <button type="submit">Login</button>
            </form>

            <p class="signup-link">
                Don't have an account?
                <a href="register.jsp">Create Account</a>
            </p>
        </section>
    </main>
</body>
</html>
