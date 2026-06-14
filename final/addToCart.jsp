<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="dbutil.jsp" %>
<%
if (!"POST".equalsIgnoreCase(request.getMethod())) {
    response.setStatus(405);
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

    // 1. 取得總庫存
    int stock;
    try (PreparedStatement ps = conn.prepareStatement("SELECT stock FROM product WHERE id=? FOR UPDATE")) {
        ps.setInt(1, productId);
        try (ResultSet rs = ps.executeQuery()) {
            if (!rs.next()) throw new IllegalArgumentException("找不到商品");
            stock = rs.getInt("stock");
        }
    }

    // 2. [修正重點] 查詢該用戶、該商品、該尺寸「已加入」的數量
    int currentSizeQty = 0;
    try (PreparedStatement ps = conn.prepareStatement(
            "SELECT quantity FROM cart WHERE user_id=? AND product_id=? AND size=?")) {
        ps.setInt(1, userId);
        ps.setInt(2, productId);
        ps.setString(3, size);
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) currentSizeQty = rs.getInt("quantity");
        }
    }

    // 3. 檢查庫存 (現有總庫存應足以應付所有尺寸總和，這裡以總庫存為上限)
    if (currentSizeQty + quantity > stock) {
        throw new IllegalStateException("庫存不足");
    }

    // 4. 新增或更新數量
    try (PreparedStatement ps = conn.prepareStatement(
            "INSERT INTO cart(user_id,product_id,quantity,size) VALUES(?,?,?,?) " +
            "ON DUPLICATE KEY UPDATE quantity = quantity + ?")) {
        ps.setInt(1, userId);
        ps.setInt(2, productId);
        ps.setInt(3, quantity);
        ps.setString(4, size);
        ps.setInt(5, quantity); // 這是對應 ON DUPLICATE KEY UPDATE 中的 ?
        ps.executeUpdate();
    }
    
    conn.commit();
    out.print("{\"success\":true,\"msg\":\"成功加入購物車\"}");
} catch (Exception e) {
    if (conn != null) try { conn.rollback(); } catch (SQLException ignored) {}
    response.setStatus(500);
    out.print("{\"success\":false,\"msg\":\"" + e.getMessage() + "\"}");
} finally {
    if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
}
%>
