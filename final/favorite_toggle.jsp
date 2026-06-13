<%@ page import="java.sql.*" %>
<%@ include file="dbutil.jsp" %>

<%
int productId = Integer.parseInt(request.getParameter("product_id"));
String sessionId = session.getId();

Connection con = getConnection();

// 1️⃣ 檢查是否已收藏
PreparedStatement ps = con.prepareStatement(
    "SELECT * FROM favorite WHERE session_id=? AND product_id=?"
);

ps.setString(1, sessionId);
ps.setInt(2, productId);

ResultSet rs = ps.executeQuery();

if(rs.next()){

    // ❌ 已存在 → 刪除（取消收藏）
    PreparedStatement del = con.prepareStatement(
        "DELETE FROM favorite WHERE session_id=? AND product_id=?"
    );

    del.setString(1, sessionId);
    del.setInt(2, productId);
    del.executeUpdate();

    out.print("remove");

}else{

    // ❤️ 不存在 → 新增收藏
    PreparedStatement ins = con.prepareStatement(
        "INSERT INTO favorite(session_id, product_id) VALUES(?, ?)"
    );

    ins.setString(1, sessionId);
    ins.setInt(2, productId);
    ins.executeUpdate();

    out.print("add");
}

con.close();
%>