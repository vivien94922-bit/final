<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
request.setCharacterEncoding("UTF-8");

String username = request.getParameter("username");
String password = request.getParameter("password");

if(username == null || password == null){
    out.println("<script>alert('請輸入帳密'); history.back();</script>");
    return;
}

Class.forName("com.mysql.cj.jdbc.Driver");

Connection conn = DriverManager.getConnection(
    "jdbc:mysql://localhost:3306/shopdb",
    "root",
    "1234"
);

String sql = "SELECT * FROM members WHERE username=? AND password=?";
PreparedStatement ps = conn.prepareStatement(sql);
ps.setString(1, username);
ps.setString(2, password);

ResultSet rs = ps.executeQuery();

if(rs.next()){
    session.setAttribute("user_id", rs.getInt("id"));
    session.setAttribute("username", rs.getString("username"));
    session.setAttribute("isLogin", "true");
    response.sendRedirect("member.jsp");
} else {
    out.println("<script>alert('登入失敗'); history.back();</script>");
}
%>