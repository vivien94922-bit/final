<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="dbutil.jsp" %>
<%
    Integer userId = (Integer) session.getAttribute("user_id");
    if (userId == null) {
        response.setStatus(401);
        out.print("{\"success\":false,\"msg\":\"請先登入\"}");
        return;
    }

    int productId = Integer.parseInt(request.getParameter("product_id"));
    int qty = 1;
    if (request.getParameter("quantity") != null) {
        qty = Integer.parseInt(request.getParameter("quantity"));
    }

    try (Connection conn = getConnection()) {
        // 檢查庫存
        PreparedStatement stockPs = conn.prepareStatement(
            "SELECT stock FROM products WHERE product_id=?");
        stockPs.setInt(1, productId);
        ResultSet stockRs = stockPs.executeQuery();
        if (!stockRs.next() || stockRs.getInt("stock") < qty) {
            out.print("{\"success\":false,\"msg\":\"庫存不足\"}");
            return;
        }

        // 已在購物車就累加，否則新增
        PreparedStatement checkPs = conn.prepareStatement(
            "SELECT cart_id, quantity FROM cart WHERE user_id=? AND product_id=?");
        checkPs.setInt(1, userId);
        checkPs.setInt(2, productId);
        ResultSet checkRs = checkPs.executeQuery();

        if (checkRs.next()) {
            PreparedStatement upPs = conn.prepareStatement(
                "UPDATE cart SET quantity=quantity+? WHERE cart_id=?");
            upPs.setInt(1, qty);
            upPs.setInt(2, checkRs.getInt("cart_id"));
            upPs.executeUpdate();
        } else {
            PreparedStatement insPs = conn.prepareStatement(
                "INSERT INTO cart(user_id,product_id,quantity) VALUES(?,?,?)");
            insPs.setInt(1, userId);
            insPs.setInt(2, productId);
            insPs.setInt(3, qty);
            insPs.executeUpdate();
        }
        out.print("{\"success\":true,\"msg\":\"已加入購物車\"}");
    } catch (Exception e) {
        out.print("{\"success\":false,\"msg\":\"" + e.getMessage() + "\"}");
    }
%>
