document.addEventListener("click", async (e) => {
    if (!e.target.classList.contains("add-cart-btn")) return;

    const p = e.target.closest(".product");
    const id = p.dataset.id;

    const res = await fetch("addToCart.jsp", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        body: `product_id=${id}&quantity=1`
    });

    const data = await res.json();

    if (res.status === 401) {
        alert("請先登入");
        location.href = "login.jsp";
        return;
    }

    alert(data.msg);
});