<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbutil.jsp" %>
<%
    // 1. 檢查使用者是否登入
    Integer sessionUserId = (Integer) session.getAttribute("user_id");
    if (sessionUserId == null) {
        // 未登入，導向登入頁面（或彈出提示）
        out.println("<script>alert('請先登入！'); location.href='login.jsp';</script>");
        return;
    }

    // 2. 接收前端傳過來的參數
    String commentIdStr = request.getParameter("comment_id");
    String productIdStr = request.getParameter("product_id"); // 刪除後要跳轉回商品頁用

    // 驗證參數是否為空
    if (commentIdStr == null || commentIdStr.trim().isEmpty() || 
        productIdStr == null || productIdStr.trim().isEmpty()) {
        out.println("<script>alert('參數錯誤！'); history.back();</script>");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;

    try {
        int commentId = Integer.parseInt(commentIdStr);
        int productId = Integer.parseInt(productIdStr);

        // 3. 建立資料庫連線（呼叫 dbutil.jsp 的方法）
        conn = getConnection();
        if (conn == null) {
            throw new SQLException("資料庫連線失敗");
        }

        /* * 4. 【安全關鍵】SQL 語法防禦機制
         * 除了指定評論的 id 之外，必須同時比對 user_id = ? 
         * 這樣就算別人猜到 comment_id，只要 user_id 對不上，就絕對刪不掉！
         */
        String sql = "DELETE FROM product_comment WHERE id = ? AND user_id = ?";
        ps = conn.prepareStatement(sql);
        ps.setInt(1, commentId);
        ps.setInt(2, sessionUserId); // 強制綁定當前登入使用者的 Session ID

        int rows = ps.executeUpdate();

        if (rows > 0) {
            // 刪除成功，利用 JavaScript 彈出提示並重新整理回商品頁
            out.println("<script>");
            out.println("alert('留言已成功刪除！');");
            out.println("location.href='product.jsp?id=" + productId + "';");
            out.println("</script>");
        } else {
            // rows == 0 代表可能：這條評論不存在，或者這條評論「不屬於目前登入的使用者」
            out.println("<script>");
            out.println("alert('刪除失敗：你沒有權限刪除此留言，或該留言已被刪除。');");
            out.println("history.back();");
            out.println("</script>");
        }

    } catch (NumberFormatException e) {
        out.println("<script>alert('格式錯誤！'); history.back();</script>");
    } catch (Exception e) {
        out.println("<script>alert('系統錯誤：" + e.getMessage() + "'); history.back();</script>");
        e.printStackTrace();
    } finally {
        // 5. 釋放資源
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>