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
            <div class="checkout-grid">
                
                <div class="left-column">
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
                </div>
    
                <div class="right-column">
                    <div class="summary-card">
                        <div class="summary-line">
                            <span>商品小計</span>
                            <span id="subtotal-display">NT$0</span> 
                        </div>
                        <div class="summary-line">
                            <span>運費</span>
                            <span id="shipping-fee-display">載入中...</span> 
                        </div>
                        <div class="divider"></div>
                        <div class="summary-line total">
                            <span>應付總計</span>
                            <span id="total-Amount">NT$0</span> 
                        </div>
                        <button type="submit" id="submitBtn" class="submit-btn" disabled>載入購物車中...</button>
                    </div>
                </div>
    
            </div> </form>
    </div>
    
    <script>
        // 你的 JavaScript 邏輯保持不變，它會自動抓取 ID 並更新內容
        document.addEventListener("DOMContentLoaded", function() {
            const subtotalEl = document.getElementById("subtotal-display");
            const shippingDisplay = document.getElementById("shipping-fee-display");
            const totalEl = document.getElementById("total-Amount");
            const submitBtn = document.getElementById("submitBtn");
            
            const FREE_SHIPPING_THRESHOLD = 1500;
            const SHIPPING_FEE = 100;
    
            function updateSummary(cart) {
                const subtotal = cart.reduce((sum, item) => {
                    const p = Number(item.price);
                    const q = Number(item.quantity);
                    return sum + (isNaN(p) || isNaN(q) ? 0 : p * q);
                }, 0);
    
                const isFreeShipping = subtotal >= FREE_SHIPPING_THRESHOLD;
                const shippingCost = isFreeShipping ? 0 : SHIPPING_FEE;
                const totalAmount = subtotal + shippingCost;
    
                subtotalEl.innerText = "NT$" + subtotal.toLocaleString();
                
                if (isFreeShipping) {
                    shippingDisplay.innerText = "免運費";
                    shippingDisplay.style.color = "#27ae60";
                } else {
                    const diff = FREE_SHIPPING_THRESHOLD - subtotal;
                    shippingDisplay.innerHTML = 'NT$' + SHIPPING_FEE + ' (再買 <b>NT$' + Math.max(0, diff).toLocaleString() + '</b> 可享免運)';
                    shippingDisplay.style.color = "#e74c3c";
                }
    
                totalEl.innerText = "NT$" + totalAmount.toLocaleString();
                submitBtn.disabled = subtotal <= 0;
                submitBtn.innerText = subtotal > 0 ? "確認送出訂單" : "購物車沒有商品";
            }
    
            fetch("getCartItems.jsp", { cache: "no-store" })
                .then(res => res.ok ? res.json() : Promise.reject())
                .then(cart => {
                    if (Array.isArray(cart) && cart.length > 0) {
                        updateSummary(cart);
                    } else {
                        submitBtn.innerText = "購物車是空的";
                    }
                })
                .catch(() => {
                    submitBtn.innerText = "無法載入購物車";
                });
    
            document.getElementById("checkoutForm").addEventListener("submit", function(e) {
                e.preventDefault();
                submitBtn.disabled = true;
                submitBtn.innerText = "訂單處理中...";
    
                fetch('doCheckout.jsp', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
                    body: new URLSearchParams(new FormData(this)).toString()
                })
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        location.href = 'checkout_success.jsp?order_id=' + encodeURIComponent(data.order_id);
                    } else {
                        alert("感謝您的購買！！");
                        submitBtn.disabled = false;
                        submitBtn.innerText = "確認送出訂單";
                    }
                });
            });
        });
    </script>
    </body>

<script>
document.addEventListener("DOMContentLoaded", function() {
    const subtotalEl = document.getElementById("subtotal-display");
    const shippingDisplay = document.getElementById("shipping-fee-display");
    const totalEl = document.getElementById("total-Amount");
    const submitBtn = document.getElementById("submitBtn");
    
    const FREE_SHIPPING_THRESHOLD = 2000;
    const SHIPPING_FEE = 100;

    function updateSummary(cart) {
        // 強制轉換確保數值運算正確
        const subtotal = cart.reduce((sum, item) => {
            const p = Number(item.price);
            const q = Number(item.quantity);
            return sum + (isNaN(p) || isNaN(q) ? 0 : p * q);
        }, 0);

        const isFreeShipping = subtotal >= FREE_SHIPPING_THRESHOLD;
        const shippingCost = isFreeShipping ? 0 : SHIPPING_FEE;
        const totalAmount = subtotal + shippingCost;

        // 更新 UI
        subtotalEl.innerText = "NT$" + subtotal.toLocaleString();
        
        if (isFreeShipping) {
            shippingDisplay.innerText = "免運費";
            shippingDisplay.style.color = "#27ae60";
        } else {
            const diff = FREE_SHIPPING_THRESHOLD - subtotal;
            // 偵錯用：若出現 NaN，請檢查 F12 Console
            console.log("計算差距:", diff); 
            
            shippingDisplay.innerHTML = 'NT$' + SHIPPING_FEE + ' (再買 <b>NT$' + Math.max(0, diff).toLocaleString() + '</b> 可享免運)';
            shippingDisplay.style.color = "#e74c3c";
        }

        totalEl.innerText = "NT$" + totalAmount.toLocaleString();
        submitBtn.disabled = subtotal <= 0;
        submitBtn.innerText = subtotal > 0 ? "確認送出訂單" : "購物車沒有商品";
    }

    // 初始化請求
    fetch("getCartItems.jsp", { cache: "no-store" })
        .then(res => res.ok ? res.json() : Promise.reject())
        .then(cart => {
            if (Array.isArray(cart) && cart.length > 0) {
                updateSummary(cart);
            } else {
                shippingDisplay.innerText = "尚未選購商品";
                submitBtn.innerText = "購物車是空的";
            }
        })
        .catch(err => {
            console.error("購物車載入錯誤:", err);
            shippingDisplay.innerText = "無法讀取";
            submitBtn.innerText = "無法載入購物車";
        });

    // 表單提交
    document.getElementById("checkoutForm").addEventListener("submit", function(e) {
        e.preventDefault();
        submitBtn.disabled = true;
        submitBtn.innerText = "訂單處理中...";

        fetch('doCheckout.jsp', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
            body: new URLSearchParams(new FormData(this)).toString()
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                location.href = 'checkout_success.jsp?order_id=' + encodeURIComponent(data.order_id);
            } else {
                alert("結帳失敗：" + (data.msg || "系統錯誤"));
                submitBtn.disabled = false;
                submitBtn.innerText = "確認送出訂單";
            }
        })
        .catch(() => {
            alert("網路連線錯誤");
            submitBtn.disabled = false;
            submitBtn.innerText = "確認送出訂單";
        });
    });
});
</script>
</html>