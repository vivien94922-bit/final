<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbutil.jsp" %>
<!DOCTYPE html>
<html lang="zh-Hant">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>上裝 Tops</title>
<link rel="stylesheet" href="style.css">
<script src="script.js" defer></script>
</head>
<body>
<%@ include file="header.jsp" %>
<%
Connection con = getConnection();
PreparedStatement ps = con.prepareStatement(
    "SELECT * FROM product WHERE category = 'tops'"
);
ResultSet rs = ps.executeQuery();
%>

<section class="products">
  <h2>上裝 Tops</h2>

  <div class="product-grid">

  <%
  while(rs.next()){
      int id = rs.getInt("id");
      String name = rs.getString("name");
      int price = rs.getInt("price");
      String image = rs.getString("image");
  %>

    <div class="product" data-id="<%= id %>">
      <a href="product.jsp?id=<%= rs.getInt("id") %>" class="product-link">

        <img src="<%= rs.getString("image") %>">

        <div class="product-info">
          <div class="product-name"><%= rs.getString("name") %></div>
          <div class="product-price">NT$<%= rs.getInt("price") %></div>
        </div>

      </a>

      <img src="images/heart.png" class="favorite-icon" onclick="toggleFavorite(event, this)">
      <button class="add-cart-btn">加入購物車</button>

    </div>

  <%
  }
  rs.close();
  ps.close();
  con.close();
  %>

  </div>
</section>

<footer>
  <p>聯絡我們｜service@standardday.com</p>
  <p>© 2025 STANDARD DAY. All rights reserved.</p>
  <p><a href="privacy.html" style="color:#bbb;">隱私權政策</a></p>
</footer>

<button id="backToTop" title="回到頂部">↑</button>

<!-- Cookie 同意提示（組員D：個資法/Cookie） -->
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
