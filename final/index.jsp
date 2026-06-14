<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.*" %>
<%@ include file="dbutil.jsp" %>
<%@ include file="webutil.jsp" %>
<%@ include file="header.jsp" %>
<%
Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

int count = 0;

try{

    Class.forName("com.mysql.cj.jdbc.Driver");

    con = getConnection();

    // 不是刷新才增加
    if(session.getAttribute("visitor_counted") == null){

        ps = con.prepareStatement(
            "UPDATE counter SET count = count + 1 WHERE id = 1"
        );
        ps.executeUpdate();
        ps.close();

        session.setAttribute("visitor_counted", Boolean.TRUE);
    }

    ps = con.prepareStatement(
        "SELECT count FROM counter WHERE id = 1"
    );

    rs = ps.executeQuery();

    if(rs.next()){
        count = rs.getInt("count");
    }

}catch(Exception e){
    out.println("錯誤：" + e.getMessage());
}
%>

<!DOCTYPE html>
<html lang="zh-Hant">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>STANDARD DAY Clothing Store</title>

  <link rel="stylesheet" href="style.css">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Montserrat:ital,wght@0,100..900;1,100..900&family=Noto+Sans+TC:wght@100..900&display=swap" rel="stylesheet">
  <style>
  .visitor{
      width:200px;
      margin:10px auto;
      padding:5px;
      text-align:center;
      font-size:18px;
  }
  </style>
</head>

<body>

<%
String msg = (String) session.getAttribute("msg");

if ("logout".equals(msg)) {
    session.removeAttribute("msg");
%>
<script>
alert("您已成功登出");
</script>
<%
}
%>

<script src="script.js"></script>

<!-- intro -->
<div class="intro" id="intro">
  <div class="title">
    <span class="left">STANDARD</span>
    <span class="right">DAY</span>
  </div>
</div>

<!-- banner（不動） -->
<section class="banner">
  <img id="bannerImage" src="../images/banner1.jpg">

  <div class="banner-text">
    <h1 id="bannerTitle"></h1>
    <p id="bannerDesc"></p>
    <button id="bannerBuyNowBtn">立即選購</button>
  </div>

  <div id="dotsContainer"></div>
  <button class="prev">‹</button>
  <button class="next">›</button>
</section>

<!-- 訪客計數器（完全不動） -->
<div class="visitor">
  您是本站第 <b><%= count %></b> 位訪客
</div>

<!-- ⭐ 商品區（DB版） -->
<section class="products">

<h2>熱門商品</h2>

<div class="product-grid">

<%
Connection con2 = getConnection();
PreparedStatement ps2 = con2.prepareStatement(
    "SELECT * FROM product LIMIT 3"
);
ResultSet rs2 = ps2.executeQuery();

while(rs2.next()){
%>

<div class="product"
     data-id="<%= rs2.getInt("id") %>"
     data-name="<%=escapeHtml(rs2.getString("name"))%>"
     data-price="<%= rs2.getInt("price") %>"
     data-img="<%=escapeHtml(rs2.getString("image"))%>">
    
    <a href="product.jsp?id=<%= rs2.getInt("id") %>" class="product-link">
        <img src="<%=escapeHtml(rs2.getString("image"))%>" alt="<%=escapeHtml(rs2.getString("name"))%>">
        <div class="product-info">
            <div class="product-name"><%=escapeHtml(rs2.getString("name"))%></div>
            <div class="product-price">NT$<%= rs2.getInt("price") %></div>
        </div>
    </a>

    <img src="/final/final/images/heart.png" class="favorite-icon" alt="收藏" onclick="toggleFavorite(event, this)">

    <button class="add-cart-btn">加入購物車</button>
</div>

<%
}
rs2.close();
ps2.close();
%>

</div>
<h2>上裝</h2>

<div class="product-grid">

<%
PreparedStatement psTop = con2.prepareStatement(
     "SELECT * FROM product WHERE category = 'tops' LIMIT 3"
);
ResultSet rsTop = psTop.executeQuery();

while(rsTop.next()){
%>

<div class="product" data-id="<%= rsTop.getInt("id") %>">
    <a href="product.jsp?id=<%= rsTop.getInt("id") %>" class="product-link">
        <img src="<%=escapeHtml(rsTop.getString("image"))%>" alt="<%=escapeHtml(rsTop.getString("name"))%>">
        <div class="product-info">
            <div class="product-name"><%=escapeHtml(rsTop.getString("name"))%></div>
            <div class="product-price">NT$<%= rsTop.getInt("price") %></div>
        </div>
    </a>

    <img src="../images/heart.png"
         class="favorite-icon"
         onclick="toggleFavorite(event, this)">

    <button class="add-cart-btn">加入購物車</button>
</div>

<%
}
rsTop.close();
psTop.close();
%>

</div>
<h2>下裝</h2>

<div class="product-grid">

<%
PreparedStatement psBottom = con2.prepareStatement(
    "SELECT * FROM product WHERE category = 'bottoms' LIMIT 3"
);
ResultSet rsBottom = psBottom.executeQuery();

while(rsBottom.next()){
%>

<div class="product" data-id="<%= rsBottom.getInt("id") %>">
    <a href="product.jsp?id=<%= rsBottom.getInt("id") %>" class="product-link">
        <img src="<%=escapeHtml(rsBottom.getString("image"))%>" alt="<%=escapeHtml(rsBottom.getString("name"))%>">
        <div class="product-info">
            <div class="product-name"><%=escapeHtml(rsBottom.getString("name"))%></div>
            <div class="product-price">NT$<%= rsBottom.getInt("price") %></div>
        </div>
    </a>

    <img src="../images/heart.png"
         class="favorite-icon"
         onclick="toggleFavorite(event, this)">

    <button class="add-cart-btn">加入購物車</button>
</div>

<%
}
rsBottom.close();
psBottom.close();
con2.close();
%>

</div>

</section>

<!-- footer（不動） -->
<footer>
  <p>聯絡我們｜service@standardday.com</p>
  <p>© 2025 STANDARD DAY. All rights reserved.</p>
  <p><a href="privacy.html" style="color:#bbb;">隱私權政策</a></p>
</footer>

<button id="backToTop">↑</button>
<script src="cookie-consent.js" defer></script>
<script>
    // 頁面載入時自動執行：同步收藏狀態
    document.addEventListener("DOMContentLoaded", () => {
        fetch("favorite_list.jsp")
            .then(res => res.json())
            .then(data => {
                // 將後端回傳的 ID 整理成陣列 (假設回傳結構是 [{id: 1}, {id: 2}])
                const favoriteIds = data.map(item => item.id);

                // 檢查頁面上每一個產品卡片
                document.querySelectorAll(".product").forEach(product => {
                    const id = parseInt(product.dataset.id);
                    const icon = product.querySelector(".favorite-icon");

                    if (icon) {
                        // 如果該 ID 在清單內，顯示實心；否則顯示空心
                        if (favoriteIds.includes(id)) {
                            icon.src = "images/love.png";
                        } else {
                            icon.src = "images/heart.png";
                        }
                    }
                });
            });
    });
</script>

</body>
</html>
