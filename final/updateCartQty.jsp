<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="dbutil.jsp" %>
<%
    Integer userId = (Integer) session.getAttribute("user_id");
    if (userId == null) { response.setStatus(401); out.print("{\"success\":false}"); return; }

    int cartId = Integer.parseInt(request.getParameter("cart_id"));
    int qty    = Integer.parseInt(request.getParameter("quantity"));

    try (Connection conn = getConnection()) {
        if (qty <= 0) {
            PreparedStatement ps = conn.prepareStatement(
                "DELETE FROM cart WHERE cart_id=? AND user_id=?");
            ps.setInt(1, cartId); ps.setInt(2, userId);
            ps.executeUpdate();
        } else {
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE cart SET quantity=? WHERE cart_id=? AND user_id=?");
            ps.setInt(1, qty); ps.setInt(2, cartId); ps.setInt(3, userId);
            ps.executeUpdate();
        }
        out.print("{\"success\":true}");
    } catch (Exception e) {
        out.print("{\"success\":false,\"msg\":\"" + e.getMessage() + "\"}");
    }
%>
