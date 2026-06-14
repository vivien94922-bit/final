<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-Hant">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>購物車｜STANDARD DAY</title>
    <link rel="stylesheet" href="cart.css">
    <link rel="stylesheet" href="style.css">
    <script src="script.js"></script>
    
    <style>
        /* ===== 購物車按鈕與區塊美化 ===== */
        .total {
            max-width: 1000px;
            margin: 30px auto 15px auto;
            text-align: right;
            font-size: 18px;
            letter-spacing: 1px;
            color: #555;
            font-family: Arial, sans-serif;
        }

        #cart-total {
            font-size: 24px;
            font-weight: 600;
            color: #000;
            margin-left: 8px;
        }

        .checkout-container {
            max-width: 1000px;
            margin: 0 auto 50px auto;
            text-align: right;
        }

        .checkout-btn {
            background: #000;
            color: #fff;
            border: 1px solid #000;
            padding: 14px 45px;
            font-size: 15px;
            font-weight: 500;
            letter-spacing: 2px;
            border-radius: 4px; /* 內斂的微圓角 */
            cursor: pointer;
            transition: all 0.4s ease;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        }

        .checkout-btn:hover {
            background: #fff;
            color: #000;
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.1);
        }

        .checkout-btn:active {
            transform: translateY(-1px);
        }

        .checkout-btn:disabled {
            background: #e0e0e0;
            border-color: #e0e0e0;
            color: #999;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }

        /* 滿額提示美化 */
        .discount-hint {
            max-width: 1000px;
            margin: 20px auto;
            padding: 14px 20px;
            background: #f8f9fa;
            border-left: 3px solid #000;
            font-size: 13px;
            color: #666;
            letter-spacing: 0.5px;
            text-align: left;
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>
    
    <nav class="breadcrumb">
        <a href="index.jsp">首頁</a> &gt; <span>購物車</span>
    </nav>

    <div id="cart-container"></div>

    <div id="discountHint" class="discount-hint"></div>
    
    <div class="total">
        總計：<span id="cart-total">NT$0</span>
    </div>
    
    <div class="checkout-container">
        <button id="checkoutBtn" class="checkout-btn" onclick="handleCheckout()">前往結帳</button>
    </div>

    <script>
        function handleCheckout() {
            const btn = document.getElementById('checkoutBtn');
            btn.disabled = true;
            btn.innerText = '處理中...';
            const totalText = document.getElementById('cart-total').innerText; 
            const pureTotalNumber = totalText.replace(/[^0-9]/g, ''); // 濾掉 "NT$" 變成純數字字串
            // 延遲一下下再跳轉，做出高階電商的轉場感
            setTimeout(() => {
                location.href = 'checkout.jsp?amount=' + pureTotalNumber;
            }, 400);
        }
    </script>

    <script src="cart.js"></script>
    <script src="cookie-consent.js" defer></script>
</body>
</html>