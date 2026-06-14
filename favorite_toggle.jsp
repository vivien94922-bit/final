<%@ page contentType="text/plain; charset=UTF-8" %>
<%@ include file="dbutil.jsp" %>
<%
    // 檢查是否有登入
    Integer memberId = (Integer) session.getAttribute("user_id");
    String pidParam = request.getParameter("product_id");

    if (memberId == null) {
        response.setStatus(401); // 未登入
        out.print("error: not logged in");
        return;
    }

    if (pidParam == null || pidParam.isEmpty()) {
        response.setStatus(400); // 參數錯誤
        out.print("error: missing product_id");
        return;
    }

    Connection con = null;
    try {
        int productId = Integer.parseInt(pidParam);
        con = getConnection();

        // 查詢是否已收藏
        PreparedStatement ps = con.prepareStatement(
            "SELECT id FROM favorites WHERE member_id=? AND product_id=?"
        );
        ps.setInt(1, memberId);
        ps.setInt(2, productId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            // 已存在 -> 刪除
            PreparedStatement del = con.prepareStatement(
                "DELETE FROM favorites WHERE member_id=? AND product_id=?"
            );
            del.setInt(1, memberId);
            del.setInt(2, productId);
            del.executeUpdate();
            out.print("remove");
        } else {
            // 不存在 -> 新增
            PreparedStatement ins = con.prepareStatement(
                "INSERT INTO favorites(member_id, product_id) VALUES(?, ?)"
            );
            ins.setInt(1, memberId);
            ins.setInt(2, productId);
            ins.executeUpdate();
            out.print("add");
        }
    } catch (Exception e) {
        // 這會將詳細錯誤訊息印到 Tomcat 控制台
        e.printStackTrace(); 
        response.setStatus(500);
        out.print("error: " + e.getMessage());
    } finally {
        if (con != null) con.close();
    }
%>
