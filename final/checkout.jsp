<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="dbutil.jsp" %>
<%@ page import="java.sql.*,java.util.*" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) { response.setStatus(401); out.print("{\"success\":false,\"msg\":\"請先登入\"}"); return; }

    Connection conn = null;
    try {
        conn = getConn();
        conn.setAutoCommit(false);  // ★ 開啟 Transaction

        // 1. 讀取購物車內容
        PreparedStatement cartPs = conn.prepareStatement(
            "SELECT c.cart_id, c.product_id, c.quantity, p.name, p.price, p.stock " +
            "FROM cart c JOIN products p ON c.product_id=p.product_id " +
            "WHERE c.user_id=?");
        cartPs.setInt(1, userId);
        ResultSet cartRs = cartPs.executeQuery();

        List<int[]> items = new ArrayList<>();  // [product_id, quantity, price]
        List<String> names = new ArrayList<>();
        int total = 0;
        boolean hasItem = false;

        while (cartRs.next()) {
            int pId  = cartRs.getInt("product_id");
            int qty  = cartRs.getInt("quantity");
            int price= cartRs.getInt("price");
            int stock= cartRs.getInt("stock");

            // 2. 即時檢查每項庫存
            if (stock < qty) {
                conn.rollback();
                out.print("{\"success\":false,\"msg\":\"" + cartRs.getString("name") + " 庫存不足\"}");
                return;
            }
            items.add(new int[]{pId, qty, price});
            names.add(cartRs.getString("name"));
            total += price * qty;
            hasItem = true;
        }
        if (!hasItem) {
            conn.rollback();
            out.print("{\"success\":false,\"msg\":\"購物車是空的\"}");
            return;
        }

        // 3. 建立訂單主表
        PreparedStatement orderPs = conn.prepareStatement(
            "INSERT INTO orders(user_id, total_price) VALUES(?,?)",
            Statement.RETURN_GENERATED_KEYS);
        orderPs.setInt(1, userId);
        orderPs.setInt(2, total);
        orderPs.executeUpdate();
        ResultSet genKeys = orderPs.getGeneratedKeys();
        genKeys.next();
        int orderId = genKeys.getInt(1);

        // 4. 寫入訂單明細 + 扣庫存
        PreparedStatement itemPs = conn.prepareStatement(
            "INSERT INTO order_items(order_id,product_id,name,price,quantity) VALUES(?,?,?,?,?)");
        PreparedStatement stockPs = conn.prepareStatement(
            "UPDATE products SET stock=stock-? WHERE product_id=? AND stock>=?");

        for (int i = 0; i < items.size(); i++) {
            int[] item = items.get(i);
            // 明細
            itemPs.setInt(1, orderId);
            itemPs.setInt(2, item[0]);
            itemPs.setString(3, names.get(i));
            itemPs.setInt(4, item[2]);
            itemPs.setInt(5, item[1]);
            itemPs.addBatch();
            // 扣庫存（加 stock>=qty 防止超賣）
            stockPs.setInt(1, item[1]);
            stockPs.setInt(2, item[0]);
            stockPs.setInt(3, item[1]);
            stockPs.addBatch();
        }
        itemPs.executeBatch();
        int[] stockResults = stockPs.executeBatch();
        // 確認每筆扣減都有成功（affectedRows=1）
        for (int r : stockResults) {
            if (r == 0) { conn.rollback(); out.print("{\"success\":false,\"msg\":\"庫存扣減失敗\"}"); return; }
        }

        // 5. 清空購物車
        PreparedStatement clearPs = conn.prepareStatement(
            "DELETE FROM cart WHERE user_id=?");
        clearPs.setInt(1, userId);
        clearPs.executeUpdate();

        conn.commit();  // ★ 全部成功才 commit
        out.print("{\"success\":true,\"order_id\":" + orderId + ",\"total\":" + total + "}");

    } catch (Exception e) {
        if (conn != null) conn.rollback();
        out.print("{\"success\":false,\"msg\":\"" + e.getMessage() + "\"}");
    } finally {
        if (conn != null) { conn.setAutoCommit(true); conn.close(); }
    }
%>