<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="dbutil.jsp" %>
<%
if (!"POST".equalsIgnoreCase(request.getMethod())) {
    response.setStatus(405);
    response.setHeader("Allow", "POST");
    out.print("{\"success\":false,\"msg\":\"不支援的請求方式\"}");
    return;
}
Integer userId = (Integer) session.getAttribute("user_id");
if (userId == null) {
    response.setStatus(401);
    out.print("{\"success\":false,\"msg\":\"請先登入\"}");
    return;
}

int productId;
int quantity;
try {
    productId = Integer.parseInt(request.getParameter("product_id"));
    quantity = Integer.parseInt(request.getParameter("quantity"));
} catch (Exception e) {
    response.setStatus(400);
    out.print("{\"success\":false,\"msg\":\"商品或數量資料不正確\"}");
    return;
}
String size = request.getParameter("size");
size = size == null ? "M" : size.trim().toUpperCase();
if (quantity <= 0 || (!"S".equals(size) && !"M".equals(size) && !"L".equals(size))) {
    response.setStatus(400);
    out.print("{\"success\":false,\"msg\":\"請選擇正確尺寸與數量\"}");
    return;
}

Connection conn = null;
try {
    conn = getConnection();
    conn.setAutoCommit(false);

    int stock;
    try (PreparedStatement ps = conn.prepareStatement(
            "SELECT stock FROM product WHERE id=? FOR UPDATE")) {
        ps.setInt(1, productId);
        try (ResultSet rs = ps.executeQuery()) {
            if (!rs.next()) throw new IllegalArgumentException("找不到商品");
            stock = rs.getInt("stock");
        }
    }

    int currentTotal = 0;
    try (PreparedStatement ps = conn.prepareStatement(
            "SELECT COALESCE(SUM(quantity),0) FROM cart WHERE user_id=? AND product_id=?")) {
        ps.setInt(1, userId);
        ps.setInt(2, productId);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) currentTotal = rs.getInt(1);
        }
    }
    if (currentTotal + quantity > stock) {
        throw new IllegalStateException("庫存不足，目前最多可再加入 " + Math.max(0, stock - currentTotal) + " 件");
    }

    try (PreparedStatement ps = conn.prepareStatement(
            "INSERT INTO cart(user_id,product_id,quantity,size) VALUES(?,?,?,?) " +
            "ON DUPLICATE KEY UPDATE quantity=quantity+VALUES(quantity)")) {
        ps.setInt(1, userId);
        ps.setInt(2, productId);
        ps.setInt(3, quantity);
        ps.setString(4, size);
        ps.executeUpdate();
    }
    conn.commit();
    out.print("{\"success\":true,\"msg\":\"成功加入購物車\"}");
} catch (IllegalArgumentException e) {
    if (conn != null) try { conn.rollback(); } catch (SQLException ignored) {}
    response.setStatus(404);
    out.print("{\"success\":false,\"msg\":\"找不到商品\"}");
} catch (IllegalStateException e) {
    if (conn != null) try { conn.rollback(); } catch (SQLException ignored) {}
    response.setStatus(409);
    out.print("{\"success\":false,\"msg\":\"" + e.getMessage() + "\"}");
} catch (Exception e) {
    if (conn != null) try { conn.rollback(); } catch (SQLException ignored) {}
    response.setStatus(500);
    out.print("{\"success\":false,\"msg\":\"處理失敗: " + e.getMessage() + "\"}");
} finally {
    if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
}
%>
