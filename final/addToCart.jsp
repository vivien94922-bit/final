<%@ page contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="dbutil.jsp" %>

<%
Integer userId = (Integer) session.getAttribute("user_id");

if(userId == null){
  response.setStatus(401);
  out.print("{\"success\":false,\"msg\":\"請先登入\"}");
  return;
}

int productId = Integer.parseInt(request.getParameter("product_id"));
int qty = Integer.parseInt(request.getParameter("quantity"));
String size =request.getParameter("size");

Connection conn = getConnection();

PreparedStatement ps = conn.prepareStatement(
  "INSERT INTO cart(user_id, product_id, quantity) VALUES(?,?,?)"
);
ps.setInt(1, userId);
ps.setInt(2, productId);
ps.setInt(3, qty);

ps.executeUpdate();

out.print("{\"success\":true,\"msg\":\"已加入購物車\"}");

ps.close();
conn.close();
%>
