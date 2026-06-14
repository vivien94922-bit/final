<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="dbutil.jsp" %>
<%
if (!"POST".equalsIgnoreCase(request.getMethod())) {
    response.setStatus(405);
    out.print("{\"success\":false,\"message\":\"Method not allowed\"}");
    return;
}
Integer userId = (Integer) session.getAttribute("user_id");
if (userId == null) {
    response.setStatus(401);
    out.print("{\"success\":false,\"message\":\"Unauthorized\"}");
    return;
}
int cartId;
int quantity;
try {
    cartId = Integer.parseInt(request.getParameter("cart_id"));
    quantity = Integer.parseInt(request.getParameter("quantity"));
} catch (Exception e) {
    response.setStatus(400);
    out.print("{\"success\":false,\"message\":\"Invalid request\"}");
    return;
}

Connection conn = null;
try {
    conn = getConnection();
    conn.setAutoCommit(false);
    if (quantity <= 0) {
        try (PreparedStatement ps = conn.prepareStatement(
                "DELETE FROM cart WHERE cart_id=? AND user_id=?")) {
            ps.setInt(1, cartId);
            ps.setInt(2, userId);
            if (ps.executeUpdate() != 1) {
                conn.rollback();
                response.setStatus(404);
                out.print("{\"success\":false,\"message\":\"Cart item not found\"}");
                return;
            }
        }
    } else {
        int productId;
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT product_id FROM cart WHERE cart_id=? AND user_id=? FOR UPDATE")) {
            ps.setInt(1, cartId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    conn.rollback();
                    response.setStatus(404);
                    out.print("{\"success\":false,\"message\":\"Cart item not found\"}");
                    return;
                }
                productId = rs.getInt("product_id");
            }
        }
        int stock;
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT stock FROM product WHERE id=? FOR UPDATE")) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) throw new SQLException("Product not found");
                stock = rs.getInt("stock");
            }
        }
        int otherQuantity = 0;
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT COALESCE(SUM(quantity),0) FROM cart " +
                "WHERE user_id=? AND product_id=? AND cart_id<>?")) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ps.setInt(3, cartId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) otherQuantity = rs.getInt(1);
            }
        }
        if (otherQuantity + quantity > stock) {
            conn.rollback();
            response.setStatus(409);
            out.print("{\"success\":false,\"message\":\"庫存不足，最多可設定為 "
                + Math.max(0, stock - otherQuantity) + " 件\"}");
            return;
        }
        try (PreparedStatement ps = conn.prepareStatement(
                "UPDATE cart SET quantity=? WHERE cart_id=? AND user_id=?")) {
            ps.setInt(1, quantity);
            ps.setInt(2, cartId);
            ps.setInt(3, userId);
            ps.executeUpdate();
        }
    }
    conn.commit();
    out.print("{\"success\":true}");
} catch (Exception e) {
    if (conn != null) try { conn.rollback(); } catch (SQLException ignored) {}
    e.printStackTrace();
    response.setStatus(500);
    out.print("{\"success\":false}");
} finally {
    if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
}
%>
