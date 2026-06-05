<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<%
request.setCharacterEncoding("UTF-8");

String username = request.getParameter("username");
String password = request.getParameter("password");
String name = request.getParameter("name");
String email = request.getParameter("email");
String phone = request.getParameter("phone");

try {
    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection conn = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/shopdb?useUnicode=true&characterEncoding=UTF-8",
        "root",
        "1234"
    );

    String sql = "INSERT INTO members(username, password, name, email, phone) VALUES(?,?,?,?,?)";
    PreparedStatement ps = conn.prepareStatement(sql);

    ps.setString(1, username);
    ps.setString(2, password);
    ps.setString(3, name);
    ps.setString(4, email);
    ps.setString(5, phone);

    ps.executeUpdate();

    conn.close();

    out.println("<script>alert('註冊成功！請登入'); location.href='login.jsp';</script>");

} catch(Exception e) {
    out.println("<h3>錯誤：</h3>" + e.getMessage());
}
%>