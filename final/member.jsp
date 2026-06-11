<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ include file="dbutil.jsp" %>
<%
Integer userId = (Integer) session.getAttribute("user_id");
boolean isLogin = (userId != null);

String name = "";
String email = "";
String phone = "";
%>
<%
if (isLogin) {

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        // 統一連線（組員D：DBUtil）
        conn = getConnection();

        String sql = "SELECT name, email, phone FROM members WHERE id=?";
        ps = conn.prepareStatement(sql);
        if (isLogin) {
          ps.setInt(1, userId);
        }

        rs = ps.executeQuery();

        if (rs.next()) {
            name = rs.getString("name");
            email = rs.getString("email");
            phone = rs.getString("phone");
        }

    } catch (Exception e) {
        out.println("錯誤：" + e.getMessage());
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (ps != null) try { ps.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
}
%>
<!DOCTYPE html>
<html lang="zh-Hant">
<head>
  <meta charset="UTF-8">
  <title>會員中心</title>
  <link rel="stylesheet" href="style.css">
  <script src="products.js"></script>
  <script src="script.js"></script>
  <style>
    header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 15px 40px;
      background-color: #222;
      position: relative;
      z-index: 1000;
    }

    body {
      margin: 0;
      font-family: Arial, sans-serif;
    }

    .member-container {
      display: flex;
      min-height: 200vh;
    }

    .member-sidebar {
      width: 200px;
      background-color: #333;
      color: white;
    }

    .member-sidebar ul {
      list-style: none;
      padding: 0;
      margin: 0;
    }

    .member-sidebar li {
      padding: 15px 15px 15px 30px;
      cursor: pointer;
    }

    .member-sidebar li:hover {
      background-color: #555;
    }

    .member-content {
      flex: 1;
      padding: 30px;
    }

    .content-section {
     opacity: 0;
     max-height: 0;
     overflow: hidden;
     pointer-events: none;
     transition: opacity 0.3s ease;
    }

    .content-section.active {
     opacity: 1;
     max-height: 2000px;
     pointer-events: auto;
    }

    .form-group {
      margin-bottom: 15px;
    }

    .form-group label {
      display: block;
      margin-bottom: 5px;
    }

    .form-group input {
      width: 300px;
      padding: 8px;
      box-sizing: border-box;
    }

    .save-btn {
      padding: 10px 20px;
      background-color: #333;
      color: white;
      border: none;
      cursor: pointer;
    }

    .save-btn:hover {
      background-color: #555;
    }

    .logo {
      color: white;
      font-size: 24px;
      font-weight: bold;
      text-decoration: none;
    }

    /* ===== Header Icons Layout ===== */

    .nav-icons {
      display: flex;
      align-items: center;
      gap: 20px;
    }

    .nav-icons img {
      width: 22px;
      height: 22px;
      cursor: pointer;
      filter: invert(1);
    }

    .nav-icons img:hover {
      opacity: 0.8;
    }

    .search-wrapper,
    .menu-wrapper {
      position: relative;
    }

    .search-box {
      position: absolute;
      top: 100%;
      left: 50%;
      transform: translateX(-50%);
      background: white;
      border: 1px solid #ddd;
      padding: 10px;
      display: none;
      min-width: 160px;
      z-index: 1000;
    }

    .menu-box {
      position: absolute;
      top: 100%;
      left: 0;
      transform: translateX(-50%);
      background: white;
      border: 1px solid #ddd;
      padding: 10px;
      display: none;
      min-width: 160px;
      z-index: 2000;
    }

    .search-input {
      display: flex;
      align-items: center;
      gap: 5px;
    }

    .search-input input {
      border: 1px solid #ccc;
      padding: 5px;
      width: 120px;
    }

    .menu-box a {
      display: block;
      padding: 5px 0;
      text-decoration: none;
      color: #333;
    }

    .menu-box a:hover {
      color: #000;
      font-weight: bold;
    }

    .menu-box .menu-item {
      display: flex;
      align-items: center;
      justify-content: center; /* 圖片置中 */
      margin: 5px 0;
    }

    .menu-box .menu-item img {
      width: 100%;
      display: block;
    }

     /* ===== FAQ 樣式 ===== */

  .faq {
    max-width: 450px;
    margin-top: 20px;
  }

  .faq-item {
    border-bottom: 1px solid #ddd;
    width:450px
  }

  .faq-question {
    width: 100%;
    background: none;
    border: none;
    padding: 15px;
    font-size: 16px;
    text-align: left;
    display: flex;
    justify-content: space-between;
    align-items: center;
    cursor: pointer;
  }

  .faq-question .icon {
    transition: transform 0.3s ease;
    font-size: 20px;
  }

  .faq-answer {
    max-height: 0;
    overflow: hidden;
    padding: 0 15px;
    transition: max-height 0.3s ease, padding 0.3s ease;
  }

  .faq-item.active .faq-answer {
    max-height: 200px;
    padding: 10px 15px 20px;
  }

  .faq-item.active .icon {
    transform: rotate(45deg); /* + 變成 × */
  }
  /* ===== 收藏 ===== */
  /* 收藏列表容器 */
#favorite-list {
  display: flex;
  flex-direction: column;
  gap: 15px;
  padding: 10px 0;
  max-width: 1000px;
}

/* 每個商品卡片 */
#favorite-list .product {
  display: flex;
  align-items: left;
  background-color: #fff;
  border: 1px solid #ddd;
  border-radius: 10px;
  overflow: hidden;
  padding: 10px;
  transition: box-shadow 0.2s;
}

#favorite-list .product:hover {
  box-shadow: 0 4px 10px rgba(0,0,0,0.1);
}

/* 商品圖片 */
#favorite-list .product img {
  width: 150px;
  height: 150px;
  object-fit: cover;
  border-radius: 8px;
  margin-left: 0;
}

/* 文字區塊 */
#favorite-list .product-info {
  flex: 1;
  flex-direction: column;
  justify-content: right;
}

/* 商品名稱 */
#favorite-list .product-name {
  font-weight: bold;
  font-size: 18px;
  margin-bottom: 5px;
}

/* 價格 */
#favorite-list .product-price {
  font-size: 16px;
  font-weight: bold;
  margin-bottom: 10px;
}

/* 加入購物車按鈕 */
#favorite-list .add-cart-btn {
  width: fit-content;
  background-color: #000;
  color: #fff;
  border: none;
  border-radius: 5px;
  padding: 6px 12px;
  cursor: pointer;
}

/* 收藏愛心 */
#favorite-list .favorite-icon {
  width: 24px;
  height: 24px;
  margin-left: 15px;
  cursor: pointer;
  transition: transform 0.2s;
}

#favorite-list .favorite-icon:hover {
  transform: scale(1.3);
}
  </style>
</head>

<body>
  <body data-login="<%= (session.getAttribute("user_id") != null) %>">
  <!-- ===== Header / Navbar（共用） ===== -->
  <header>
    <div class="nav-left">
      <a href="index.jsp" class="logo">STANDARD DAY</a>
    </div>
  
    <div class="nav-icons">
      <div class="search-wrapper">
        <img src="../images/search.png" alt="Search" id="searchIcon">
        <div class="search-box" id="searchBox">
          <div class="search-input">
            <img src="../images/search.png" alt=""> <input type="text" id="searchInput" placeholder="搜尋商品...">
            <div class="search-result" id="searchResult"></div>
          </div>
        </div>
      </div>
  
      <div class="menu-wrapper">
        <img src="../images/clothes.png" alt="Browse" id="menuIcon"> <div class="menu-box" id="menuBox">
          <a href="tops.html" class="menu-item">
            <img src="../images/tops.png" alt="Tops"> </a>
          <a href="bottoms.html" class="menu-item">
            <img src="../images/bottoms.png" alt="Bottoms"> </a>
        </div>
      </div>
  
      <a href="about.html" title="關於我們">
        <img src="../images/info.png" alt="About"> </a>
  
      <a href="member.jsp" title="會員中心" id="memberLink">
        <img src="../images/user.png" alt="Member"> </a>
  
      <a href="cart.html" title="購物車" id="cartLink">
        <img src="../images/shopping_cart.png" alt="Cart"> </a>
    </div>
</header>

  <!-- ===== 會員中心 ===== -->
  <div class="member-container">

    <aside class="member-sidebar">
      <ul>
    
        <li onclick="showSection('register')">會員註冊</li>
    
        <% if(isLogin){ %>
          <li onclick="showSection('profile')">會員資料</li>
          <li onclick="showSection('orders')">訂單紀錄</li>
          <li onclick="showSection('password')">修改密碼</li>
          <li onclick="showSection('like')">收藏商品</li>
          <li onclick="showSection('question')">常見問題</li>
          <li onclick="location.href='logout.jsp'">登出</li>
        <% } else { %>
          <li onclick="checkLoginThen('profile')">會員資料</li>
          <li onclick="checkLoginThen('orders')">訂單紀錄</li>
          <li onclick="checkLoginThen('password')">修改密碼</li>
          <li onclick="checkLoginThen('like')">收藏商品</li>
          <li onclick="checkLoginThen('question')">常見問題</li>
        <% } %>
    
      </ul>
    </aside>

    <main class="member-content">
      <h1>會員中心</h1>
      <section id="register" class="content-section">
        <h2>會員註冊</h2>
      
        <form action="register_process.jsp" method="post">
          帳號：<input type="text" name="username" required><br><br>
          密碼：<input type="password" name="password" required><br><br>
          姓名：<input type="text" name="name" required><br><br>
          Email：<input type="email" name="email" required><br><br>
          電話：<input type="text" name="phone" required><br><br>
      
          <button type="submit" class="save-btn">註冊</button>
        </form>
      </section>
      <section id="profile" class="content-section <%= isLogin ? "active" : "" %>">
        
      <h2>會員資料</h2>

      <div class="profile-box">
        <p><b>姓名：</b> <%= name %></p>
        <p><b>Email：</b> <%= email %></p>
        <p><b>電話：</b> <%= phone %></p>
      </div>
      </section>

      <section id="like" class="content-section">
        <h2>收藏商品</h2>
        <div id="favorite-list" class="product-grid">
          <!-- 收藏商品會動態生成在這裡 -->
        </div>
      </section>
      <section id="orders" class="content-section">
        <h2>訂單紀錄</h2>
        <p>目前尚無訂單</p>
      </section>

      <section id="password" class="content-section">
        <h2>修改密碼</h2>
        <input type="password" placeholder="舊密碼"><br><br>
        <input type="password" placeholder="新密碼"><br><br>
        <button class="save-btn">送出</button>
      </section>
      
      <section id="question" class="content-section">
        <h2 class="faq-title">常見問題</h2>
      
        <div class="faq-item">
          <button type="button" class="faq-question">
            如何修改會員資料？
            <span class="icon">+</span>
          </button>
          <div class="faq-answer">
            你可以在會員中心的「會員資料」頁面修改。
          </div>
        </div>
      
        <div class="faq-item">
          <button type="button" class="faq-question">
            忘記密碼怎麼辦？
            <span class="icon">+</span>
          </button>
          <div class="faq-answer">
            請點擊登入頁的「忘記密碼」進行重設。
          </div>
        </div>
      
        <div class="faq-item">
          <button type="button" class="faq-question">
            有提供海外配送服務嗎？
            <span class="icon">+</span>
          </button>
          <div class="faq-answer">
            目前無法提供海外配送服務，請見諒。
          </div>
        </div>
      
        <div class="faq-item">
          <button type="button" class="faq-question">
            可以以非會員身分購買嗎？
            <span class="icon">+</span>
          </button>
          <div class="faq-answer">
            所有訂單皆需以電子信箱註冊並登入後方可結帳。
          </div>
        </div>
      
        <div class="faq-item">
          <button type="button" class="faq-question">
            如何取消訂單？
            <span class="icon">+</span>
          </button>
          <div class="faq-answer">
            若需訂單取消，請儘早於出貨前聯絡客服。若商品已進倉或已發貨，可能需依「退貨流程」處理，且可能產生運費。
          </div>
        </div>
      
        <div class="faq-item">
          <button type="button" class="faq-question">
            訂單送出後我可以修改我的運送地址嗎？
            <span class="icon">+</span>
          </button>
          <div class="faq-answer">
            若訂單已付費且欲修改地址，請立即以訂單編號聯絡我們。一旦倉庫已處理訂單，將無法編輯地址或修改訂單。
          </div>
        </div>
      
        <div class="faq-item">
          <button type="button" class="faq-question">
            聯絡我們
            <span class="icon">+</span>
          </button>
          <div class="faq-answer">
            <p>客服電話：03-1234-4321</p>
            <p>客服信箱：standardday@gmail.com</p>
            <p>週一至週五 10:00-12:00/13:00-18:00</p>
          </div>
        </div>
      
      </section>


    </main>
  </div>

  <script>
    /* ==================== 頁面切換 ==================== */
    function showSection(id) {
      document.querySelectorAll('.content-section').forEach(section => {
        section.classList.remove('active');
      });
      document.getElementById(id).classList.add('active');
    }
  
    /* ==================== 收藏功能 ==================== */
    function loadFavorites() {
      const favoriteList = document.getElementById('favorite-list');
      if (!favoriteList) return;
      favoriteList.innerHTML = '';
      let favorites = JSON.parse(localStorage.getItem('favorites')) || [];
      
      if (favorites.length === 0) {
        favoriteList.innerHTML = `<p style="color:#777; padding:20px 0;">目前沒有收藏商品</p>`;
        return;
      }
    
        favorites.forEach(item => {
        const div = document.createElement('div');
        div.classList.add('product');
        div.innerHTML = `
          <img src="${item.img}" alt="${item.name}">
          <div class="product-info">
            <h3 class="product-name">${item.name}</h3>
            <div class="product-price">NT$${item.price}</div>
            <button class="add-cart-btn">加入購物車</button>
          </div>
          <img src="images/love.png" class="favorite-icon" onclick="removeFavorite('${item.id}', this)" alt="收藏">
        `;
        favoriteList.appendChild(div);
      
        // 綁定事件一次，避免重複 alert
        div.querySelector('.add-cart-btn').addEventListener('click', () => {
          addToCartFromMember(div.querySelector('.add-cart-btn'), item.id, item.name, item.price, item.img);
        });
      });
    } 
    
    
    function removeFavorite(id, icon) {
      let favorites = JSON.parse(localStorage.getItem('favorites')) || [];
      favorites = favorites.filter(item => item.id !== id);
      localStorage.setItem('favorites', JSON.stringify(favorites));
      icon.closest('.product').remove();
    }
    
    function addToCartFromMember(btn, id, name, price, img) {
      // 這裡確保即使 script.js 沒載入，至少會跳通知
      if (typeof addToCart === 'function') {
        addToCart(btn);
      } else {
        alert(`已將 ${name} 加入購物車 (購物車功能由 script.js 提供)`);
      }
    }
    function checkLoginThen(sectionId) {

    const isLogin = document.body.dataset.login === "true";

    if (!isLogin) {
        alert("請先登入會員");
        window.location.href = "login.jsp";
        return;
    }

    showSection(sectionId);
    }
    /* ==================== 核心修正：導航欄控制 ==================== */
    document.addEventListener('DOMContentLoaded', () => {

  loadFavorites();

  // FAQ
  document.querySelectorAll('.faq-question').forEach(btn => {
    btn.addEventListener('click', () => {
      const item = btn.closest('.faq-item');
      item.classList.toggle('active');
    });
  });

  // menu
  const menuIcon = document.getElementById("menuIcon");
  const menuWrapper = document.querySelector('.menu-wrapper');

  if (menuIcon && menuWrapper) {
    menuIcon.addEventListener("click", (e) => {
      e.stopPropagation();
      menuWrapper.classList.toggle("active");
    });
  }

  document.addEventListener("click", () => {
    if (menuWrapper) menuWrapper.classList.remove("active");
  });

  // profile form
  const profileForm = document.getElementById("profileForm");
  if (profileForm) {
    profileForm.addEventListener("submit", e => {
      e.preventDefault();

      const name = document.getElementById("name").value.trim();
      const email = document.getElementById("email").value.trim();
      const phone = document.getElementById("phone").value.trim();

      if (!name || !email || !phone) {
        alert("請填寫完整會員資料");
        return;
      }

      localStorage.setItem("user", name);

      alert("登入成功！");

      const redirect = localStorage.getItem("redirectAfterLogin") || "index.jsp";
      localStorage.removeItem("redirectAfterLogin");
      window.location.href = redirect;
    });
  }

  // ⭐⭐⭐ 這個才是正確 hash 處理（重點）
  const hash = window.location.hash;
  if (hash) {
    const sectionId = hash.replace("#", "");
    showSection(sectionId);
  }
  function logout() {
  // 清掉登入相關資料
  localStorage.removeItem("user");
  localStorage.removeItem("isLogin");
  localStorage.removeItem("userProfile");
  localStorage.removeItem("cart"); // 可選
  localStorage.removeItem("favorites"); // 可選

  alert("已成功登出");

  // 導回首頁
  window.location.href = "index.jsp";
}
});
  </script>

  <!-- Cookie 同意提示（組員D：個資法/Cookie） -->
  <script src="cookie-consent.js" defer></script>

</body>
</html>


