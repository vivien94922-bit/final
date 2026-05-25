function renderCart() {
    const cart = JSON.parse(localStorage.getItem("cart")) || {};
    const container = document.body; // cart-item 原本就直接在 body 底下
  
    
    document.querySelectorAll(".cart-item").forEach(item => item.remove());
  
    Object.values(cart).forEach(item => {
      const div = document.createElement("div");
      div.className = "cart-item";
      div.dataset.price = item.price;
  
      div.innerHTML = `
        <img src="${item.img}" alt="${item.name}">
        <div class="item-info">
          <p>${item.name}</p>
          <p>單價：NT$${item.price.toLocaleString()}</p>
          <div class="quantity-controls">
            <button class="decrease">-</button>
            <input type="number" class="quantity" value="${item.quantity}" min="0">
            <button class="increase">+</button>
            <button class="remove-btn">刪除</button>
          </div>
        </div>
      `;
  
      // 插在總計前面
      document.querySelector(".total").before(div);
    });
  
    bindCartEvents();
    updateTotal();
  }
  
  function updateTotal() {
    let total = 0;
    document.querySelectorAll(".cart-item").forEach(item => {
      const price = parseInt(item.dataset.price);
      const qty = parseInt(item.querySelector(".quantity").value) || 0;
      total += price * qty;
    });
    document.getElementById("totalAmount").textContent = total.toLocaleString();
  }
  
  function bindCartEvents() {
    document.querySelectorAll(".increase").forEach(btn => {
      btn.onclick = () => {
        const input = btn.parentElement.querySelector(".quantity");
        input.value++;
        saveCart();
      };
    });
  
    document.querySelectorAll(".decrease").forEach(btn => {
      btn.onclick = () => {
        const input = btn.parentElement.querySelector(".quantity");
        if (input.value > 0) input.value--;
        saveCart();
      };
    });
  
    document.querySelectorAll(".remove-btn").forEach(btn => {
      btn.onclick = () => {
        btn.closest(".cart-item").remove();
        saveCart();
      };
    });
  }
  
  function saveCart() {
    const cart = {};
    document.querySelectorAll(".cart-item").forEach(item => {
      const name = item.querySelector("p").innerText;
      const price = parseInt(item.dataset.price);
      const img = item.querySelector("img").src;
      const qty = parseInt(item.querySelector(".quantity").value);
  
      if (qty > 0) {
        cart[name] = { name, price, img, quantity: qty };
      }
    });
  
    localStorage.setItem("cart", JSON.stringify(cart));
    updateTotal();
  }
  
  document.getElementById("checkoutBtn").addEventListener("click", () => {
    const total = document.getElementById("totalAmount").textContent;
    if (total === "0") {
      alert("您的購物車目前是空的喔！");
    } else {
      window.location.href = "check.html";
    }
  });
  document.addEventListener("DOMContentLoaded", renderCart);
  
