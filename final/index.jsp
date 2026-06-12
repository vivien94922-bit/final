<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="dbutil.jsp" %>

<%
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    int visitorCount = 0;

    try {
        con = getConnection();
        // 訪客計數邏輯
        if (session.getAttribute("refresh") == null) {
            ps = con.prepareStatement("UPDATE counter SET count = count + 1 WHERE id = 1");
            ps.executeUpdate();
            ps.close();
            session.setAttribute("refresh", "yes");
        } else {
            session.removeAttribute("refresh");
        }
        ps = con.prepareStatement("SELECT count FROM counter WHERE id = 1");
        rs = ps.executeQuery();
        if (rs.next()) visitorCount = rs.getInt("count");
        rs.close();
        ps.close();
    } catch (Exception e) {
        out.println("資料庫錯誤：" + e.getMessage());
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
    .visitor { width: 200px; margin: 10px auto; padding: 5px; text-align: center; font-size: 18px; }
    /* 確保愛心樣式正確 */
    .favorite-icon { cursor: pointer; display: flex; align-items: center; justify-content: center; padding: 5px; transition: transform 0.2s; }
    .favorite-icon img { width: 20px !important; height: 20px !important; display: block; }
    .favorite-icon:hover { transform: scale(1.2); }
  </style>
</head>
<body>

  <% if ("logout".equals(session.getAttribute("msg"))) { session.removeAttribute("msg"); %>
    <script>alert("您已成功登出");</script>
  <% } %>

  <div class="intro" id="intro">
    <div class="title"><span class="left">STANDARD</span><span class="right">DAY</span></div>
  </div>

  <header>
    <div class="nav-left"><a href="index.jsp" class="logo">STANDARD DAY</a></div>
    <div class="nav-icons">
      <div class="search-wrapper">
        <img src="../images/search.png" alt="Search" id="searchIcon">
        <div class="search-box" id="searchBox">
          <div class="search-input">
            <input type="text" id="searchInput" placeholder="搜尋商品...">
            <div class="search-result" id="searchResult"></div>
          </div>
        </div>
      </div>
      <a href="about.html" title="關於我們"><img src="../images/info.png" alt="About"></a>
      <a href="member.jsp"><img src="../images/user.png" title="註冊 / 登入"></a>
      <a href="cart.jsp" title="購物車" id="cartLink"><img src="../images/shopping_cart.png" alt="Cart"></a>
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

  <div class="visitor">您是本站第 <b><%= visitorCount %></b> 位訪客</div>

  <section class="products">
    <%
      String[] sections = {"hot", "tops", "bottoms"};
      Map<String, String> sectionTitles = new HashMap<>();
      sectionTitles.put("hot", "熱門商品");
      sectionTitles.put("tops", "上裝");
      sectionTitles.put("bottoms", "下裝");

      for(String cat : sections) {
          ps = con.prepareStatement("SELECT * FROM product WHERE category = ?");
          ps.setString(1, cat);
          rs = ps.executeQuery();
          List<Map<String, Object>> productList = new ArrayList<>();
          while(rs.next()){
              Map<String, Object> p = new HashMap<>();
              p.put("id", rs.getInt("id"));
              p.put("name", rs.getString("name"));
              p.put("price", rs.getInt("price"));
              p.put("image", rs.getString("image"));
              p.put("stock", rs.getInt("stock"));
              productList.add(p);
          }
          rs.close(); ps.close();
    %>
        <h2><%= sectionTitles.get(cat) %></h2>
        <div class="product-grid">
        <% if (productList.isEmpty()) { %>
            <div class="empty-msg" style="padding: 20px; color: #888; font-style: italic; width: 100%; text-align: center;">
                目前暫無<%= sectionTitles.get(cat) %>，敬請期待最新上架！
            </div>
        <% } else { %>
            <% for(Map<String, Object> p : productList) { %>
                <div class="product" data-id="<%= p.get("id") %>" data-name="<%= p.get("name") %>" data-price="<%= p.get("price") %>" data-img="<%= p.get("image") %>">
                    <a href="product.jsp?id=<%= p.get("id") %>">
                      <img src="<%= p.get("image") %>" alt="<%= p.get("name") %>">
                      <div class="product-info-header">
                          <h3><%= p.get("name") %></h3>
                          <div class="favorite-icon" onclick="event.preventDefault(); toggleFavorite(this, event)">
                              <img src="../images/heart.png" alt="Favorite">
                          </div>
                      </div>
                      <div class="product-price">NT$<%= p.get("price") %></div>
                      <div class="stock-info">庫存: <%= p.get("stock") %></div>
                    </a>
                    <div class="cart-action">
                        <input type="number" id="qty_<%= p.get("id") %>" value="1" min="1" max="<%= (int)p.get("stock") %>" style="width:50px;">
                        <button class="add-cart-btn" <%= (int)p.get("stock") <= 0 ? "disabled" : "" %> onclick="addToCart(<%= p.get("id") %>)">
                            <%= (int)p.get("stock") > 0 ? "加入購物車" : "補貨中" %>
                        </button>
                    </div>
                </div>
            <% } %>
        <% } %>
        </div>
      <% } %>
    </section>

  <footer>
    <p>聯絡我們｜service@standardday.com</p>
    <p>© 2025 STANDARD DAY. All rights reserved.</p>
  </footer>
  
  <script src="script.js"></script>
  <script src="cookie-consent.js" defer>
    async function addToCart(productId) {
        const qty = document.getElementById('qty_' + productId).value;
        const res = await fetch('addToCart.jsp', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: `product_id=${productId}&quantity=${qty}`
        });
        const data = await res.json();
        alert(data.msg);
    }
  </script>
</body>
</html>
<% if(con != null) con.close(); %>
