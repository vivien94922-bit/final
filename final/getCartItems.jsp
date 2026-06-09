<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="dbutil.jsp" %>
<%@ page import="java.sql.*" %>
<%
    Integer userId = (Integer) session.getAttribute("user_id");
    if (userId == null) {
        response.setStatus(401);
        out.print("{\"success\":false,\"msg\":\"請先登入\"}");
        return;
    }

    StringBuilder sb = new StringBuilder();
    sb.append("[");
    try (Connection conn = getConnection()) {
        PreparedStatement ps = conn.prepareStatement(
            "SELECT c.cart_id, c.product_id, c.quantity, p.name, p.price, p.image " +
            "FROM cart c JOIN products p ON c.product_id=p.product_id " +
            "WHERE c.user_id=?");
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();
        boolean first = true;
        while (rs.next()) {
            if (!first) sb.append(",");
            sb.append("{");
            sb.append("\"cart_id\":"   + rs.getInt("cart_id")        + ",");
            sb.append("\"product_id\":" + rs.getInt("product_id")    + ",");
            sb.append("\"name\":\""    + rs.getString("name")        + "\",");
            sb.append("\"price\":"     + rs.getInt("price")          + ",");
            sb.append("\"quantity\":"  + rs.getInt("quantity")       + ",");
            sb.append("\"image\":\""   + rs.getString("image")       + "\"");
            sb.append("}");
            first = false;
        }
    } catch (Exception e) {
        out.print("{\"success\":false,\"msg\":\"" + e.getMessage() + "\"}");
        return;
    }
    sb.append("]");
    out.print(sb.toString());
%>
