<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbutil.jsp" %>

<%
Connection conn = null;
PreparedStatement ps = null;

try{
    Integer userId = (Integer)session.getAttribute("user_id");

    // 未登入不能刪
    if(userId == null){
        response.sendRedirect("login.jsp");
        return;
    }

    int commentId = Integer.parseInt(request.getParameter("comment_id"));
    int productId = Integer.parseInt(request.getParameter("product_id"));

    conn = getConnection();

    // 只能刪自己的留言
    String sql = "DELETE FROM product_comment WHERE id=? AND user_id=?";

    ps = conn.prepareStatement(sql);
    ps.setInt(1, commentId);
    ps.setInt(2, userId);

    ps.executeUpdate();

    response.sendRedirect("product.jsp?id=" + productId);

}catch(Exception e){
    out.println(e.getMessage());
}finally{
    if(ps!=null) ps.close();
    if(conn!=null) conn.close();
}
%>