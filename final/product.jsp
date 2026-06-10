<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page isErrorPage="true" %>
<%@ include file="dbutil.jsp" %>
<%
try {
%>

<%
    // ================= 1. 取得商品 ID =================
    String idStr = request.getParameter("id");
    if (idStr == null) idStr = "1";
    int id = Integer.parseInt(idStr);

    // ================= 2. 分頁設定 =================
    int pageSize = 5;

    String pageStr = request.getParameter("page");
    int currentPage = (pageStr == null) ? 1 : Integer.parseInt(pageStr);
    int offset = (currentPage - 1) * pageSize;

    // ================= 3. DB 連線 =================
    Connection conn = getConnection();

    // ================= 4. 查商品 =================
    PreparedStatement ps = conn.prepareStatement(
        "SELECT * FROM product WHERE  product_id=?"
    );
    ps.setInt(1, id);
    ResultSet rs = ps.executeQuery();
    int stock = 0;

    if (rs.next()) {
      stock = rs.getInt("stock");
%>

<!DOCTYPE html>
<html>
<head>
    <title>找不到商品</title>
</head>
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

    // ================= 5. 評論總數 =================
    int total = 0;

    try {
        PreparedStatement psCount = conn.prepareStatement(
            "SELECT COUNT(*) FROM product_comment WHERE product_id=?"
        );

        psCount.setInt(1, id);
        ResultSet rsCount = psCount.executeQuery();

        if (rsCount.next()) {
            total = rsCount.getInt(1);
        }

        rsCount.close();
        psCount.close();

    } catch (Exception e) {
        out.println("COUNT錯誤：" + e.getMessage());
    }

    int totalPages = (int) Math.ceil(total / (double) pageSize);
%>

<!DOCTYPE html>
<html lang="zh-Hant">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><%=rs.getString("name")%> - STANDARD DAY</title>

<style>
/* ================= 基礎設定 ================= */
body {
  margin: 0;
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
  color: #000;
  background-color: #fff;
}

/* ================= Header ================= */
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
  filter: invert(1);
}

/* ================= 商品主區 ================= */
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
  justify-content: center;
}

.product-info h1 {
  font-size: 32px;
  margin-bottom: 15px;
  font-weight: bold;
}

.product-desc {
  color: #555;
  font-size: 15px;
  line-height: 1.6;
  margin-bottom: 30px;
}

/* ================= 價格 ================= */
.price {
  border-left: 4px solid #565254;
  padding-left: 10px;
  margin-bottom: 30px;
  font-size: 24px;
  font-weight: bold;
  color: #565254;
}

/* ================= 表單 ================= */
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

/* ================= 加入購物車按鈕 ================= */
.add-cart {
  width: 100%;
  margin: 10px 0 20px;
  padding: 14px 0;
  background: #565254;
  color: #fff;
  border: none;
  border-radius: 999px;
  font-size: 15px;
  letter-spacing: 2px;
  cursor: pointer;
  transition: 0.2s ease;
}

.add-cart:hover {
  background: #7A7D7D;
  transform: translateY(-2px);
}

/* ================= Tabs ================= */
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
  color: #666;
}

.tab.active {
  border-bottom: 3px solid #000;
  font-weight: bold;
  color: #000;
}

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

/* ================= 尺寸表 ================= */
.size-table {
  width: 100%;
  max-width: 600px;
  border-collapse: collapse;
  margin: 20px auto;
  font-size: 14px;
}

.size-table th,
.size-table td {
  border: 1px solid #ddd;
  padding: 10px;
  text-align: center;
}

.size-table th {
  background: #f5f5f5;
}

/* ================= 評論區 ================= */
#feedback-form {
  max-width: 600px;
  margin: 20px auto;
}

#feedback-form input,
#feedback-form select,
#feedback-form textarea {
  width: 100%;
  padding: 12px;
  margin: 8px 0;
  border: 1px solid #ddd;
  border-radius: 4px;
}

#feedback-form button {
  padding: 12px 30px;
  background: #333;
  color: #fff;
  border: none;
  cursor: pointer;
}

.feedback-list {
  max-width: 600px;
  margin: 40px auto;
}

.feedback-item {
  border-bottom: 1px solid #eee;
  padding: 15px 0;
}

/* ================= 動畫 ================= */
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
        <img src="<%=rs.getString("image")%>" alt="<%=rs.getString("name")%>">
    </div>

    <div class="product-info fade-up">
        <h1><%=rs.getString("name")%></h1>

        <div class="product-desc">
            <%=rs.getString("description")%>
        </div>

        <div class="price">
            NT$ <%=rs.getInt("price")%>
        </div>

        <div class="form-group">
                  <label>尺寸選擇</label>
                  <select name="size" id="sizeSelect">
                    <option value="S">S</option>
                    <option value="M">M</option>
                    <option value="L">L</option>
                  </select>
                </div>

                <div class="form-group">
                  <label>數量</label>
                  <input type="number" id="qtyInput" value="1" min="1" max="<%=stock%>">
                </div>
                <input type="number" name="quantity" value="1" min="1">
            </div>
            
            <% if (stock > 0) { %>

              <span style="color:green;">庫存：<%=stock%></span>

              <button type="button"
                      class="add-cart"
                      onclick="addToCart(<%=rs.getInt("id")%>)">
                加入購物車
              </button>

              <% } else { %>

              <p style="color:red;">⚠ 已售完</p>
              <button class="add-cart" disabled>已售完</button>

              <% } %>
    </div>
</main>

<!-- ================= Tabs ================= -->
<section class="tabs-section">

<div class="tabs">
    <button class="tab active" data-target="tab-desc">商品描述</button>
    <button class="tab" data-target="tab-shipping">送貨及付款方式</button>
    <button class="tab" data-target="tab-reviews">顧客評價</button>
</div>

<div class="tab-content">

<!-- ===== 商品描述 ===== -->
<div id="tab-desc" class="content active">
    <h3>材質</h3>
    <p>Polyester 80% / Wool 20%</p>
</div>

<!-- ===== 配送 ===== -->
<div id="tab-shipping" class="content">
    <p>
        宅配 / 超商取貨<br>
        2–3 天出貨
    </p>
</div>

<!-- ===== 評價 ===== -->
<div id="tab-reviews" class="content">

<%
Integer userIdObj = (Integer) session.getAttribute("user_id");
String sessionName = (String) session.getAttribute("username");
int userId = (userIdObj == null) ? -1 : userIdObj;
%>

<!-- ===== 評論表單 ===== -->
<div id="feedback-form">

<%
if (userId != -1) {
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

    <textarea name="content" required></textarea>
    <button type="submit">送出評價</button>
</form>

<%
} else {
%>

<p>請登入後留言</p>

<%
}
%>

</div>

<hr>

<!-- ===== 留言列表 ===== -->
<div class="feedback-list">

<%
PreparedStatement ps2 = null;
ResultSet rs2 = null;

try {

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

    while (rs2.next()) {
        hasComment = true;
        int commentUserId = rs2.getInt("user_id");
%>

<div class="feedback-item">
    <strong><%=rs2.getString("username")%></strong>

    <span>
        <%
        for (int i = 0; i < rs2.getInt("rating"); i++) {
            out.print("★");
        }
        %>
    </span>

    <p><%=rs2.getString("content")%></p>
    <small><%=rs2.getTimestamp("create_time")%></small>

    <%
    if (userId != -1 && userId == commentUserId) {
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

    if (!hasComment) {
%>

<p>目前沒有評價</p>

<%
    }

} catch (Exception e) {
%>

<p style="color:red;">留言載入失敗：<%=e.getMessage()%></p>

<%
}
%>

</div>

<!-- ===== 分頁 ===== -->
<div style="text-align:center; margin-top:20px;">

<%
for (int i = 1; i <= totalPages; i++) {
    if (i == currentPage) {
%>
    <b><%=i%></b>
<%
    } else {
%>
    <a href="product.jsp?id=<%=id%>&page=<%=i%>"><%=i%></a>
<%
    }
}
%>

</div>

</div>
</section>

<script>
const tabs = document.querySelectorAll('.tab');
const contents = document.querySelectorAll('.content');

tabs.forEach(tab => {
    tab.addEventListener('click', () => {
        tabs.forEach(t => t.classList.remove('active'));
        contents.forEach(c => c.classList.remove('active'));

        tab.classList.add('active');
        document.getElementById(tab.dataset.target).classList.add('active');
    });
});
async function addToCart(productId) {
    const qty = document.getElementById('qtyInput').value;

    const res = await fetch('addToCart.jsp', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: `product_id=${productId}&quantity=${qty}`
    });

    if (res.status === 401) {
        alert('請先登入');
        location.href = 'login.jsp';
        return;
    }

    const data = await res.json();

    if (data.success) {
        if (confirm(data.msg + '\n\n前往購物車？')) {
            location.href = 'cart.jsp';
        }
    } else {
        alert(data.msg);
    }
}
</script>

</body>
</html>

<%
    // ===== 關閉連線 =====
    try { if (rs != null) rs.close(); } catch (Exception e) {}
    try { if (ps != null) ps.close(); } catch (Exception e) {}
    try { if (conn != null) conn.close(); } catch (Exception e) {}
%>

<%
} catch (Exception e) {
    out.println("<pre style='color:red;'>JSP錯誤：" + e.getMessage());
    e.printStackTrace(new java.io.PrintWriter(out));
}
%>
