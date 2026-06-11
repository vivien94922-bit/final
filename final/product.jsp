<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page isErrorPage="true" %>
<%@ include file="dbutil.jsp" %>
<%
    // ==========================================
    // 1. 後端後台邏輯區 (變數宣告與資料庫查詢)
    // ==========================================
    Connection conn = null;
    PreparedStatement ps1 = null; // 查詢商品
    PreparedStatement ps2 = null; // 查詢評論數(算分頁)
    PreparedStatement ps3 = null; // 查詢評論列表
    
    ResultSet rs1 = null;
    ResultSet rs2 = null;
    ResultSet rs3 = null;

    String name = "";
    int price = 0;
    int stock = 0;
    String nameImage = "";
    String description = "";
    
    int pageSize = 5;
    int currentPage = 1;
    int totalPage = 1;
    int offset = 0;
    int id = 0;

    try {
        // 取得商品 ID
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            out.println("<h2 style='text-align:center;color:red;'>錯誤：未提供商品 ID</h2>");
            return;
        }
        id = Integer.parseInt(idStr);
        
        // 取得目前分頁頁碼
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.trim().isEmpty()) {
            currentPage = Integer.parseInt(pageStr);
        }
        offset = (currentPage - 1) * pageSize;

        // 建立連線 —— 【呼叫 dbutil.jsp 裡的方法】
        conn = getConnection(); 
        if (conn == null) {
            throw new SQLException("資料庫連線建立失敗，請檢查 dbutil.jsp 的設定。");
        }

        // 查詢商品詳細資訊
        String sqlProduct = "SELECT * FROM product WHERE id = ?";
        ps1 = conn.prepareStatement(sqlProduct);
        ps1.setInt(1, id);
        rs1 = ps1.executeQuery();

        if (rs1.next()) {
            name = rs1.getString("name");
            price = rs1.getInt("price");
            stock = rs1.getInt("stock");
            nameImage = rs1.getString("image"); 
            description = rs1.getString("description");
        } else {
            // 找不到商品，顯示客製化錯誤畫面
            %>
            <!DOCTYPE html>
            <html>
            <head>
                <meta charset="UTF-8">
                <title>找不到商品</title>
            </head>
            <body>
                <h2 style="text-align:center; margin-top:50px;">找不到該商品，請重新確認商品 ID。</h2>
            </body>
            </html>
            <%
            if (rs1 != null) rs1.close();
            if (ps1 != null) ps1.close();
            if (conn != null) conn.close();
            return; 
        }

        // 計算該商品總共有幾條評論，並算出總頁數
        String sqlCount = "SELECT COUNT(*) FROM product_comment WHERE product_id = ?";
        ps2 = conn.prepareStatement(sqlCount);
        ps2.setInt(1, id);
        rs2 = ps2.executeQuery();
        if (rs2.next()) {
            int totalComments = rs2.getInt(1);
            totalPage = (int) Math.ceil((double) totalComments / pageSize);
            if (totalPage == 0) totalPage = 1; // 至少有一頁
        }

    } catch (Exception e) {
        out.println("<pre style='color:red;'>JSP 初始化階段錯誤：" + e.getMessage() + "</pre>");
        e.printStackTrace(new java.io.PrintWriter(out));
        return;
    }
%>

<%-- ========================================== --%>
<%-- 2. 前端畫面呈現區                             --%>
<%-- ========================================== --%>
<!DOCTYPE html>
<html lang="zh-Hant">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><%=name%> - STANDARD DAY</title>

<link rel="stylesheet" href="style.css">
<script src="cookie-consent.js" defer></script>
<script src="script.js" defer></script>
</head>
<body>

<header>
    <div class="nav-left">
        <a href="index.jsp" class="logo">STANDARD DAY</a>
    </div>
    <div class="nav-icons">
        <a href="cart.jsp">
            <img src="images/shopping_cart.png" alt="購物車">
        </a>
    </div>
</header>

<main class="product-container">
    <div class="product-images fade-up">
      <img src="<%=nameImage%>" alt="<%=name%>">
    </div>

    <div class="product-info fade-up">
        <h1><%=name%></h1>

        <div class="product-desc">
          <%=description != null ? description : "暫無商品描述"%>
        </div>

        <div class="price">
            NT$ <%=price%>
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
        
        <% if (stock > 0) { %>
            <span style="color:green; font-weight:bold; display:block; margin-bottom:10px;">庫存：<%=stock%></span>
            <button type="button" class="add-cart" onclick="addToCart(<%=id%>)">加入購物車</button>
        <% } else { %>
            <p style="color:red; font-weight:bold;">⚠ 已售完</p>
            <button class="add-cart" disabled>已售完</button>
        <% } %>
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
        <h3>材質</h3>
        <p>Polyester 80% / Wool 20%</p>
    </div>

    <div id="tab-shipping" class="content">
        <p>
            宅配 / 超商取貨<br>
            2–3 天出貨
        </p>
    </div>

    <div id="tab-reviews" class="content">
        <%
        Integer userIdObj = (Integer) session.getAttribute("user_id");
        String sessionName = (String) session.getAttribute("username");
        int userId = (userIdObj == null) ? -1 : userIdObj;
        %>

        <div id="feedback-form">
        <% if (userId != -1) { %>
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

                <textarea name="content" placeholder="請輸入評價內容..." required></textarea>
                <button type="submit">送出評價</button>
            </form>
        <% } else { %>
            <p>請登入後留言</p>
        <% } %>
        </div>

        <hr>

        <div class="feedback-list">
        <%
        try {
            String sqlCommentList = "SELECT * FROM product_comment WHERE product_id=? ORDER BY create_time DESC LIMIT ?, ?";
            ps3 = conn.prepareStatement(sqlCommentList);
            ps3.setInt(1, id);
            ps3.setInt(2, offset);
            ps3.setInt(3, pageSize);
            rs3 = ps3.executeQuery();

            boolean hasComment = false;

            while (rs3.next()) {
                hasComment = true;
                int commentUserId = rs3.getInt("user_id");
        %>
                <div class="feedback-item" style="text-align: left;">
                    <strong><%=rs3.getString("username")%></strong>
                    <span style="color: #f39c12;">
                        <%
                        for (int i = 0; i < rs3.getInt("rating"); i++) {
                            out.print("★");
                        }
                        %>
                    </span>

                    <p><%=rs3.getString("content")%></p>
                    <small style="color:#999;"><%=rs3.getTimestamp("create_time")%></small>

                    <% if (userId != -1 && userId == commentUserId) { %>
                        <form action="delete_comment.jsp" method="post" style="display:inline; margin-left:10px;">
                            <input type="hidden" name="comment_id" value="<%=rs3.getInt("id")%>">
                            <input type="hidden" name="product_id" value="<%=id%>">
                            <button type="submit" style="color:red; background:none; border:none; cursor:pointer; padding:0;">[刪除]</button>
                        </form>
                    <% } %>
                </div>
        <%
            }

            if (!hasComment) {
                out.print("<p>目前沒有評價</p>");
            }

        } catch (Exception e) {
            out.print("<p style='color:red;'>留言載入失敗：" + e.getMessage() + "</p>");
        }
        %>
        </div>

        <div style="text-align:center; margin-top:20px;">
        <%
        for (int i = 1; i <= totalPage; i++) {
            if (i == currentPage) {
        %>
                <b style="margin: 0 5px; color: #000; font-size: 16px;"><%=i%></b>
        <%
            } else {
        %>
                <a href="product.jsp?id=<%=id%>&page=<%=i%>" style="margin: 0 5px; text-decoration: none; color: #666;"><%=i%></a>
        <%
            }
        }
        %>
        </div>
    </div>
</div>
</section>
</body>
</html>

<%-- ========================================== --%>
<%-- 3. 全頁資源關閉資源釋放                    --%>
<%-- ========================================== --%>
<%
    try { if (rs1 != null) rs1.close(); } catch (Exception e) {}
    try { if (rs2 != null) rs2.close(); } catch (Exception e) {}
    try { if (rs3 != null) rs3.close(); } catch (Exception e) {}
    try { if (ps1 != null) ps1.close(); } catch (Exception e) {}
    try { if (ps2 != null) ps2.close(); } catch (Exception e) {}
    try { if (ps3 != null) ps3.close(); } catch (Exception e) {}
    try { if (conn != null) conn.close(); } catch (Exception e) {}
%>
