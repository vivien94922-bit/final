/**
 * 1. 主渲染函式：負責向後台拿資料並繪製購物車畫面
 */
async function renderCart() {
    try {
        const res = await fetch("getCartItems.jsp");
        if (!res.ok) {
            console.error("無法取得購物車資料");
            return;
        }

        const cart = await res.json();
        
        // 抓取你 HTML 上包住所有商品的那個外層容器
        // (請根據你的 HTML 實際 ID 調整，如果是 id="cart-container" 就用 cart-container)
        const container = document.getElementById("cart-container") || document.getElementById("container"); 
        if (!container) {
            console.error("找不到購物車的 HTML 容器");
            return;
        }

        // 🌟 核心修正：進迴圈前，先把容器清空，徹底終結重複疊加！
        container.innerHTML = ""; 

        // 判斷購物車是否有商品
        if (Array.isArray(cart) && cart.length > 0) {
            
            cart.forEach(item => {
                // 防呆：如果後台不小心傳回數量為 0 或負數的資料，前端直接跳過不渲染
                if (item.quantity <= 0) return;

                // 動態建立商品外殼 div
                const div = document.createElement("div");
                div.className = "cart-item";
                
                // 把後台資料綁在 dataset 中，方便加減按鈕抓取
                div.dataset.price = item.price;
                div.dataset.cartId = item.cart_id; // 請確保後台欄位叫 cart_id

                // 塞入商品的內層結構
                div.innerHTML = `
                    <img src="${item.image || 'images/default.jpg'}" width="150" style="height: auto; margin-right: 20px;">
                    <div class="item-info">
                        <h3>${item.name}</h3>
                        <p>單價：NT$${item.price}</p>
                        <div class="quantity-controls" style="display: flex; gap: 5px; align-items: center;">
                            <button class="decrease">-</button>
                            <input type="number" class="quantity" value="${item.quantity}" min="1" style="width: 40px; text-align: center;" readonly>
                            <button class="increase">+</button>
                            <button class="remove-btn" style="display: flex; justify-content: center; align-items: center; background-color: #333; color: #fff; margin-left: 10px; padding: 8px 16px; border: none; cursor: pointer; font-size: 18px; ">刪除</button>
                        </div>
                    </div>
                `;
                
                // 把這個做好的商品塞進大容器
                container.appendChild(div);
            });

            // 🌟 核心修正：等所有商品都生出來放到網頁上後，才去綁定按鈕事件與計算金額
            bindCartEvents();
            updateTotalFromDB(cart);

        } else {
            // 購物車沒東西時的顯示
            container.innerHTML = "<p style='text-align:center; padding: 40px; color: #666;'>購物車空空如也...</p>";
            updateTotalFromDB([]); // 金額歸零
        }

    } catch (error) {
        console.error("導覽購物車渲染失敗:", error);
    }
}

/**
 * 2. 計算並顯示總金額、運費折扣提示
 */
function updateTotalFromDB(cart) {
    let total = 0;
    cart.forEach(item => {
        if (item.quantity > 0) {
            total += item.price * item.quantity;
        }
    });

    // 渲染總金額
    const totalEl = document.getElementById("cart-total");
    if (totalEl) {
        totalEl.textContent = "NT$" + total.toLocaleString();
    }

    // 控制 discountHint 滿額提示與結帳按鈕
    const hintEl = document.getElementById("discountHint");
    const checkoutBtn = document.getElementById("checkoutBtn");

    if (hintEl) {
        if (total === 0) {
            hintEl.style.display = "none";
            if (checkoutBtn) checkoutBtn.disabled = true; // 購物車沒東西時不能結帳
        } else if (total < 2000) {
            let diff = 2000 - total;
            hintEl.style.display = "block";
            hintEl.innerHTML = `💡 還差 <b>NT$${diff.toLocaleString()}</b> 即可享有免運費優惠！(現正滿 NT$2,000 免運)`;
            if (checkoutBtn) checkoutBtn.disabled = false;
        } else {
            hintEl.style.display = "block";
            hintEl.innerHTML = `🎉 太棒了！已達成滿額免運費資格！`;
            if (checkoutBtn) checkoutBtn.disabled = false;
        }
    }
}

/**
 * 3. 幫網頁上剛生出來的按鈕綁定點擊事件
 */
function bindCartEvents() {
    // 加號按鈕
    document.querySelectorAll(".increase").forEach(btn => {
        btn.onclick = async () => {
            const item = btn.closest(".cart-item");
            const cartId = item.dataset.cartId;
            const input = item.querySelector(".quantity");
            const currentQty = parseInt(input.value);

            await sendUpdate(cartId, currentQty + 1);
        };
    });

    // 減號按鈕（減到 0 自動觸發刪除）
    document.querySelectorAll(".decrease").forEach(btn => {
        btn.onclick = async () => {
            const item = btn.closest(".cart-item");
            const cartId = item.dataset.cartId;
            const input = item.querySelector(".quantity");
            const currentQty = parseInt(input.value);

            if (currentQty <= 1) {
                if (confirm("確定要將此商品從購物車刪除嗎？")) {
                    await sendUpdate(cartId, 0); // 送出 0 代表刪除
                }
            } else {
                await sendUpdate(cartId, currentQty - 1);
            }
        };
    });

    // 獨立刪除按鈕
    document.querySelectorAll(".remove-btn").forEach(btn => {
        btn.onclick = async () => {
            if (confirm("確定刪除此商品？")) {
                const item = btn.closest(".cart-item");
                const cartId = item.dataset.cartId;
                await sendUpdate(cartId, 0); // 送出 0 代表刪除
            }
        };
    });
}

/**
 * 4. 統一發送修改數量 / 刪除請求給後台的函式
 */
async function sendUpdate(cartId, qty) {
    try {
        const res = await fetch("updateCartQty.jsp", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: `cart_id=${cartId}&quantity=${qty}`
        });

        if (!res.ok) {
            alert("操作失敗");
            return;
        }
        
        // 成功更新資料庫後，再度呼叫主渲染函數，重抓最新狀態
        await renderCart();
        
    } catch (err) {
        console.error("更新購物車失敗:", err);
    }
}

// 🌟 核心修正：全檔只保留這一個監聽器，確保開網頁時只執行一次 renderCart！
document.addEventListener("DOMContentLoaded", renderCart);
