<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="dbutil.jsp" %>
<%@ page import="java.sql.*,org.json.*" %>
<%
    // 簡單管理者判斷（可改用 session role）
    String role = (String) session.getAttribute("role");
    if (!"admin".equals(role)) {
        response.setStatus(403);
        out.print("{\"success\":false,\"msg\":\"無權限\"}");
        return;
    }

    JSONArray orders = new JSONArray();
    try (Connection conn = getConn()) {
        // 讀所有訂單
        PreparedStatement ps = conn.prepareStatement(
            "SELECT o.*, m.username FROM orders o " +
            "JOIN members m ON o.user_id=m.id " +
            "ORDER BY o.create_time DESC");
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            JSONObject order = new JSONObject();
            int oid = rs.getInt("order_id");
            order.put("order_id",    oid);
            order.put("username",    rs.getString("username"));
            order.put("total_price", rs.getInt("total_price"));
            order.put("status",      rs.getString("status"));
            order.put("create_time", rs.getTimestamp("create_time").toString());

            // 讀明細
            PreparedStatement itemPs = conn.prepareStatement(
                "SELECT * FROM order_items WHERE order_id=?");
            itemPs.setInt(1, oid);
            ResultSet itemRs = itemPs.executeQuery();
            JSONArray items = new JSONArray();
            while (itemRs.next()) {
                JSONObject it = new JSONObject();
                it.put("name",     itemRs.getString("name"));
                it.put("price",    itemRs.getInt("price"));
                it.put("quantity", itemRs.getInt("quantity"));
                items.put(it);
            }
            order.put("items", items);
            orders.put(order);
        }
    }
    out.print(orders.toString());
%>