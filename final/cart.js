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
        container.innerHTML = "<p>購物車是空的</p>";
        updateTotalFromDB([]);
        return;
    }

    cart.forEach(item => {
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
                    <input type="number" class="quantity" value="${item.quantity}" min="1">
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
function updateTotalFromDB(cart){
    let total = 0;
    cart.forEach(item => {
        total += item.price * item.quantity;
    });
    document.getElementById("cart-total")
            .textContent =
            "NT$" + total.toLocaleString();
}

function bindCartEvents() {

    document.querySelectorAll(".increase").forEach(btn => {
        btn.onclick = async () => {
            const item = btn.closest(".cart-item");
            const cartId = item.dataset.cartId;
            const input = item.querySelector(".quantity");

            input.value = parseInt(input.value) + 1;

            const res = await fetch("updateCartQty.jsp", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: `cart_id=${cartId}&quantity=${input.value}`
            });
            
            if(!res.ok){
                alert("更新失敗");
                return;
            }
            
            await renderCart();
        };
    });

    document.querySelectorAll(".decrease").forEach(btn => {
        btn.onclick = async () => {
            const item = btn.closest(".cart-item");
            const cartId = item.dataset.cartId;
            const input = item.querySelector(".quantity");

           let qty = parseInt(input.value) - 1;
           if(qty < 1){
                 if(confirm("確定刪除此商品？")){
                    qty = 0;
                    }else{
                        return;
                    }
                }
            await fetch("updateCartQty.jsp", {
                method: "POST",
                headers: {"Content-Type":"application/x-www-form-urlencoded"},
                body: `cart_id=${cartId}&quantity=${qty}`
            });

            await renderCart();
        };
    });

    document.querySelectorAll(".remove-btn").forEach(btn => {
        btn.onclick = async () => {
            const item = btn.closest(".cart-item");
            const cartId = item.dataset.cartId;

            await fetch("updateCartQty.jsp", {
                method: "POST",
                headers: {"Content-Type":"application/x-www-form-urlencoded"},
                body: `cart_id=${cartId}&quantity=0`
            });

            await renderCart();
        };
    });
}
document.addEventListener(
    "DOMContentLoaded",
    renderCart
);
