<%@ page contentType="text/plain; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="dbutil.jsp" %>
<%
    Integer userId = (Integer) session.getAttribute("user_id");
    String productId = request.getParameter("product_id");

    if (userId == null) { response.setStatus(401); return; }

    Connection con = getConnection();
    try {
        // 檢查該用戶是否已收藏該商品
        String checkSql = "SELECT id FROM favorite WHERE user_id = ? AND product_id = ?";
        PreparedStatement psCheck = con.prepareStatement(checkSql);
        psCheck.setInt(1, userId);
        psCheck.setString(2, productId);
        ResultSet rs = psCheck.executeQuery();

        if (rs.next()) {
            // 已存在 -> 刪除
            PreparedStatement psDel = con.prepareStatement("DELETE FROM favorite WHERE user_id = ? AND product_id = ?");
            psDel.setInt(1, userId);
            psDel.setString(2, productId);
            psDel.executeUpdate();
            out.print("remove");
        } else {
            // 不存在 -> 新增
            PreparedStatement psIns = con.prepareStatement("INSERT INTO favorite (user_id, product_id) VALUES (?, ?)");
            psIns.setInt(1, userId);
            psIns.setString(2, productId);
            psIns.executeUpdate();
            out.print("add");
        }
    } finally { if (con != null) con.close(); }
%>
