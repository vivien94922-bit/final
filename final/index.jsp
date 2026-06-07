<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.*" %>

<%
Connection con = null;
Statement stmt = null;
ResultSet rs = null;

int count = 0;

try{
    // 載入驅動
    Class.forName("com.mysql.cj.jdbc.Driver");

    // 連線資料庫
    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/counter?serverTimezone=Asia/Taipei&characterEncoding=UTF-8",
        "root",
        "1234"
    );

    stmt = con.createStatement();

    // 第一次訪問才增加
    if(session.getAttribute("visited") == null){
        session.setAttribute("visited", "yes");
        stmt.executeUpdate(
            "UPDATE counter SET count = count + 1"
        );
    }

    // 查詢目前人數
    rs = stmt.executeQuery(
        "SELECT count FROM counter"
    );

    if(rs.next()){
        count = rs.getInt("count");
    }

}catch(Exception e){
    out.println("錯誤：" + e.getMessage());
}finally{
    try{
        if(rs != null) rs.close();
    }catch(Exception e){}

    try{
        if(stmt != null) stmt.close();
    }catch(Exception e){}

    try{
        if(con != null) con.close();
    }catch(Exception e){}
}
%>

<!DOCTYPE html>
<html lang="zh-Hant">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>STANDARD DAY Clothing Store</title>
  <link rel="stylesheet" href="style.css">
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
  <script src="products.js"></script>
  <script src="script.js"></script>
  <div class="intro" id="intro">
  <div class="title">
    <span class="left">STANDARD</span>
    <span class="right">DAY</span>
  </div>
</div>
  <header>
    <div class="nav-left">
      <a href="index.jsp" class="logo">STANDARD DAY</a>
    </div>
  
    <div class="nav-icons">
      <div class="search-wrapper">
        <img src="../images/search.png" alt="Search" id="searchIcon">
        <div class="search-box" id="searchBox">
          <div class="search-input">
            <img src="../images/search.png" alt="">
            <input type="text" id="searchInput" placeholder="搜尋商品...">
            <div class="search-result" id="searchResult"></div>
          </div>
        </div>
      </div>
  
      <div class="menu-wrapper">
        <img src="../images/clothes.png" alt="Browse" id="menuIcon">
        <div class="menu-box" id="menuBox">
          <a href="tops.html" class="menu-item">
            <img src="../images/tops.png" alt="Tops">
          </a>
          <a href="bottoms.html" class="menu-item">
            <img src="../images/bottoms.png" alt="Bottoms">
          </a>
        </div>
      </div>
  
      <a href="about.html" title="關於我們">
        <img src="../images/info.png" alt="About">
      </a>
  
      <div id="user-area">
        <a href="member.jsp">
          <img src="../images/user.png" title="註冊 / 登入">
        </a>
      </div>

      <a href="cart.html" title="購物車" id="cartLink">
        <img src="../images/shopping_cart.png" alt="Cart">
      </a>
    </div>
  </header>

  <section class="banner">
    <img id="bannerImage" src="../images/banner1.jpg" alt="Banner">
  
    <div class="banner-text">
      <h1 id="bannerTitle"></h1>
      <p id="bannerDesc"></p>
      <button id="bannerBuyNowBtn">立即選購</button>
    </div>
  
    <div id="dotsContainer" class="dots"></div>
  
    <button class="prev">‹</button>
    <button class="next">›</button>
  </section>

  <div class="visitor">
    您是本站第 <b><%= count %></b> 位訪客
  </div>
  <section class="products">
    <h2>熱門商品</h2>
    <div class="product-grid">

      <div class="product" data-id="1" data-name="夢幻粉色大衣" data-price="1280" data-img="../images/01.jpg">
        <a href="product.jsp?id=1" class="product-link">
          <img src="../images/01.jpg" alt="夢幻粉色大衣">
          <h3 class="product-name">夢幻粉色大衣</h3>
          <div class="product-price">NT$1,280</div>
        </a>
        <img src="../images/heart.png" class="favorite-icon" alt="收藏">
        <button class="add-cart-btn">加入購物車</button>
      </div>
      
      <div class="product" data-id="8" data-name="超前衛運動上衣" data-price="590" data-img="../images/08.jpg">
        <a href="product.jsp?id=8" class="product-link">
          <img src="../images/08.jpg" alt="超前衛運動上衣">
          <h3 class="product-name">超前衛運動上衣</h3>
          <div class="product-price">NT$590</div>
        </a>
        <img src="../images/heart.png" class="favorite-icon" alt="收藏">
        <button class="add-cart-btn">加入購物車</button>
      </div>

      <div class="product" data-id="9" data-name="象牙白打底上衣" data-price="690" data-img="../images/09.jpg">
        <a href="product.jsp?id=9" class="product-link">
          <img src="../images/09.jpg" alt="象牙白打底上衣">
          <h3 class="product-name">象牙白打底上衣</h3>
          <div class="product-price">NT$690</div>
        </a>
        <img src="../images/heart.png" class="favorite-icon" alt="收藏">
        <button class="add-cart-btn">加入購物車</button>
      </div>

    </div>

    <h2>上裝</h2>
    <div class="product-grid">

      <div class="product" data-id="7" data-name="紳士透膚襯衫" data-price="1280" data-img="../images/07.jpg">
        <a href="product.jsp?id=7" class="product-link">
          <img src="../images/07.jpg" alt="紳士透膚襯衫">
          <h3 class="product-name">紳士透膚襯衫</h3>
          <div class="product-price">NT$1,280</div>
        </a>
        <img src="../images/heart.png" class="favorite-icon" alt="收藏">
        <button class="add-cart-btn">加入購物車</button>
      </div>

      <div class="product" data-id="5" data-name="質感牛仔夾克" data-price="1100" data-img="../images/05.jpg">
        <a href="product.jsp?id=5" class="product-link">
          <img src="../images/05.jpg" alt="質感牛仔夾克">
          <h3 class="product-name">質感牛仔夾克</h3>
          <div class="product-price">NT$1,100</div>
        </a>
        <img src="../images/heart.png" class="favorite-icon" alt="收藏">
        <button class="add-cart-btn">加入購物車</button>
      </div>

      <div class="product" data-id="6" data-name="質感黑色牛仔夾克" data-price="1280" data-img="../images/06.jpg">
        <a href="product.jsp?id=6" class="product-link">
          <img src="../images/06.jpg" alt="質感黑色牛仔夾克">
          <h3 class="product-
