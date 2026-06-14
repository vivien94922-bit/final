<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbutil.jsp" %>
<%
    // 1. 強制設定回應格式為標準的 JSON 格式
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");

    // 2. 獲取 Session 中的 user_id (與 getCartItems.jsp 完全對齊)
    Integer userId = (Integer) session.getAttribute("user_id");
    if (userId == null) {
        response.setStatus(401);
        out.print("{\"success\": false, \"msg\": \"請先登入\"}");
        out.flush();
        return;
    }

    // 3. 接收前端透過 fetch 傳過來的收件人資料與結帳總金額
    String name = request.getParameter("recipient_name");
    String phone = request.getParameter("recipient_phone");
    String address = request.getParameter("recipient_address");
    String payment = request.getParameter("payment");
    
    String totalParam = request.getParameter("total_amount");
    int totalAmount = 0;
    if (totalParam != null && !totalParam.trim().isEmpty()) {
        try {
            totalAmount = Integer.parseInt(totalParam);
        } catch (NumberFormatException e) {
            totalAmount = 0;
        }
    }

    // 使用 dbutil.jsp 的 getConnection() 建立連線
    try (Connection conn = getConnection()) {
        
        // 動作 A：將收件人資料與金額寫入訂單資料表
        String orderSql = "INSERT INTO orders (name, phone, address, total, payment, member_id) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement pstmtOrder = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
            pstmtOrder.setString(1, name);         
            pstmtOrder.setString(2, phone);        
            pstmtOrder.setString(3, address);      
            pstmtOrder.setInt(4, totalAmount);     
            pstmtOrder.setString(5, payment);      
            pstmtOrder.setInt(6, userId); // 🌟 這裡也對齊 user_id 寫進訂單
            
            pstmtOrder.executeUpdate();
            
            // 撈取剛剛寫入成功的真正訂單編號
            int realOrderId = 0;
            try (ResultSet rs = pstmtOrder.getGeneratedKeys()) {
                if (rs.next()) {
                    realOrderId = rs.getInt(1);
                }
            }

            /* =================================================================
               🌟 終極修正：精準清空該登入用戶在 `cart` 資料表裡的購物車商品！
               ================================================================= */
            String clearCartSql = "DELETE FROM cart WHERE user_id = ?"; 
            try (PreparedStatement pstmtClearCart = conn.prepareStatement(clearCartSql)) {
                pstmtClearCart.setInt(1, userId); 
                pstmtClearCart.executeUpdate();
            }
            /* ================================================================= */
            
            // 回傳成功的 JSON
            String jsonSuccess = "{\"success\": true, \"order_id\": " + realOrderId + ", \"msg\": \"\u8a02\u55ae\u5efa\u7acb\u6210\u529f\u4e14\u8cfc\u7269\u8eca\u5df2\u6e05\u7a7a\"}";
            out.print(jsonSuccess);
            out.flush();
        }

    } catch (Exception e) {
        e.printStackTrace(); 
        String errorMsg = e.getMessage() != null ? e.getMessage().replace("\"", "\\\"") : "Unknown Error";
        String jsonError = "{\"success\": false, \"msg\": \"\u5fac\u7aef\u767c\u751f\u932f\u8aa4\uff1a" + errorMsg + "\"}";
        out.print(jsonError);
        out.flush();
    }
%>