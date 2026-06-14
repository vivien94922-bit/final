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

    // 接收參數並增加錯誤防禦
    String pIdStr = request.getParameter("product_id");
    String qtyStr = request.getParameter("quantity");
    
    if (pIdStr == null || qtyStr == null) {
        out.print("{\"success\":false,\"msg\":\"參數錯誤\"}");
        return;
    }

    int productId = Integer.parseInt(pIdStr);
    int addQty = Integer.parseInt(qtyStr);

    Connection conn = null;
    PreparedStatement psCheck = null;
    PreparedStatement psAction = null;
    ResultSet rs = null;

    try {
        conn = getConnection();
        
        // 1. 檢查該用戶購物車內是否已存在此商品
        String checkSql = "SELECT cart_id, quantity FROM cart WHERE user_id = ? AND product_id = ?";
        psCheck = conn.prepareStatement(checkSql);
        psCheck.setInt(1, userId);
        psCheck.setInt(2, productId);
        rs = psCheck.executeQuery();

        if (rs.next()) {
            // 2. 如果存在，執行更新 (累計數量)
            int cartId = rs.getInt("cart_id");
            int existingQty = rs.getInt("quantity");
            psAction = conn.prepareStatement("UPDATE cart SET quantity = ? WHERE cart_id = ?");
            psAction.setInt(1, existingQty + addQty);
            psAction.setInt(2, cartId);
        } else {
            // 3. 如果不存在，執行新增
            psAction = conn.prepareStatement("INSERT INTO cart(user_id, product_id, quantity) VALUES(?,?,?)");
            psAction.setInt(1, userId);
            psAction.setInt(2, productId);
            psAction.setInt(3, addQty);
        }

        psAction.executeUpdate();
        out.print("{\"success\":true,\"msg\":\"已加入購物車\"}");

    } catch (Exception e) {
        e.printStackTrace();
        out.print("{\"success\":false,\"msg\":\"伺服器錯誤\"}");
    } finally {
        if (rs != null) rs.close();
        if (psCheck != null) psCheck.close();
        if (psAction != null) psAction.close();
        if (conn != null) conn.close();
    }
%>
