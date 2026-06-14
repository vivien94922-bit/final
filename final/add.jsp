<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ include file="dbutil.jsp" %>
<%
request.setCharacterEncoding("UTF-8");
if (!"POST".equalsIgnoreCase(request.getMethod())) {
    response.sendError(405);
    return;
}
Integer userId = (Integer) session.getAttribute("user_id");
String username = (String) session.getAttribute("username");
if (userId == null || username == null) {
    response.sendRedirect("login.jsp");
    return;
}
int productId;
int rating;
String content = request.getParameter("content");
try {
    productId = Integer.parseInt(request.getParameter("product_id"));
    rating = Integer.parseInt(request.getParameter("rating"));
} catch (Exception e) {
    response.sendError(400);
    return;
}
content = content == null ? "" : content.trim();
if (rating < 1 || rating > 5 || content.isEmpty() || content.length() > 2000) {
    response.sendError(400);
    return;
}
try (Connection conn = getConnection();
     PreparedStatement ps = conn.prepareStatement(
       "INSERT INTO product_comment(product_id,user_id,username,rating,content) VALUES(?,?,?,?,?)")) {
    ps.setInt(1, productId);
    ps.setInt(2, userId);
    ps.setString(3, username);
    ps.setInt(4, rating);
    ps.setString(5, content);
    ps.executeUpdate();
}
response.sendRedirect("product.jsp?id=" + productId);
%>
