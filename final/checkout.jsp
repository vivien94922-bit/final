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

        <button type="submit" id="submitBtn" class="submit-btn" disabled>載入購物車中...</button>
    </form>
</div>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            const subtotalEl = document.getElementById("subtotal-display");
            const totalEl = document.getElementById("total-Amount");
            const submitBtn = document.getElementById("submitBtn");

            // Display an estimate from the current server-side cart. The backend
            // calculates and validates the authoritative total again at checkout.
            fetch("getCartItems.jsp", { cache: "no-store" })
                .then(res => {
                    if (res.status === 401) {
                        location.href = "login.jsp";
                        return null;
                    }
                    if (!res.ok) throw new Error("無法取得購物車");
                    return res.json();
                })
                .then(cart => {
                    if (cart === null) return;
                    const total = cart.reduce((sum, item) => {
                        const price = Number(item.price);
                        const quantity = Number(item.quantity);
                        return sum + (price > 0 && quantity > 0 ? price * quantity : 0);
                    }, 0);

                    subtotalEl.innerText = "NT$" + total.toLocaleString();
                    totalEl.innerText = "NT$" + total.toLocaleString();
                    submitBtn.disabled = total <= 0;
                    submitBtn.innerText = total > 0 ? "確認送出訂單" : "購物車沒有商品";
                })
                .catch(() => {
                    submitBtn.disabled = true;
                    submitBtn.innerText = "無法載入購物車";
                });

            const form = document.getElementById("checkoutForm");
            if (form) {
                form.addEventListener("submit", function(e) {
                    e.preventDefault();

                    submitBtn.disabled = true;
                    submitBtn.innerText = "訂單處理中...";

                    const params = new URLSearchParams();
                    params.append('recipient_name', document.getElementById('recipient_name').value);
                    params.append('recipient_phone', document.getElementById('recipient_phone').value);
                    params.append('recipient_address', document.getElementById('recipient_address').value);
                    const selectedPayment = document.querySelector('input[name="payment"]:checked').value;
                    params.append('payment', selectedPayment);

                    fetch('doCheckout.jsp', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
                        },
                        body: params.toString()
                    })
                    .then(async res => {
                        const data = await res.json();
                        if (!res.ok && !data.msg) throw new Error("網路回應失敗");
                        return data;
                    })
                    .then(data => {
                        if (data.success) {
                            location.href = 'checkout_success.jsp?order_id='
                                + encodeURIComponent(data.order_id);
                        } else {
                            alert("結帳失敗：" + data.msg);
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
