<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ include file="dbutil.jsp" %>
<%
    Integer userId = (Integer) session.getAttribute("user_id");
    if (userId == null) { out.print("[]"); return; }

    Connection con = null;
    try {
        con = getConnection();
        // 使用正確的表名 'favorite' 與欄位 'user_id'
        String sql = "SELECT p.id, p.name, p.price, p.image " +
             "FROM product p " +
             "JOIN favorite f ON p.id = f.product_id " +
             "WHERE f.user_id = ? " +
             "GROUP BY p.id " +
             "ORDER BY MAX(f.created_at) DESC";
 
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();

        StringBuilder json = new StringBuilder("[");
        boolean first = true;
        while (rs.next()) {
            if (!first) json.append(",");
            first = false;
            json.append("{\"id\":").append(rs.getInt("id"))
                .append(",\"name\":\"").append(rs.getString("name").replace("\"", "\\\""))
                .append("\",\"price\":").append(rs.getInt("price"))
                .append(",\"img\":\"").append(rs.getString("image")).append("\"}");
        }
        json.append("]");
        out.print(json.toString());
    } catch (Exception e) {
        e.printStackTrace();
        out.print("[]");
    } finally { if (con != null) con.close(); }
%>
