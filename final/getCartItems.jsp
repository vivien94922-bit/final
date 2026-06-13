<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbutil.jsp" %>

<%
Integer userId = (Integer) session.getAttribute("user_id");

if (userId == null) {
    response.setStatus(401);
    out.print("[]");
    return;
}

StringBuilder sb = new StringBuilder();
sb.append("[");

try (Connection conn = getConnection()) {

    PreparedStatement ps = conn.prepareStatement(
        "SELECT c.cart_id, c.product_id, c.quantity, p.name, p.price, p.image " +
        "FROM cart c JOIN products p ON c.product_id=p.product_id " +
        "WHERE c.user_id=?"
    );

    ps.setInt(1, userId);
    ResultSet rs = ps.executeQuery();

    boolean first = true;

    while (rs.next()) {
        if (!first) sb.append(",");

        sb.append("{")
          .append("\"cart_id\":").append(rs.getInt("cart_id")).append(",")
          .append("\"product_id\":").append(rs.getInt("product_id")).append(",")
          .append("\"name\":\"").append(rs.getString("name")).append("\",")
          .append("\"price\":").append(rs.getInt("price")).append(",")
          .append("\"quantity\":").append(rs.getInt("quantity")).append(",")
          .append("\"image\":\"").append(rs.getString("image")).append("\"")
          .append("}");

        first = false;
    }

} catch (Exception e) {
    out.print("[]");
    return;
}

sb.append("]");
out.print(sb.toString());
%>