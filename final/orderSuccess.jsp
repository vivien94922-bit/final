<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-Hant">
<head>
    <meta charset="UTF-8">
    <title>結帳成功</title>
    <link rel="stylesheet" href="style.css">
    <style>
        .success-box {
            max-width: 500px;
            margin: 80px auto;
            text-align: center;
            padding: 40px;
            border: 1px solid #ddd;
            border-radius: 12px;
        }
        .success-box h2 { color: #4caf50; margin-bottom: 16px; }
        .success-box p  { font-size: 16px; margin: 8px 0; }
        .success-box a  {
            display: inline-block;
            margin-top: 24px;
            padding: 12px 32px;
            background: #333;
            color: #fff;
            border-radius: 6px;
            text-decoration: none;
        }
        .success-box a:hover { background: #555; }
    </style>
</head>
<body>
    <div class="success-box">
        <h2>✅ 訂單成立！</h2>
        <p id="orderIdText"></p>
        <p id="totalText"></p>
        <p>感謝您的購買，我們將盡快為您處理。</p>
        <a href="index.jsp">繼續購物</a>
    </div>
    <script>
        const params = new URLSearchParams(location.search);
        const orderId = params.get('order_id');
        const total   = params.get('total');
        if (orderId) document.getElementById('orderIdText').textContent = '訂單編號：' + orderId;
        if (total)   document.getElementById('totalText').textContent   = '實付金額：NT$' + parseInt(total).toLocaleString();
    </script>
    <script src="cookie-consent.js" defer></script>
</body>
</html>
