
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

@WebServlet("/edit-student")
public class EditStudentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        if (!isLoggedIn(request, response)) {
            return;
        }

        try {
            int id = Integer.parseInt(request.getParameter("id"));

            String sql = """
                    SELECT id, full_name, email, phone, course
                    FROM students WHERE id = ?
                    """;

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, id);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        request.setAttribute("student", new String[]{
                                String.valueOf(rs.getInt("id")),
                                rs.getString("full_name"),
                                rs.getString("email"),
                                rs.getString("phone"),
                                rs.getString("course")
                        });

                        request.getRequestDispatcher("/edit-student.jsp")
                               .forward(request, response);
                    } else {
                        response.sendRedirect("students?error=notfound");
                    }
                }
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("students?error=invalid");
        } catch (Exception e) {
            throw new ServletException("Could not load student.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        if (!isLoggedIn(request, response)) {
            return;
        }

        request.setCharacterEncoding("UTF-8");

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("full_name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String course = request.getParameter("course");

            if (id <= 0 || name == null || email == null || course == null
                    || name.isBlank() || email.isBlank() || course.isBlank()) {
                response.sendRedirect("students?error=invalid");
                return;
            }

            String sql = """
                    UPDATE students
                    SET full_name = ?, email = ?, phone = ?, course = ?
                    WHERE id = ?
                    """;

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, name.trim());
                ps.setString(2, email.trim());
                ps.setString(3, phone == null || phone.isBlank()
                        ? null : phone.trim());
                ps.setString(4, course.trim());
                ps.setInt(5, id);

                ps.executeUpdate();
            }

            response.sendRedirect("students?updated=1");

        } catch (NumberFormatException e) {
            response.sendRedirect("students?error=invalid");
        } catch (Exception e) {
            throw new ServletException("Could not update student.", e);
        }
    }

    private boolean isLoggedIn(HttpServletRequest request,
                               HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return false;
        }

        return true;
    }
}
