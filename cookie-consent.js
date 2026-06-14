/* =============================================================
 * Cookie 同意提示（組員D：個資法 / Cookie 告知，延伸功能 6）
 * -------------------------------------------------------------
 * 首次造訪且尚未同意時，於畫面底部顯示同意條，
 * 按下「我同意」後寫入 cookie（有效 1 年），下次不再顯示。
 * 自帶樣式，頁面只需引入這一支 <script> 即可。
 * ============================================================= */
(function () {
  "use strict";

  // 已同意就不顯示
  if (document.cookie.indexOf("cookie_consent=yes") !== -1) return;

  function setConsentCookie() {
    var oneYear = 365 * 24 * 60 * 60; // 秒
    document.cookie =
      "cookie_consent=yes; max-age=" + oneYear + "; path=/; SameSite=Lax";
  }

  function injectStyle() {
    var css =
      "#cookie-consent-bar{position:fixed;left:0;right:0;bottom:0;z-index:99999;" +
      "background:#1c1c1c;color:#fff;padding:16px 20px;display:flex;flex-wrap:wrap;" +
      "align-items:center;justify-content:center;gap:14px;" +
      "font-family:'Noto Sans TC','Microsoft JhengHei',Arial,sans-serif;font-size:14px;" +
      "box-shadow:0 -2px 10px rgba(0,0,0,.3);}" +
      "#cookie-consent-bar p{margin:0;line-height:1.6;max-width:760px;}" +
      "#cookie-consent-bar a{color:#ffd28a;text-decoration:underline;}" +
      "#cookie-consent-bar button{background:#fff;color:#1c1c1c;border:none;" +
      "border-radius:999px;padding:10px 22px;font-size:14px;font-weight:bold;" +
      "cursor:pointer;white-space:nowrap;}" +
      "#cookie-consent-bar button:hover{background:#ddd;}";
    var style = document.createElement("style");
    style.textContent = css;
    document.head.appendChild(style);
  }

  function showBar() {
    injectStyle();

    var bar = document.createElement("div");
    bar.id = "cookie-consent-bar";
    bar.innerHTML =
      "<p>本網站依《個人資料保護法》蒐集並使用您的個人資料，" +
      "並使用 Cookie 以維持登入狀態、購物車與改善瀏覽體驗。" +
      "繼續使用即表示您同意，詳情請見 " +
      '<a href="privacy.html">隱私權政策</a>。</p>' +
      '<button type="button" id="cookie-accept-btn">我同意</button>';
    document.body.appendChild(bar);

    document
      .getElementById("cookie-accept-btn")
      .addEventListener("click", function () {
        setConsentCookie();
        bar.remove();
      });
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", showBar);
  } else {
    showBar();
  }
})();
