<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="dbutil.jsp" %>
<%@ include file="webutil.jsp" %>

<%
String keyword = request.getParameter("keyword");

// 修正點：用 if 包裹真正要做事的時間點，避免 keyword 為空時引發後續 HTML 破洞
if (keyword != null && !keyword.trim().equals("")) {

    Connection con = getConnection();
    PreparedStatement ps = con.prepareStatement(
        "SELECT id, name FROM product WHERE name LIKE ? LIMIT 8"
    );
    ps.setString(1, "%" + keyword + "%");
    ResultSet rs = ps.executeQuery();

    while(rs.next()){
%>
        <div class="search-item">
          <a href="product.jsp?id=<%= rs.getInt("id") %>">
            <%=escapeHtml(rs.getString("name"))%>
          </a>
        </div>
<%
    }
    rs.close();
    ps.close();
    con.close();
} 
// 如果 keyword 是空的，就什麼都不印，自然結束，絕對不要用可能搞垮全站的 naked return;
%>
