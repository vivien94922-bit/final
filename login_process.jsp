<%@ page import="java.sql.*"%>

<%
String username = request.getParameter("username");
String password = request.getParameter("password");

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

    out.println("<script>alert('登入成功'); location.href='member.jsp';</script>");
} else {
    out.println("<script>alert('帳號或密碼錯誤'); history.back();</script>");
}
%>