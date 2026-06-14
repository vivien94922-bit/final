<%@ page contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*" %> <%@ include file="dbutil.jsp" %>

<%
Integer userId = (Integer) session.getAttribute("user_id");
if (userId == null) {
    response.setStatus(401);
    out.print("{\"success\":false,\"message\":\"Unauthorized\"}");
    return;
}

int cartId = Integer.parseInt(request.getParameter("cart_id"));
int qty = Integer.parseInt(request.getParameter("quantity"));

try (Connection conn = getConnection()) {
    PreparedStatement ps = null;

    // 👉 關鍵邏輯：判斷數量是否小於等於 0
    if (qty <= 0) {
        // 如果數量是 0，代表使用者要刪除商品，改執行 DELETE
        ps = conn.prepareStatement(
            "DELETE FROM cart WHERE cart_id=? AND user_id=?"
        );
        ps.setInt(1, cartId);
        ps.setInt(2, userId);
    } else {
        // 如果數量大於 0，才執行常規的 UPDATE 更新數量
        ps = conn.prepareStatement(
            "UPDATE cart SET quantity=? WHERE cart_id=? AND user_id=?"
        );
        ps.setInt(1, qty);
        ps.setInt(2, cartId);
        ps.setInt(3, userId);
    }

    ps.executeUpdate();
    ps.close(); // 養成好習慣，手動關閉 PreparedStatement

    out.print("{\"success\":true}");

} catch (Exception e) {
    // 可以在 console 列印一下錯誤訊息，方便你們組員 debug
    e.printStackTrace(); 
    out.print("{\"success\":false}");
}
%>