<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<%
request.setCharacterEncoding("UTF-8");

String productId = request.getParameter("product_id");
String username = request.getParameter("username");
String rating = request.getParameter("rating");
String content = request.getParameter("content");

Class.forName("com.mysql.cj.jdbc.Driver");

Connection conn = DriverManager.getConnection(
  "jdbc:mysql://localhost:3306/shopdb?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC",
  "root",
  "1234"
);

PreparedStatement ps = conn.prepareStatement(
  "INSERT INTO product_comment(product_id, username, rating, content) VALUES (?,?,?,?)"
);

ps.setInt(1, Integer.parseInt(productId));
ps.setString(2, username);
ps.setInt(3, Integer.parseInt(rating));
ps.setString(4, content);

ps.executeUpdate();

ps.close();
conn.close();

// 回商品頁（超重要）
response.sendRedirect("product.jsp?id=" + productId);
%>