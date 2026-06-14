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
                <span id="shipping-fee-display">免運費</span> 
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

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            // 1. 從網址抓取購物車傳過來的 amount 金額
            const urlParams = new URLSearchParams(window.location.search);
            const amount = urlParams.get('amount') || "0";
            
            // 2. 將金額動態渲染到畫面上的「商品小計」與「應付總計」
            const subtotalEl = document.getElementById("subtotal-display");
            const totalEl = document.getElementById("total-Amount");
            
            if (subtotalEl) subtotalEl.innerText = "NT$" + parseInt(amount).toLocaleString();
            if (totalEl) totalEl.innerText = "NT$" + parseInt(amount).toLocaleString();

            // 3. 監聽表單送出事件
            const form = document.getElementById("checkoutForm");
            if (form) {
                form.addEventListener("submit", function(e) {
                    e.preventDefault(); // 阻擋表單預設跳轉，改用 fetch 非同步送出

                    const submitBtn = document.getElementById("submitBtn");
                    submitBtn.disabled = true;
                    submitBtn.innerText = "訂單處理中...";

                    // 4. 打包要傳送給 doCheckout.jsp 的資料
                    const params = new URLSearchParams();
                    params.append('recipient_name', document.getElementById('recipient_name').value);
                    params.append('recipient_phone', document.getElementById('recipient_phone').value);
                    params.append('recipient_address', document.getElementById('recipient_address').value);
                    
                    // 抓取被選中的付款方式 radio 值
                    const selectedPayment = document.querySelector('input[name="payment"]:checked').value;
                    params.append('payment', selectedPayment);

                    // 🌟 關鍵：將網址取得的真正金額塞進參數中送往後台
                    params.append('total_amount', amount);

                    // 5. 發送請求給後端做資料庫處理
                    fetch('doCheckout.jsp', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
                        },
                        body: params.toString()
                    })
                    .then(res => {
                        if (!res.ok) throw new Error("網路回應失敗");
                        return res.json();
                    })
                    .then(data => {
                        if (data.success) {
                            // 結帳成功，直接跳轉到成功感謝頁面
                            location.href = 'checkout_success.jsp';
                        } else {
                            alert("❌ 結帳失敗：" + data.msg);
                            submitBtn.disabled = false;
                            submitBtn.innerText = "確認送出訂單";
                        }
                    })
                    .catch(err => {
                        console.error("Error:", err);
                        alert("系統發生錯誤，請稍後再試！");
                        submitBtn.disabled = false;
                        submitBtn.innerText = "確認送出訂單";
                    });
                });
            }
        });
    </script>

    <script src="cookie-consent.js" defer></script>
</body>
</html>