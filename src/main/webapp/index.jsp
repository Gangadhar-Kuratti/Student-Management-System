
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    if (session.getAttribute("userId") != null) {
        response.sendRedirect("dashboard.jsp");
    } else {
        response.sendRedirect("login.jsp");
    }
%>
