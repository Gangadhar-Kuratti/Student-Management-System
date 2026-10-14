
package com.sms;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("register".equals(action)) {
            register(request, response);
        } else if ("login".equals(action)) {
            login(request, response);
        } else {
            response.sendRedirect("login.jsp");
        }
    }

    private void register(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException, ServletException { 

        String fullName = request.getParameter("full_name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (fullName == null || email == null || password == null
                || fullName.isBlank() || email.isBlank()
                || password.length() < 10) {
            response.sendRedirect("register.jsp?error=invalid");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {

            String checkSql =
                    "SELECT id FROM users WHERE email = ?";

            try (PreparedStatement check =
                         con.prepareStatement(checkSql)) {

                check.setString(1, email);

                try (ResultSet rs = check.executeQuery()) {
                    if (rs.next()) {
                        response.sendRedirect(
                                "register.jsp?error=exists");
                        return;
                    }
                }
            }

            String sql = """
                    INSERT INTO users
                    (full_name, email, password_hash)
                    VALUES (?, ?, ?)
                    """;

            try (PreparedStatement ps =
                         con.prepareStatement(sql)) {

                ps.setString(1, fullName.trim());
                ps.setString(2, email.trim());
                ps.setString(3, PasswordUtil.hash(password));
                ps.executeUpdate();
            }

            response.sendRedirect("login.jsp?registered=1");

        } catch (Exception e) {
            throw new ServletException(
                    "Registration failed. Check database setup.", e);
        }
    }

    private void login(HttpServletRequest request,
                       HttpServletResponse response)
            throws IOException, ServletException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null) {
            response.sendRedirect("login.jsp?error=invalid");
            return;
        }

        String sql = """
                SELECT id, full_name, password_hash
                FROM users
                WHERE email = ?
                """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email.trim());

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next() && PasswordUtil.verify(password, rs.getString("password_hash"))) {

                    HttpSession oldSession = request.getSession(false);

                    if (oldSession != null) {
                        oldSession.invalidate();
                    }

                    HttpSession session = request.getSession(true);
                    session.setAttribute("userId", rs.getInt("id"));
                    session.setAttribute("fullName",
                            rs.getString("full_name"));

                    response.sendRedirect("dashboard.jsp");
                    return;
                }
            }

            response.sendRedirect("login.jsp?error=invalid");

        } catch (Exception e) {
            throw new ServletException(
                    "Login failed. Check database setup.", e);
        }
    }
}
