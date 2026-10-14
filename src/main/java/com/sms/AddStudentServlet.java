
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
import java.sql.SQLException;

@WebServlet("/add-student")
public class AddStudentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        request.setCharacterEncoding("UTF-8");

        String fullName = request.getParameter("full_name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String course = request.getParameter("course");

        if (fullName == null || email == null || course == null
                || fullName.isBlank() || email.isBlank()
                || course.isBlank()) {
            response.sendRedirect("add-student.jsp?error=invalid");
            return;
        }

        String sql = """
                INSERT INTO students (full_name, email, phone, course)
                VALUES (?, ?, ?, ?)
                """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, fullName.trim());
            ps.setString(2, email.trim());
            ps.setString(3, phone == null || phone.isBlank()
                    ? null : phone.trim());
            ps.setString(4, course.trim());

            ps.executeUpdate();

            response.sendRedirect("students?added=1");

        } catch (SQLException e) {
            if ("23000".equals(e.getSQLState())) {
                response.sendRedirect("add-student.jsp?error=duplicate");
            } else {
                throw new ServletException("Could not save student.", e);
            }
        }
    }
}
