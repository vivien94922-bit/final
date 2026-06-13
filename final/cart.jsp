<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-Hant">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>購物車</title>
    <link rel="stylesheet" href="cart.css">
    <link rel="stylesheet" href="style.css">
    <script src="script.js"></script>
</head>
<body>
    <%@ include file="header.jsp" %>
    <nav class="breadcrumb">
        <a href="index.jsp">首頁</a> &gt; <span>購物車</span>
    </nav>

    <!-- 購物車商品動態載入區 -->
    <div id="cart-container"></div>

    <div id="discountHint" class="discount-hint"></div>
    <div class="total">
        總計：<span id="cart-total">NT$0</span>
    </div>
    <div class="checkout-container">
        <button id="checkoutBtn" class="checkout-btn">前往結帳</button>
    </div>


    <script src="cart.js"></script>
    <script src="cookie-consent.js" defer></script>
</body>
</html>
