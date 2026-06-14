<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<header>
  <div class="nav-left">
    <a href="index.jsp" class="logo">STANDARD DAY</a>
  </div>

  <div class="nav-icons">

    <!-- 搜尋 -->
    <div class="search-wrapper">
      <img src="images/search.png" id="searchIcon">

      <div class="search-box" id="searchBox">
        <div class="search-input">
          <img src="images/search.png">

          <input type="text" id="searchInput" placeholder="搜尋商品...">

          <div class="search-result" id="searchResult"></div>
        </div>
      </div>
    </div>

    <!-- 選單 -->
    <div class="menu-wrapper">
      <img src="images/clothes.png" id="menuIcon">

      <div class="menu-box" id="menuBox">
        <a href="tops.jsp" class="menu-item">
          <img src="images/tops.png">
        </a>
        <a href="bottoms.jsp" class="menu-item">
          <img src="images/bottoms.png">
        </a>
      </div>
    </div>

    <a href="about.jsp"><img src="images/info.png"></a>
    <a href="member.jsp"><img src="images/user.png"></a>
    <a href="cart.jsp"><img src="images/shopping_cart.png"></a>
    <a href="admin_login.jsp"><img src="images/tool.png"></a>

  </div>
</header>