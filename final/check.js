async function initCheckoutSummary() {
    try {
        // 1. 向後台獲取購物車商品資料
        const res = await fetch("getCartItems.jsp");
        if (!res.ok) {
            console.error("購物車後台連線失敗");
            return;
        }
        
        const cart = await res.json();
        let total = 0;
        
        // 2. 走訪購物車陣列算出總額
        if (Array.isArray(cart)) {
            cart.forEach(item => {
                if (item.quantity > 0) {
                    // 請確保後台傳過來的欄位名稱是 price 和 quantity
                    total += item.price * item.quantity;
                }
            });
        } else {
            console.warn("後台回傳的購物車格式不是 Array，無法計算金額。");
        }

        // 3. 計算活動折扣邏輯
        let discountRate = 1.0;
        let discountText = "NT$0"; // 預設無折扣顯示 NT$0
        
        if (total >= 1500) {
            discountRate = 0.88;
            discountText = "滿額 88 折";
        } else if (total >= 1000) {
            discountRate = 0.9;
            discountText = "滿額 9 折";
        }
        
        // 計算折抵後的最終金額（無條件捨去小數點）
        let finalTotal = Math.floor(total * discountRate);

        // 4. 安全地將計算結果渲染到 HTML 畫面上
        const subtotalEl = document.getElementById("subtotal-display");
        const shippingEl = document.getElementById("shipping-fee-display");
        const totalEl = document.getElementById("total-Amount");

        if (subtotalEl) subtotalEl.textContent = "NT$" + total.toLocaleString();
        if (shippingEl) shippingEl.textContent = discountText;
        if (totalEl) totalEl.textContent = "NT$" + finalTotal.toLocaleString();
        
    } catch (err) {
        console.error("計算金額時發生錯誤，請檢查 getCartItems.jsp 回傳格式是否正確:", err);
    }
}

/**
 * 監聽 DOM 載入事件，統一初始化金額並綁定表單送出邏輯
 */
document.addEventListener("DOMContentLoaded", () => {
    // 執行金額初始化
    initCheckoutSummary();

    const form = document.getElementById("checkoutForm");
    if (form) {
        form.onsubmit = async (e) => {
            e.preventDefault(); // 1. 徹底阻擋傳統的網址變長與重複疊加

            const submitBtn = document.getElementById("submitBtn");
            if (submitBtn) {
                submitBtn.disabled = true;
                submitBtn.innerText = "訂單處理中...";
            }

            try {
                // 2. 模擬傳統表單的 application/x-www-form-urlencoded 格式送出
                // 這能確保後端 request.getParameter() 100% 抓得到值
                const formData = new FormData(form);
                const searchParams = new URLSearchParams(formData);

                const res = await fetch("doCheckout.jsp", { 
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded"
                    },
                    body: searchParams.toString()
                });

                if (!res.ok) {
                    throw new Error("伺服器回應異常，狀態碼：" + res.status);
                }

                const result = await res.json();

                if (result.success) {
                    alert("🎉 訂單提交成功！感謝您的購買。");
                    // 3. 🌟 由前端 JS 來主導轉址到成功頁面，並帶上後端回傳的真實 MySQL 訂單 ID！
                    location.href = "checkout_success.jsp?order_id=" + result.order_id;
                } else {
                    alert("提交失敗：" + (result.msg || "未知錯誤"));
                    if (submitBtn) {
                        submitBtn.disabled = false;
                        submitBtn.innerText = "確認送出訂單";
                    }
                }
            } catch (error) {
                console.error("錯誤細節:", error);
                alert("系統連線錯誤，請確認 doCheckout.jsp 是否正常運行，且資料庫連線、欄位名稱正確！");
                if (submitBtn) {
                    submitBtn.disabled = false;
                    submitBtn.innerText = "確認送出訂單";
                }
            }
        };
    }
});