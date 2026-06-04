<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<%
String idStr = request.getParameter("id");
if(idStr == null) idStr = "1";
int id = Integer.parseInt(idStr);

Class.forName("com.mysql.cj.jdbc.Driver");

Connection conn = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/shopdb?useUnicode=true&characterEncoding=UTF-8",
"root",
"123456"
);

/* ===== 商品資料 ===== */
PreparedStatement ps = conn.prepareStatement(
"SELECT * FROM product WHERE id=?"
);
ps.setInt(1, id);
ResultSet rs = ps.executeQuery();

rs.next();
%>

<html>
<head>
<meta charset="UTF-8">
<title>商品頁</title>
</head>

<body>

<h1><%=rs.getString("name")%></h1>
<img src="<%=rs.getString("image")%>" width="300">

<p><%=rs.getString("description")%></p>
<h3>價格：NT$ <%=rs.getInt("price")%></h3>

<hr>

<h2>留下評價</h2>

<form action="addComment.jsp" method="post">

<input type="hidden" name="product_id" value="<%=id%>">

姓名：
<input type="text" name="username" required>
<br><br>

評分：
<select name="rating">
  <option value="5">★★★★★</option>
  <option value="4">★★★★</option>
  <option value="3">★★★</option>
  <option value="2">★★</option>
  <option value="1">★</option>
</select>

<br><br>

內容：
<br>
<textarea name="content" required></textarea>

<br><br>

<button type="submit">送出評價</button>

</form>

<hr>

<h2>商品評價</h2>

<%
PreparedStatement ps2 = conn.prepareStatement(
"SELECT * FROM product_comment WHERE product_id=? ORDER BY create_time DESC"
);
ps2.setInt(1, id);
ResultSet rs2 = ps2.executeQuery();

boolean hasComment = false;

while(rs2.next()){
hasComment = true;
%>

<div style="border:1px solid #ccc; padding:10px; margin-bottom:10px;">

<b><%=rs2.getString("username")%></b>
&nbsp; ⭐ <%=rs2.getInt("rating")%>

<br>

<%=rs2.getString("content")%>

<br>
<small><%=rs2.getTimestamp("create_time")%></small>

</div>

<%
}

if(!hasComment){
%>
<p>目前沒有評價</p>
<%
}

rs.close();
ps.close();
rs2.close();
ps2.close();
conn.close();
%>

</body>
</html>