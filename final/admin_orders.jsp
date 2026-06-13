<%@ page contentType="text/html; charset=UTF-8" %>
<%
Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");

if(isAdmin == null || !isAdmin){
    response.sendRedirect("admin_login.jsp");
    return;
}
%>
<%@ page import="java.sql.*" %>
<%@ include file="dbutil.jsp" %>

<%
Connection con = getConnection();
PreparedStatement ps = con.prepareStatement(
    "SELECT * FROM orders ORDER BY created_at DESC"
);
ResultSet rs = ps.executeQuery();
%>
<h2>訂單管理後台</h2>

<table border="1" cellpadding="8">

<tr>
    <th>訂單ID</th>
    <th>會員ID</th>
    <th>收件人</th>
    <th>電話</th>
    <th>地址</th>
    <th>付款方式</th>
    <th>總金額</th>
    <th>狀態</th>
    <th>時間</th>
</tr>

<%
while(rs.next()){
%>

<tr>
    <td><%= rs.getInt("id") %></td>
    <td><%= rs.getInt("member_id") %></td>
    <td><%= rs.getString("recipient_name") %></td>
    <td><%= rs.getString("phone") %></td>
    <td><%= rs.getString("address") %></td>
    <td><%= rs.getString("payment") %></td>
    <td><%= rs.getInt("total") %></td>
    <td><%= rs.getString("status") %></td>
    <td><%= rs.getString("created_at") %></td>
</tr>

<%
}
%>

</table>