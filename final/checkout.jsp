<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>結帳付款｜STANDARD DAY</title>
    <link rel="stylesheet" href="check.css">
    <link rel="stylesheet" href="style.css">
</head>
<body>

<div class="checkout-container">
    <h2 class="main-title">結帳付款</h2>
    
    <form id="checkoutForm">
        <div class="section">
            <h3 class="section-title">收件人資訊</h3>
            <div class="form-group">
                <div class="input-wrapper">
                    <span class="label-text">姓名</span>
                    <input type="text" id="recipient_name" name="recipient_name" placeholder="請輸入完整姓名" required>
                </div>
            </div>
            <div class="form-group">
                <div class="input-wrapper">
                    <span class="label-text">電話</span>
                    <input type="tel" id="recipient_phone" name="recipient_phone" placeholder="請輸入電話號碼" required>
                </div>
            </div>
            <div class="form-group">
                <div class="input-wrapper">
                    <span class="label-text">地址</span>
                    <input type="text" id="recipient_address" name="recipient_address" placeholder="請輸入完整地址" required>
                </div>
            </div>
        </div>

        <div class="section">
            <h3 class="section-title">付款方式</h3>
            <div class="payment-options">
                <label class="payment-item">
                    <input type="radio" name="payment" value="credit" checked>
                    <span class="radio-custom"></span>
                    <span class="payment-label">信用卡 (線上支付)</span>
                </label>
                <label class="payment-item">
                    <input type="radio" name="payment" value="linepay">
                    <span class="radio-custom"></span>
                    <span class="payment-label line-pay-text">LINE Pay</span>
                </label>
                <label class="payment-item">
                    <input type="radio" name="payment" value="cod">
                    <span class="radio-custom"></span>
                    <span class="payment-label">超商取貨付款</span>
                </label>
            </div>
        </div>

        <div class="summary">
            <div class="summary-line">
                <span>商品小計</span>
                <span id="subtotal-display">NT$0</span> 
            </div>
            <div class="summary-line">
                <span>運費 / 折扣提示</span>
                <span id="shipping-fee-display">計算中...</span> 
            </div>
            <div class="divider"></div>
            <div class="summary-line total">
                <span>應付總計</span>
                <span id="total-Amount">NT$0</span> 
            </div>
        </div>

        <button type="submit" id="submitBtn" class="submit-btn">確認送出訂單</button>
    </form>
</div>

    <script src="check.js"></script>
    <script src="cookie-consent.js" defer></script>
</body>
</html>