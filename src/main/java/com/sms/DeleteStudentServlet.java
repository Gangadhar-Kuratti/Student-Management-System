
package com.sms;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/delete-student")
public class DeleteStudentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int id = Integer.parseInt(request.getParameter("id"));

            if (id <= 0) {
                response.sendRedirect("students?error=invalid");
                return;
            }

            String sql = "DELETE FROM students WHERE id = ?";

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, id);
                int deleted = ps.executeUpdate();

                if (deleted == 0) {
                    response.sendRedirect("students?error=notfound");
                } else {
                    response.sendRedirect("students?deleted=1");
                }
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("students?error=invalid");
        } catch (Exception e) {
            throw new java.io.IOException("Could not delete student.", e);
        }
    }
}
