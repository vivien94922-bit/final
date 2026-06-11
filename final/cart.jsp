<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-Hant">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>購物車</title>
    <link rel="stylesheet" href="cart.css">
    <link rel="stylesheet" href="style.css">
    <script src="products.js"></script>
    <script src="script.js"></script>
</head>
<body>

    <header>
      <div class="nav-left">
        <a href="index.jsp" class="logo">STANDARD DAY</a>
      </div>
      <div class="nav-icons">
        <div class="search-wrapper">
          <img src="../images/search.png" alt="Search" id="searchIcon">
          <div class="search-box" id="searchBox">
            <div class="search-input">
                <img src="../images/search.png" alt="">
                <input type="text" id="searchInput" placeholder="搜尋商品...">
                <div class="search-result" id="searchResult"></div>
            </div>
          </div>
        </div>
        <div class="menu-wrapper">
          <img src="../images/clothes.png" alt="Browse" id="menuIcon">
           <div class="menu-box" id="menuBox">
                <a href="tops.html" class="menu-item">
                  <img src="../images/tops.png" alt="Tops">
                </a>
                <a href="bottoms.html" class="menu-item">
                  <img src="../images/bottoms.png" alt="Bottoms">
                </a>
          </div>
        </div>
        <a href="about.html" title="關於我們">
          <img src="../images/info.png" alt="About">
        </a>
        <a href="member.jsp" title="會員中心">
          <img src="../images/user.png" alt="Member">
        </a>
        <a href="cart.jsp" title="購物車">
          <img src="../images/shopping_cart.png" alt="Cart">
        </a>
      </div>
    </header>

    <nav class="breadcrumb">
        <a href="index.jsp">首頁</a> &gt; <span>購物車</span>
    </nav>

    <!-- 購物車商品動態載入區 -->
    <div id="cart-container"></div>

    <div id="discountHint" class="discount-hint"></div>
    <div class="total">
        總計：NT$<span id="totalAmount">0</span>
    </div>
    <div class="checkout-container">
        <button id="checkoutBtn" class="checkout-btn">前往結帳</button>
    </div>

    <script>
    // =============================================
    // 從資料庫讀取購物車並渲染
    // =============================================
    async function loadCart() {
        try {
            const res = await fetch('getCartItems.jsp');

            // 未登入 → 導向登入頁
            if (res.status === 401) {
                alert('請先登入');
                location.href = 'login.jsp';
                return;
            }

            const items = await res.json();
            const container = document.getElementById('cart-container');
            container.innerHTML = '';

            if (items.length === 0) {
                container.innerHTML = '<p style="text-align:center;padding:40px;">購物車是空的</p>';
                updateTotal([]);
                return;
            }

            items.forEach(item => {
                const div = document.createElement('div');
                div.className = 'cart-item';
                div.dataset.price   = item.price;
                div.dataset.cartId  = item.cart_id;
                div.innerHTML = `
                    <img src="${item.image}" alt="${item.name}">
                    <div class="item-info">
                        <p>${item.name}</p>
                        <p>單價：NT$${item.price.toLocaleString()}</p>
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

            bindEvents();
            updateTotal();
        } catch (e) {
            console.error(e);
        }
    }

    // =============================================
    // 更新數量（呼叫後端）
    // =============================================
    async function updateQty(cartId, qty) {
        await fetch('updateCartQty.jsp', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: `cart_id=${cartId}&quantity=${qty}`
        });
        updateTotal();
    }

    // =============================================
    // 刪除品項（呼叫後端）
    // =============================================
    async function removeItem(cartId, itemDiv) {
        const res = await fetch('removeCartItem.jsp', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: `cart_id=${cartId}`
        });
        const data = await res.json();
        if (data.success) {
            itemDiv.remove();
            updateTotal();
        }
    }

    // =============================================
    // 計算總計 + 折扣提示
    // =============================================
    function updateTotal() {
        let total = 0;
        document.querySelectorAll('.cart-item').forEach(item => {
            const price = parseInt(item.dataset.price);
            const qty   = parseInt(item.querySelector('.quantity').value) || 0;
            total += price * qty;
        });

        const hint = document.getElementById('discountHint');
        let discountRate = 1;
        let message = '';

        if (total >= 1500) {
            discountRate = 0.88;
            message = '已享 88 折優惠（最高折扣）';
        } else if (total >= 1000) {
            discountRate = 0.9;
            message = '已享 9 折優惠，再買 NT$' + (1500 - total) + ' 可升級 88 折';
        } else {
            message = '再買 NT$' + (1000 - total) + ' 享 9 折，再買 NT$' + (1500 - total) + ' 享 88 折';
        }

        const finalTotal = Math.floor(total * discountRate);
        document.getElementById('totalAmount').textContent = finalTotal.toLocaleString();
        hint.textContent = message;
    }

    // =============================================
    // 綁定按鈕事件
    // =============================================
    function bindEvents() {
        document.querySelectorAll('.increase').forEach(btn => {
            btn.onclick = () => {
                const input  = btn.parentElement.querySelector('.quantity');
                const cartId = btn.closest('.cart-item').dataset.cartId;
                input.value  = parseInt(input.value) + 1;
                updateQty(cartId, input.value);
            };
        });

        document.querySelectorAll('.decrease').forEach(btn => {
            btn.onclick = () => {
                const input  = btn.parentElement.querySelector('.quantity');
                const cartId = btn.closest('.cart-item').dataset.cartId;
                if (parseInt(input.value) > 1) {
                    input.value = parseInt(input.value) - 1;
                    updateQty(cartId, input.value);
                }
            };
        });

        document.querySelectorAll('.remove-btn').forEach(btn => {
            btn.onclick = () => {
                const itemDiv = btn.closest('.cart-item');
                const cartId  = itemDiv.dataset.cartId;
                removeItem(cartId, itemDiv);
            };
        });
    }

    // =============================================
    // 結帳按鈕
    // =============================================
    document.getElementById('checkoutBtn').addEventListener('click', async () => {
        const total = document.getElementById('totalAmount').textContent.replace(/,/g, '');
        if (total === '0') {
            alert('您的購物車目前是空的喔！');
            return;
        }
        const res  = await fetch('checkout.jsp', { method: 'POST' });
        const data = await res.json();
        if (data.success) {
            location.href = 'orderSuccess.jsp?order_id=' + data.order_id + '&total=' + data.total;
        } else {
            alert(data.msg);
        }
    });

    // 頁面載入時讀取購物車
    document.addEventListener('DOMContentLoaded', loadCart);
    </script>

    <script src="cookie-consent.js" defer></script>
</body>
</html>
