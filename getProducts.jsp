<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="dbutil.jsp" %>
<%@ page import="java.sql.*,org.json.*" %>
<%
    JSONArray arr = new JSONArray();
    try (Connection conn = getConn();
         PreparedStatement ps = conn.prepareStatement("SELECT * FROM products");
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            JSONObject p = new JSONObject();
            p.put("product_id",  rs.getInt("product_id"));
            p.put("name",        rs.getString("name"));
            p.put("price",       rs.getInt("price"));
            p.put("stock",       rs.getInt("stock"));
            p.put("image",       rs.getString("image"));
            p.put("description", rs.getString("description"));
            arr.put(p);
        }
    }
    out.print(arr.toString());
%>