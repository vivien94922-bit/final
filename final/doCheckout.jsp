<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ include file="dbutil.jsp" %>
<%!
    private String jsonEscape(String value) {
        if (value == null) return "";
        return value.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\r", "\\r")
                    .replace("\n", "\\n");
    }
%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");

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

    String recipientName = request.getParameter("recipient_name");
    String phone = request.getParameter("recipient_phone");
    String address = request.getParameter("recipient_address");
    String payment = request.getParameter("payment");

    recipientName = recipientName == null ? "" : recipientName.trim();
    phone = phone == null ? "" : phone.trim();
    address = address == null ? "" : address.trim();
    payment = payment == null ? "" : payment.trim();

    boolean validPayment = "credit".equals(payment)
        || "linepay".equals(payment)
        || "cod".equals(payment);

    if (recipientName.isEmpty() || phone.isEmpty() || address.isEmpty() || !validPayment
            || recipientName.length() > 50 || phone.length() > 20 || address.length() > 255) {
        response.setStatus(400);
        out.print("{\"success\":false,\"msg\":\"請確認收件人資料與付款方式\"}");
        return;
    }

    Connection conn = null;
    try {
        conn = getConnection();
        conn.setAutoCommit(false);

        List<Object[]> cartLines = new ArrayList<Object[]>();
        Map<Integer, Object[]> productTotals = new LinkedHashMap<Integer, Object[]>();
        String cartSql =
            "SELECT c.product_id, c.quantity, c.size, p.name, p.price, p.stock " +
            "FROM cart c JOIN product p ON c.product_id = p.id " +
            "WHERE c.user_id = ? ORDER BY p.id, c.cart_id FOR UPDATE";

        try (PreparedStatement psCart = conn.prepareStatement(cartSql)) {
            psCart.setInt(1, userId);
            try (ResultSet rs = psCart.executeQuery()) {
                while (rs.next()) {
                    int productId = rs.getInt("product_id");
                    int quantity = rs.getInt("quantity");
                    if (quantity <= 0) {
                        throw new IllegalStateException("購物車內含有無效數量，請重新整理購物車");
                    }

                    String productName = rs.getString("name");
                    int price = rs.getInt("price");
                    int stock = rs.getInt("stock");
                    cartLines.add(new Object[] {
                        Integer.valueOf(productId), productName, Integer.valueOf(price),
                        rs.getString("size"), Integer.valueOf(quantity)
                    });
                    Object[] total = productTotals.get(productId);
                    if (total == null) {
                        productTotals.put(productId, new Object[] {
                            productName, Integer.valueOf(stock), Integer.valueOf(quantity)
                        });
                    } else {
                        total[2] = Integer.valueOf(((Integer) total[2]).intValue() + quantity);
                    }
                }
            }
        }

        if (cartLines.isEmpty()) {
            throw new IllegalStateException("購物車目前沒有商品");
        }

        long calculatedTotal = 0L;
        for (Map.Entry<Integer, Object[]> entry : productTotals.entrySet()) {
            Object[] line = entry.getValue();
            String productName = (String) line[0];
            int stock = ((Integer) line[1]).intValue();
            int quantity = ((Integer) line[2]).intValue();

            if (quantity > stock) {
                throw new IllegalStateException("商品「" + productName + "」庫存不足，請調整購買數量");
            }
        }
        for (Object[] line : cartLines) {
            calculatedTotal += (long) ((Integer) line[2]).intValue()
                * ((Integer) line[4]).intValue();
        }

        if (calculatedTotal <= 0L || calculatedTotal > Integer.MAX_VALUE) {
            throw new IllegalStateException("訂單金額不正確，請重新整理購物車");
        }

        int orderId;
        String orderSql =
            "INSERT INTO orders (name, phone, address, total, payment, member_id) " +
            "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement psOrder =
                conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
            psOrder.setString(1, recipientName);
            psOrder.setString(2, phone);
            psOrder.setString(3, address);
            psOrder.setInt(4, (int) calculatedTotal);
            psOrder.setString(5, payment);
            psOrder.setInt(6, userId);
            psOrder.executeUpdate();

            try (ResultSet keys = psOrder.getGeneratedKeys()) {
                if (!keys.next()) {
                    throw new SQLException("Order ID was not generated");
                }
                orderId = keys.getInt(1);
            }
        }

        String itemSql =
            "INSERT INTO order_items (order_id, product_id, name, price, size, quantity) " +
            "VALUES (?, ?, ?, ?, ?, ?)";
        String stockSql =
            "UPDATE product SET stock = stock - ? WHERE id = ? AND stock >= ?";

        try (PreparedStatement psItem = conn.prepareStatement(itemSql);
             PreparedStatement psStock = conn.prepareStatement(stockSql)) {
            for (Object[] line : cartLines) {
                int productId = ((Integer) line[0]).intValue();
                String productName = (String) line[1];
                int price = ((Integer) line[2]).intValue();
                String size = (String) line[3];
                int quantity = ((Integer) line[4]).intValue();

                psItem.setInt(1, orderId);
                psItem.setInt(2, productId);
                psItem.setString(3, productName);
                psItem.setInt(4, price);
                psItem.setString(5, size);
                psItem.setInt(6, quantity);
                psItem.addBatch();
            }

            for (Map.Entry<Integer, Object[]> entry : productTotals.entrySet()) {
                int productId = entry.getKey().intValue();
                Object[] total = entry.getValue();
                String productName = (String) total[0];
                int quantity = ((Integer) total[2]).intValue();
                psStock.setInt(1, quantity);
                psStock.setInt(2, productId);
                psStock.setInt(3, quantity);
                if (psStock.executeUpdate() != 1) {
                    throw new IllegalStateException("商品「" + productName + "」庫存不足，請調整購買數量");
                }
            }
            psItem.executeBatch();
        }

        try (PreparedStatement psClear =
                conn.prepareStatement("DELETE FROM cart WHERE user_id = ?")) {
            psClear.setInt(1, userId);
            psClear.executeUpdate();
        }

        conn.commit();
        out.print("{\"success\":true,\"order_id\":" + orderId
            + ",\"total\":" + calculatedTotal
            + ",\"msg\":\"訂單建立成功\"}");
    } catch (IllegalStateException e) {
        if (conn != null) {
            try { conn.rollback(); } catch (SQLException ignored) {}
        }
        response.setStatus(409);
        out.print("{\"success\":false,\"msg\":\"" + jsonEscape(e.getMessage()) + "\"}");
    } catch (Exception e) {
        if (conn != null) {
            try { conn.rollback(); } catch (SQLException ignored) {}
        }
        application.log("Checkout failed for member ID " + userId, e);
        response.setStatus(500);
        out.print("{\"success\":false,\"msg\":\"系統暫時無法建立訂單，請稍後再試\"}");
    } finally {
        if (conn != null) {
            try { conn.close(); } catch (SQLException ignored) {}
        }
    }
%>
