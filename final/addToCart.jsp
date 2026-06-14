<%@ page contentType="application/json; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="dbutil.jsp" %>
<%
    Integer userId = (Integer) session.getAttribute("user_id");

    if (userId == null) {
        response.setStatus(401);
        out.print("{\"success\":false,\"msg\":\"請先登入\"}");
        return;
    }

    try {
        int productId = Integer.parseInt(request.getParameter("product_id"));
        int qty = Integer.parseInt(request.getParameter("quantity"));

        Connection conn = getConnection();

        // 1. 檢查該商品是否已在購物車中
        PreparedStatement checkPs =
        conn.prepareStatement(
        "SELECT quantity FROM cart WHERE user_id=? AND product_id=? AND size=?"
        );
        
        checkPs.setInt(1,userId);
        checkPs.setInt(2,productId);
        checkPs.setString(3,size);

        if (rs.next()) {
            // 2. 若已存在，則執行累加更新
            PreparedStatement updatePs =
            conn.prepareStatement(
            "UPDATE cart SET quantity = quantity + ? WHERE user_id=? AND product_id=? AND size=?"
            );
            
            updatePs.setInt(1,qty);
            updatePs.setInt(2,userId);
            updatePs.setInt(3,productId);
            updatePs.setString(4,size);
        } else {
            // 3. 若不存在，則執行新增
            PreparedStatement insertPs =
            conn.prepareStatement(
            "INSERT INTO cart(user_id,product_id,quantity,size) VALUES(?,?,?,?)"
            );
            
            insertPs.setInt(1,userId);
            insertPs.setInt(2,productId);
            insertPs.setInt(3,qty);
            insertPs.setString(4,size);
            insertPs.executeUpdate();
            insertPs.close();
        }

        out.print("{\"success\":true,\"msg\":\"成功加入購物車\"}");

        rs.close();
        checkPs.close();
        conn.close();

    } catch (Exception e) {
        response.setStatus(500);
        out.print("{\"success\":false,\"msg\":\"處理失敗: " + e.getMessage() + "\"}");
    }
%>

String size =
request.getParameter("size");
