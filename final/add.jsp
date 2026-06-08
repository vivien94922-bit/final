<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ include file="dbutil.jsp" %>

<%
request.setCharacterEncoding("UTF-8");

String productId = request.getParameter("product_id");
String userIdParam = request.getParameter("user_id");
String username = request.getParameter("username");
String rating = request.getParameter("rating");
String content = request.getParameter("content");

// 統一連線（組員D：DBUtil）
Connection conn = getConnection();

// 一併寫入 user_id，讓留言可對應會員（供留言刪除使用）
PreparedStatement ps = conn.prepareStatement(
  "INSERT INTO product_comment(product_id, user_id, username, rating, content) VALUES (?,?,?,?,?)"
);

ps.setInt(1, Integer.parseInt(productId));
if(userIdParam != null && !userIdParam.isEmpty()){
  ps.setInt(2, Integer.parseInt(userIdParam));
} else {
  ps.setNull(2, java.sql.Types.INTEGER);
}
ps.setString(3, username);
ps.setInt(4, Integer.parseInt(rating));
ps.setString(5, content);

ps.executeUpdate();

ps.close();
conn.close();

// 回商品頁（超重要）
response.sendRedirect("product.jsp?id=" + productId);
%>