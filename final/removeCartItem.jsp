<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="dbutil.jsp" %>
<%
    Integer userId = (Integer) session.getAttribute("user_id");
    if (userId == null) { response.setStatus(401); out.print("{\"success\":false}"); return; }

    int cartId = Integer.parseInt(request.getParameter("cart_id"));
    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(
             "DELETE FROM cart WHERE cart_id=? AND user_id=?")) {
        ps.setInt(1, cartId); ps.setInt(2, userId);
        ps.executeUpdate();
        out.print("{\"success\":true}");
    } catch (Exception e) {
        out.print("{\"success\":false,\"msg\":\"" + e.getMessage() + "\"}");
    }
%>
