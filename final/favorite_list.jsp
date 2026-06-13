<%@ page contentType="application/json; charset=UTF-8" %>
<%@ include file="dbutil.jsp" %>
<%
    // 確保只撈取該會員的資料
    Integer memberId = (Integer) session.getAttribute("user_id");
    
    // 如果沒登入，回傳空陣列
    if (memberId == null) {
        out.print("[]");
        return;
    }

    Connection con = null;
    try {
        con = getConnection();
        // 透過 JOIN 關聯 favorites 和 product 表，直接取得圖片路徑、價格與名稱
        String sql = "SELECT p.id, p.name, p.price, p.image " +
                     "FROM product p " +
                     "JOIN favorites f ON p.id = f.product_id " +
                     "WHERE f.member_id = ?";
                     
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, memberId);
        ResultSet rs = ps.executeQuery();

        out.print("[");
        boolean first = true;
        while (rs.next()) {
            if (!first) out.print(",");
            first = false;
            
            // 轉義名稱中的引號，避免 JSON 解析錯誤
            String name = rs.getString("name").replace("\"", "\\\"");
            
            out.print("{");
            out.print("\"id\":" + rs.getInt("id") + ",");
            out.print("\"name\":\"" + name + "\",");
            out.print("\"price\":" + rs.getInt("price") + ",");
            out.print("\"img\":\"" + rs.getString("image") + "\"");
            out.print("}");
        }
        out.print("]");
        
    } catch (Exception e) {
        e.printStackTrace();
        out.print("[]"); // 出錯時回傳空陣列，避免前端報錯
    } finally {
        if (con != null) con.close();
    }
%>
