<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ include file="dbutil.jsp" %>
<%
    Integer userId = (Integer) session.getAttribute("user_id");
    boolean isLogin = (userId != null);

    String name = "", email = "", phone = "";
    
    // 💡 關鍵：在最外面宣告，讓整個頁面都能共用這個 conn
    Connection conn = null; 

    try {
        conn = getConnection(); // 在最上方開啟一次

        // 1. 處理會員資料
        if (isLogin) {
            String sql = "SELECT name, email, phone FROM members WHERE id=?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        name = rs.getString("name");
                        email = rs.getString("email");
                        phone = rs.getString("phone");
                    }
                }
            }
        }
    } catch (Exception e) {
        out.println("錯誤：" + e.getMessage());
    }
%>
<!DOCTYPE html>
<html lang="zh-Hant">
<head>
  <meta charset="UTF-8">
  <title>會員中心</title>
  <link rel="stylesheet" href="style.css">
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
/* 收藏列表容器：改為並排模式 */
#favorite-list {
  display: flex;
  flex-wrap: wrap; /* 允許換行 */
  gap: 20px;       /* 卡片之間的間距 */
  padding: 10px;
  max-width: 1000px;
}

/* 每個商品卡片：改為垂直結構以符合變窄的需求 */
#favorite-list .product {
  display: flex;
  flex-direction: column; /* 圖片在上方，文字在下方 */
  width: 200px;           /* 設定卡片寬度，讓它變窄 */
  background-color: #fff;
  border: 1px solid #ddd;
  border-radius: 10px;
  overflow: hidden;
  padding: 15px;
  transition: box-shadow 0.2s;
  position: relative;     /* 為了讓愛心可以放在右上角 */
}

#favorite-list .product:hover {
  box-shadow: 0 4px 10px rgba(0,0,0,0.1);
}

/* 商品圖片：填滿卡片寬度 */
#favorite-list .product img {
  width: 100%;
  height: 200px;          /* 根據你的美感調整高度 */
  object-fit: cover;
  border-radius: 8px;
}

/* 文字區塊 */
#favorite-list .product-info {
  margin-top: 10px;
}

/* 商品名稱 */
#favorite-list .product-name {
  font-weight: bold;
  font-size: 16px;
  margin-bottom: 5px;
  white-space: nowrap;    /* 防止名稱過長跑版 */
  overflow: hidden;
  text-overflow: ellipsis;
}

/* 價格 */
#favorite-list .product-price {
  font-size: 14px;
  color: #555;
  margin-bottom: 10px;
}

/* 按鈕區塊 */
#favorite-list .add-cart-btn {
  width: 100%;            /* 按鈕寬度填滿 */
  background-color: #000;
  color: #fff;
  border: none;
  border-radius: 5px;
  padding: 8px;
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

button {
  padding: 10px 18px;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-size: 14px;
  margin-right: 10px;
  transition: 0.2s ease;
}

.form-box {
  width: 400px;
}

.form-row {
  display: flex;
  align-items: center;
  margin-bottom: 12px;
}

.form-row label {
  width: 80px;   /* 👉 關鍵：讓欄位統一寬度 */
  font-weight: bold;
}

.form-row input {
  flex: 1;
  padding: 6px;
}

.form-actions {
  margin-top: 20px;
  display: flex;
  gap: 10px;
}
#orders {
  width: 100%;
  border-collapse: collapse;
  margin-top: 20px;
  /* 加入背景色，遮住後方的背景圖 */
  background-color: rgba(255, 255, 255, 0.9); 
  /* 加入圓角與陰影，讓表格看起來更精緻且與背景脫離 */
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 4px 6px rgba(0,0,0,0.1);
}

#orders th, #orders td {
  padding: 12px;
  border: 1px solid #ddd;
  text-align: left;
  /* 確保文字顏色清晰，避免與背景圖混淆 */
  color: #333;
}

#orders th {
  /* 表頭用較深的顏色與內容區隔 */
  background-color: #eee; 
  font-weight: bold;
}

/* 增加斑馬紋效果，閱讀更方便 */
#orders tr:nth-child(even) {
  background-color: rgba(0, 0, 0, 0.03);
}
  </style>
</head>

<body>
  <%@ include file="header.jsp" %>
  <div class="member-container">  

    <aside class="member-sidebar">
      <ul>
        <% if(isLogin){ %>
          <li onclick="showSection('profile')">會員資料</li>
          <li onclick="showSection('orders')">訂單紀錄</li>
          <li onclick="showSection('like')">收藏商品</li>
          <li onclick="showSection('question')">常見問題</li>
          <li onclick="location.href='logout.jsp'">登出</li>
        <% } else { %>
          <li onclick="location.href='login.jsp'">會員登入和註冊</li>
          <li onclick="alert('請先登入會員！')">會員資料</li>
          <li onclick="alert('請先登入會員！')">訂單紀錄</li>
          <li onclick="alert('請先登入會員！')">收藏商品</li>
          <li onclick="showSection('question')">常見問題</li>
        <% } %>
      </ul>
    </aside>

    <main class="member-content">
      <h1>會員中心</h1>

      <section id="profile" class="content-section <%= isLogin ? "active" : "" %>">
        <h2>會員資料</h2>
        
        <div id="profileViewBox" class="profile-box">
          <p><b>姓名：</b> <%= (name == null || name.equals("")) ? "（未取得資料）" : name %></p>
          <p><b>Email：</b> <%= (email == null || email.equals("")) ? "（未取得資料）" : email %></p>
          <p><b>電話：</b> <%= (phone == null || phone.equals("")) ? "（未取得資料）" : phone %></p>
          
          <div class="form-actions" style="margin-top: 20px;">
            <button type="button" class="save-btn" onclick="switchToEditMode()">修改資料</button>
          </div>
        </div>

        <form action="update_profile.jsp" method="post" class="form-box" id="profileEditForm" style="display: none;">
          <div class="form-row">
            <label>姓名</label>
            <input type="text" name="name" value="<%= (name == null) ? "" : name %>" required>
          </div>
          
          <div class="form-row">
            <label>Email</label>
            <input type="email" name="email" value="<%= (email == null) ? "" : email %>" required>
          </div>
          
          <div class="form-row">
            <label>電話</label>
            <input type="text" name="phone" value="<%= (phone == null) ? "" : phone %>" required>
          </div>
          
          <div class="form-actions">
            <button type="submit" class="save-btn" style="background-color: #28a745;">送出修改</button>
            <button type="button" class="save-btn" style="background-color: #dc3545;" onclick="switchToViewMode()">取消</button>
          </div>
        </form>
      </section>

      <section id="like" class="content-section">
        <h2>收藏商品</h2>
        <div id="favorite-list" class="product-grid">
          <!-- 收藏商品會動態生成在這裡 -->
        </div>
      </section>

      <section id="orders" class="content-section">
        <h2>訂單紀錄</h2>
  <div class="box">
    <table>
      <thead>
        <tr>
          <th>訂單編號</th>
          <th>商品內容</th>
          <th>總金額</th>
          <th>訂單狀態</th>
          <th>訂單日期</th>
        </tr>
      </thead>
      <tbody>
        <%
                if (isLogin) {
                    String orderSql = "SELECT id, total, status, created_at FROM orders WHERE member_id = ? ORDER BY id DESC";
                    try (PreparedStatement psOrder = conn.prepareStatement(orderSql)) {
                        psOrder.setInt(1, userId);
                        try (ResultSet rsOrder = psOrder.executeQuery()) {
                            while (rsOrder.next()) {
                                int orderId = rsOrder.getInt("id");
                %>
                <tr>
                    <td>#<%= orderId %></td>
                    <td>
                        <% 
                          String itemSql = "SELECT name, quantity FROM order_items WHERE order_id = ?";
                          try (PreparedStatement psItem = conn.prepareStatement(itemSql)) {
                              psItem.setInt(1, orderId);
                              ResultSet rsItem = psItem.executeQuery();
                              while(rsItem.next()) {
                                  out.print(rsItem.getString("name") + " x " + rsItem.getInt("quantity") + "<br>");
                              }
                          }
                        %>
                    </td>
                    <td>NT$ <%= rsOrder.getInt("total") %></td>
                    <td><%= rsOrder.getString("status") %></td>
                    <td><%= rsOrder.getString("created_at") %></td>
                </tr>
                <% 
                            }
                        }
                    }
                }
                %>
      </tbody>
    </table>
  </div>
      </section>
      
      <section id="question" class="content-section <%= !isLogin ? "active" : "" %>">
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
    // 點擊「修改資料」：隱藏文字，顯示輸入框
    function switchToEditMode() {
      document.getElementById('profileViewBox').style.display = 'none';  // 隱藏純文字
      document.getElementById('profileEditForm').style.display = 'block'; // 顯示表單
    }

    // 點擊「取消」：隱藏輸入框，顯示文字
    function switchToViewMode() {
      document.getElementById('profileEditForm').style.display = 'none';  // 隱藏表單
      document.getElementById('profileViewBox').style.display = 'block'; // 顯示純文字
      
      // 可選：如果使用者有改動欄位但點了取消，重整頁面可以將輸入框內容重設回原本的資料
      // location.reload(); 
    }
    /* ==================== 頁面切換 ==================== */
    function showSection(id) {
      document.querySelectorAll('.content-section').forEach(section => {
        section.classList.remove('active');
      });
      const target = document.getElementById(id);
      if (target) target.classList.add('active');
    }

    /* ==================== 收藏==================== */
window.loadFavorites = function() {
    const box = document.getElementById("favorite-list");
    if (!box) return;

    fetch("favorite_list.jsp")
        .then(res => {
            if (!res.ok) throw new Error("伺服器回應錯誤");
            return res.json();
        })
        .then(data => {
            console.log("收藏清單資料:", data);

            if (!data || data.length === 0) {
                box.innerHTML = "<p>目前沒有收藏商品</p>";
                return;
            }

            // 使用 DocumentFragment 減少重繪次數 (效能優化)
            const fragment = document.createDocumentFragment();

            data.forEach(item => {
                const div = document.createElement("div");
                div.className = "product";
                div.dataset.id = item.id;
                
                // 採用字串拼接以保持你的習慣，但結構更清晰
                div.innerHTML = 
                    '<a href="product.jsp?id=' + item.id + '" class="product-link">' +
                        '<img src="' + item.img + '" alt="' + item.name + '">' +
                        '<div class="product-info">' +
                            '<div class="product-name">' + item.name + '</div>' +
                            '<div class="product-price">NT$' + item.price + '</div>' +
                        '</div>' +
                    '</a>' +
                    '<button class="add-cart-btn">加入購物車</button>' +
                    '<img src="images/love.png" class="favorite-icon">';
                
                fragment.appendChild(div);
            });

            box.innerHTML = ""; // 先清空
            box.appendChild(fragment); // 一次性加入 DOM
        })
        .catch(err => {
            console.error("載入收藏失敗:", err);
            box.innerHTML = "<p style='color:red;'>載入失敗，請檢查網路連線。</p>";
        });
};
    /* ==================== 初始化與事件監聽 ==================== */
    document.addEventListener('DOMContentLoaded', () => {
      loadFavorites();

      // FAQ 切換
      document.querySelectorAll('.faq-question').forEach(btn => {
        btn.addEventListener('click', () => {
          btn.closest('.faq-item').classList.toggle('active');
        });
      });

      // 檢查網址 Hash
      const hash = window.location.hash;
      if (hash) {
        const sectionId = hash.replace("#", "");
        showSection(sectionId);
      }
    });
  </script>
</body>
</html>
<%
    // 💡 最後在這裡關閉連線，這行一定要在 </html> 標籤外面或最後面
    if (conn != null) try { conn.close(); } catch (Exception e) {}
%>
