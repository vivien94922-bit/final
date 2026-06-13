<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*"%>
<%@ include file="dbutil.jsp" %>

<%
Integer userId = (Integer) session.getAttribute("user_id");

// 1. 如果未登入，直接回傳空陣列並結束
if (userId == null) {
    out.print("[]");
    return;
}

Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {
    conn = getConnection();
    
    // 💡 注意：請確認您的資料庫表名是 product 還是 products？（看您第一張截圖噴錯是 products.js，確認一下喔）
    String sql = "SELECT p.id, p.name, p.price, p.image " +
                 "FROM favorite f JOIN product p ON f.product_id = p.id " +
                 "WHERE f.user_id=?";
                 
    ps = conn.prepareStatement(sql);
    ps.setInt(1, userId);
    rs = ps.executeQuery();

    out.print("[");
    boolean first = true;

    while (rs.next()) {
        if (!first) out.print(",");
        first = false;

        String name = rs.getString("name").replace("\"", "\\\"");
        String image = rs.getString("image");

        out.print("{");
        out.print("\"id\":" + rs.getInt("id") + ",");
        out.print("\"name\":\"" + name + "\",");
        out.print("\"price\":" + rs.getInt("price") + ",");
        out.print("\"img\":\"" + image + "\"");
        out.print("}");
    }
    out.print("]");

} catch (Exception e) {
    // 發生錯誤時，至少回傳一個空的 JSON 陣列，避免前端 fetch 噴錯
    out.print("[]");
    System.err.println("favorite_list 錯誤：" + e.getMessage());
} finally {
    // 2. 💡 安全防護：確保不論成功或失敗，資料庫連線都會被釋放
    if (rs != null) try { rs.close(); } catch (Exception e) {}
    if (ps != null) try { ps.close(); } catch (Exception e) {}
    if (conn != null) try { conn.close(); } catch (Exception e) {}
}
%>