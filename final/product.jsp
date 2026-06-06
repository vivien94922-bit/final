<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page isErrorPage="true" %>
<%
try {
%>
<%
// ================= 1. 取得商品 ID =================
String idStr = request.getParameter("id");
if(idStr == null) idStr = "1";
int id = Integer.parseInt(idStr);

// ================= 2. 分頁設定 =================
int pageSize = 5;

String pageStr = request.getParameter("page");
int currentPage = (pageStr == null) ? 1 : Integer.parseInt(pageStr);
int offset = (currentPage - 1) * pageSize;

// ================= 3. DB 連線 =================
Class.forName("com.mysql.cj.jdbc.Driver");

Connection conn = DriverManager.getConnection(
  "jdbc:mysql://localhost:3306/shopdb?useUnicode=true&characterEncoding=UTF-8",
  "root",
  "1234"
);

// ================= 4. 查商品 =================
PreparedStatement ps = conn.prepareStatement(
  "SELECT * FROM product WHERE id=?"
);
ps.setInt(1, id);
ResultSet rs = ps.executeQuery();

if(!rs.next()){
%>
  <!DOCTYPE html>
  <html>
  <head><title>找不到商品</title></head>
  <body>
    <h2 style="color:blue;">JSP有進來</h2>
    <h2 style="text-align:center; margin-top:50px;">
      找不到該商品，請重新確認商品 ID。
    </h2>
  </body>
  </html>
<%
  rs.close();
  ps.close();
  conn.close();
  return;
}

// ================= 5. 分頁總數（修正版） =================
int total = 0;

try {
  PreparedStatement psCount = conn.prepareStatement(
    "SELECT COUNT(*) FROM product_comment WHERE product_id=?"
  );

  psCount.setInt(1, id);
  ResultSet rsCount = psCount.executeQuery();

  if(rsCount.next()){
    total = rsCount.getInt(1);
  }

  rsCount.close();
  psCount.close();

} catch(Exception e){
  out.println("COUNT錯誤：" + e.getMessage());
}

int totalPages = (int)Math.ceil(total / (double)pageSize);
%>

<!DOCTYPE html>
<html lang="zh-Hant">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><%=rs.getString("name")%> - STANDARD DAY</title>

  <style>
    /* ===== 基礎全域樣式重設 ===== */
    body {
      margin: 0;
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
      color: #000;
      background-color: #fff;
    }

    /* ===== 頂部黑色導覽列 ===== */
    header {
      background-color: #1c1c1c;
      color: white;
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 15px 40px;
    }
    header .logo {
      color: white;
      text-decoration: none;
      font-size: 22px;
      font-weight: bold;
      letter-spacing: 1px;
    }
    header .nav-icons img {
      width: 24px;
      filter: invert(1); /* 讓黑色購物車圖標在黑底上變成白色 */
    }

    /* ===== 商品主區塊 (你提供的整合樣式) ===== */
    .product-container {
      display: flex;
      gap: 60px;
      padding: 60px 20px;
      justify-content: center;
      max-width: 1100px;
      margin: 0 auto;
    }

    .product-images {
      width: 440px;
      height: 570px;
      overflow: hidden;
      flex-shrink: 0;
    }

    .product-images img {
      width: 100%; 
      height: 100%;
      object-fit: cover;
      display: block;
    }
    
    .product-info {
      max-width: 440px;
      flex-grow: 1;
      display: flex;
      flex-direction: column;
      align-items: stretch;
      text-align: left;
      justify-content: center;
    }

    .product-info h1 {
      font-size: 32px;
      margin: 0 0 15px 0;
      font-weight: bold;
    }

    .product-info .product-desc {
      color: #555;
      font-size: 15px;
      line-height: 1.6;
      margin-bottom: 30px;
    }

    /* 價格樣式 */
    .price {
      border-left: 4px solid #565254; 
      padding-left: 10px; 
      margin-bottom: 30px; 
      font-size: 24px;
      font-weight: bold;
      color: #565254;
    }

    /* 表單與選擇框群組 */
    .form-group {
      display: flex;
      flex-direction: column;
      gap: 6px;
      font-size: 14px;
      margin-bottom: 20px;
    }

    .form-group label {
      font-weight: bold;
      color: #333;
    }

    .form-group select,
    .form-group input {
      width: 100%;        
      height: 44px;        
      padding: 6px 12px;
      font-size: 14px;
      border: 1px solid #ccc;
      border-radius: 4px;
      box-sizing: border-box;
      outline: none;
    }

    /* 加入購物車按鈕 */
    .add-cart {
      width: 100%;              
      margin: 10px 0 20px 0;    
      padding: 14px 0;
      background: #565254;
      color: #FFFFFF;
      border: none;
      border-radius: 999px; /* 膠囊圓角 */
      font-size: 15px;
      font-weight: 500;
      letter-spacing: 2px;
      cursor: pointer;
      transition: transform .2s ease, box-shadow .2s ease, background .2s ease;
    }

    .add-cart:hover {
      background: #7A7D7D;
      box-shadow: 0 10px 25px rgba(0,0,0,.2);
      transform: translateY(-2px);
    }

    .add-cart:active {
      transform: translateY(0);
      box-shadow: 0 4px 10px rgba(0,0,0,.2);
    }

    /* ===== 下方頁籤區塊 (Tabs) ===== */
    .tabs-section {
      max-width: 1100px;
      margin: 40px auto;
      padding: 0 20px;
    }

    .tabs {
      display: flex;
      border-top: 1px solid #000;
      border-bottom: 1px solid #000;
    }

    .tab {
      flex: 1;
      padding: 15px;
      background: none;
      border: none;
      cursor: pointer;
      font-size: 16px;
      font-weight: normal;
      color: #666;
      outline: none;
    }

    .tab.active {
      border-bottom: 3px solid black;
      font-weight: bold;
      color: #000;
    }

    /* 內容顯示控制 */
    .tab-content {
      padding: 40px 20px;
    }

    .content {
      display: none;
      text-align: center;
    }

    .content.active {
      display: block;
    }

    /* 尺寸表格樣式 */
    .size-table {
      width: 100%;
      max-width: 600px;
      border-collapse: collapse;
      margin: 20px auto 0 auto;
      font-size: 14px;
    }

    .size-table th,
    .size-table td {
      border: 1px solid #ddd;
      padding: 10px;
      text-align: center;
    }

    .size-table th {
      background-color: #f5f5f5;
      font-weight: 600;
    }

    /* ===== 評價區塊表格與表單 ===== */
    #feedback-form {
      max-width: 600px;
      margin: 20px auto;
      text-align: left;
    }

    #feedback-form input,
    #feedback-form select,
    #feedback-form textarea {
      width: 100%;
      padding: 12px;
      margin: 8px 0;
      border: 1px solid #ddd;
      border-radius: 4px;
      box-sizing: border-box;
    }

    #feedback-form button {
      padding: 12px 30px;
      background-color: #333;
      color: #fff;
      border: none;
      cursor: pointer;
      font-weight: bold;
      border-radius: 4px;
    }

    #feedback-form button:hover {
      background-color: #555;
    }

    .feedback-list {
      max-width: 600px;
      margin: 40px auto;
      text-align: left;
    }

    .feedback-item {
      border-bottom: 1px solid #eee;
      padding: 15px 0;
    }

    /* ===== 特效：淡入動畫 ===== */
    .fade-up {
      opacity: 0;
      transform: translateY(20px);
      animation: fadeUp 0.6s ease forwards;
    }

    @keyframes fadeUp {
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }
  </style>
</head>

<body>

<header>
  <div class="nav-left">
    <a href="index.jsp" class="logo">STANDARD DAY</a>
  </div>
  <div class="nav-icons">
    <a href="cart.html">
      <img src="images/shopping_cart.png" alt="購物車">
    </a>
  </div>
</header>

<main class="product-container">

  <div class="product-images fade-up">
    <img id="mainImage" src="<%=rs.getString("image")%>" alt="<%=rs.getString("name")%>">
  </div>

  <div class="product-info fade-up">
    <h1><%=rs.getString("name")%></h1>

    <div class="product-desc">
      <%=rs.getString("description")%>
    </div>

    <div class="price">
      NT$ <%=rs.getInt("price")%>
    </div>

    <form action="addToCart" method="POST">
      <div class="form-group">
        <label>尺寸選擇</label>
        <select name="size">
          <option value="S">S</option>
          <option value="M">M</option>
          <option value="L">L</option>
        </select>
      </div>

      <div class="form-group">
        <label>數量</label>
        <input type="number" name="quantity" value="1" min="1">
      </div>

      <button type="submit" class="add-cart">加入購物車</button>
    </form>
  </div>
</main>

<section class="tabs-section">
  <div class="tabs">
    <button class="tab active" data-target="tab-desc">商品描述</button>
    <button class="tab" data-target="tab-shipping">送貨及付款方式</button>
    <button class="tab" data-target="tab-reviews">顧客評價</button>
  </div>
  
  <div class="tab-content">
    
    <div id="tab-desc" class="content active">
      <h3 style="font-size: 16px; margin-top: 10px;">材質</h3>
      <p style="color: #444; font-size: 14px; margin-bottom: 30px;">Polyester 80% / Wool 20%</p>
      
      <h3 style="font-size: 16px;">尺寸表 (cm)</h3>
      <table class="size-table">
        <thead>
          <tr>
            <th>Size</th>
            <th>肩寬</th>
            <th>胸圍</th>
            <th>衣長</th>
            <th>袖長</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>S</td>
            <td>40</td>
            <td>96</td>
            <td>105</td>
            <td>58</td>
          </tr>
          <tr>
            <td>M</td>
            <td>42</td>
            <td>100</td>
            <td>110</td>
            <td>59</td>
          </tr>
          <tr>
            <td>L</td>
            <td>44</td>
            <td>104</td>
            <td>112</td>
            <td>60</td>
          </tr>
        </tbody>
      </table>
    </div>

    <div id="tab-shipping" class="content">
      <p style="color: #444; font-size: 14px; line-height: 2;">
        宅配到府 (黑貓宅急便) / 超商取貨付款 (7-11、全家)<br>
        出貨時間：現貨商品於下單後 2-3 個工作天內出貨。
      </p>
    </div>
    <div id="tab-reviews" class="content">

      <%
Integer userIdObj = (Integer) session.getAttribute("user_id");
String sessionName = (String) session.getAttribute("username");
int userId = (userIdObj == null) ? -1 : userIdObj.intValue();

%>

<!-- ================= 留言表單 ================= -->
<div id="feedback-form">
  <h3 style="margin-top: 0;">留下評價</h3>

  <%
  if(userId != -1){
  %>
    <form action="add.jsp" method="post">
      <input type="hidden" name="product_id" value="<%=id%>">
      <input type="hidden" name="user_id" value="<%=userId%>">

      <input type="text" name="username" value="<%=sessionName%>" readonly>

      <select name="rating">
        <option value="5">★★★★★</option>
        <option value="4">★★★★</option>
        <option value="3">★★★</option>
        <option value="2">★★</option>
        <option value="1">★</option>
      </select>

      <textarea name="content" rows="4" placeholder="留言內容" required></textarea>
      <button type="submit">送出評價</button>
    </form>
  <%
  } else {
  %>
    <p style="color:#999; background:#f5f5f5; padding:10px; border-radius:6px;">
      🔒 請登入後才能留下評價
    </p>
  <%
  }
  %>
</div>

<hr>

<!-- ================= 留言列表 ================= -->
<div class="feedback-list">

<%
PreparedStatement ps2 = null;
ResultSet rs2 = null;

try {

  // 先算總數（乾淨版，不重複宣告）
  PreparedStatement psCount = conn.prepareStatement(
    "SELECT COUNT(*) FROM product_comment WHERE product_id=?"
  );
  psCount.setInt(1, id);
  ResultSet rsCount = psCount.executeQuery();
%>

<%
  // ===== 留言查詢 =====
  String sql =
    "SELECT * FROM product_comment " +
    "WHERE product_id=? " +
    "ORDER BY create_time DESC " +
    "LIMIT ?, ?";

  ps2 = conn.prepareStatement(sql);
  ps2.setInt(1, id);
  ps2.setInt(2, offset);
  ps2.setInt(3, pageSize);

  rs2 = ps2.executeQuery();

  boolean hasComment = false;

  while(rs2.next()){
    hasComment = true;
    int commentUserId = rs2.getInt("user_id");
%>

<div class="feedback-item">
  <strong><%=rs2.getString("username")%></strong>

  <span style="color:#f39c12;">
    <%
      for(int i=0;i<rs2.getInt("rating");i++){
        out.print("★");
      }
    %>
  </span>

  <p><%=rs2.getString("content")%></p>
  <small><%=rs2.getTimestamp("create_time")%></small>

  <%
  if(userId != -1 && userId == commentUserId){
  %>
    <form action="delete_comment.jsp" method="post">
      <input type="hidden" name="comment_id" value="<%=rs2.getInt("id")%>">
      <input type="hidden" name="product_id" value="<%=id%>">
      <button style="color:red;">刪除</button>
    </form>
  <%
  }
  %>
</div>

<%
  }

  if(!hasComment){
%>
  <p>目前沒有評價</p>
<%
  }

} catch(Exception e){
%>
  <p style="color:red;">留言載入失敗：<%=e.getMessage()%></p>
<%
}
%>
</div>

<!-- ================= 分頁 ================= -->
<div style="text-align:center; margin-top:20px;">

<%
for(int i=1;i<=totalPages;i++){
  if(i == currentPage){
%>
    <b style="margin:0 5px;"><%=i%></b>
<%
  } else {
%>
    <a style="margin:0 5px;" href="product.jsp?id=<%=id%>&page=<%=i%>"><%=i%></a>
<%
  }
}
%>

<%
if(currentPage < totalPages){
%>
  <a href="product.jsp?id=<%=id%>&page=<%=currentPage+1%>">下一頁</a>
<%
}
%>

</div>
</section>

<script>
  const tabs = document.querySelectorAll('.tab');
  const contents = document.querySelectorAll('.content');

  tabs.forEach(tab => {
    tab.addEventListener('click', () => {
      // 1. 移除所有頁籤的 active 樣式
      tabs.forEach(t => t.classList.remove('active'));
      // 2. 隱藏所有內容區塊
      contents.forEach(c => c.classList.remove('active'));

      // 3. 為被點擊的頁籤加上 active
      tab.classList.add('active');
      // 4. 顯示對應的內容區塊
      const targetId = tab.getAttribute('data-target');
      document.getElementById(targetId).classList.add('active');
    });
  });
</script>
</body>
</html>

<%
// 關閉資料庫連線
try { if(rs != null) rs.close(); } catch(Exception e){}
try { if(ps != null) ps.close(); } catch(Exception e){}
try { if(conn != null) conn.close(); } catch(Exception e){}
%>
<%
} catch(Exception e) {
  out.println("<pre style='color:red;'>JSP錯誤：" + e.getMessage());
  e.printStackTrace(new java.io.PrintWriter(out));
}
%>