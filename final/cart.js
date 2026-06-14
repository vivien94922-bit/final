async function renderCart() {
    const res = await fetch("getCartItems.jsp");
    if (!res.ok) {
        console.log("HTTP ERROR:", res.status);
        return;
    }
    const cart = await res.json();
    console.log("cart from DB:", cart);

    const container = document.getElementById("cart-container");
    container.innerHTML = "";

    if (!cart || cart.length === 0) {
        container.innerHTML = "<p style='text-align:center; padding: 40px; color:#666;'>購物車是空的</p>";
        updateTotalFromDB([]);
        return;
    }

    cart.forEach(item => {
        // 防呆：如果後台不小心傳回數量為 0 的資料，前端直接跳過不渲染
        if (item.quantity <= 0) return;

        const div = document.createElement("div");
        div.className = "cart-item";
        div.dataset.price = item.price;
        div.dataset.cartId = item.cart_id;

        div.innerHTML = `
            <img src="${item.image}" width="80">
            <div class="item-info">
                <p>${item.name}</p>
                <p>單價：NT$${item.price}</p>
                <div class="quantity-controls">
                    <button class="decrease">-</button>
                    <input type="number" class="quantity" value="${item.quantity}" min="1" readonly>
                    <button class="increase">+</button>
                    <button class="remove-btn">刪除</button>
                </div>
            </div>
        `;
        container.appendChild(div);
    });

    bindCartEvents();
    updateTotalFromDB(cart);
}

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

    // 👉 新增：控制 discountHint 滿額提示
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

function bindCartEvents() {
    // 1. 加號按鈕
    document.querySelectorAll(".increase").forEach(btn => {
        btn.onclick = async () => {
            const item = btn.closest(".cart-item");
            const cartId = item.dataset.cartId;
            const input = item.querySelector(".quantity");
            const currentQty = parseInt(input.value);

            await sendUpdate(cartId, currentQty + 1);
        };
    });

    // 2. 減號按鈕（減到 0 自動觸發刪除）
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

    // 3. 獨立刪除按鈕
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

// 封閉一個統一發送請求的 function，避免重複程式碼
async function sendUpdate(cartId, qty) {
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
    // 重新渲染，這時候會去 getCartItems.jsp 重新撈取最新的購物車資料
    await renderCart();
}

document.addEventListener("DOMContentLoaded", renderCart);