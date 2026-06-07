# 組員D 安全與整合報告

負責範圍：資料庫設計、全站連線統一、SQL 隱碼注入防止、個資法/Cookie、密碼雜湊、整合測試。

---

## 1. 資料庫設計與統一（②）

- 原本連線分散於三個資料庫：`clothing_shop`（DBUtil 舊設定，且無人使用）、`counter`（計數器）、`shopdb`（商品/會員/留言）。
- 已**全部統一為單一資料庫 `shopdb`**（`utf8mb4`），結構與 ER 圖見 [`schema.sql`](schema.sql) 與 [`ERD.md`](ERD.md)。
- 連線改由 [`src/util/DBUtil.java`](../src/util/DBUtil.java) 集中管理，統一加上
  `useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Taipei`。
- 以下 JSP 的內嵌連線皆改為 `DBUtil.getConnection()`（讓原本「死掉」的 DBUtil 真正被使用）：
  `index.jsp`、`product.jsp`、`member.jsp`、`add.jsp`、`login_process.jsp`、`register_process.jsp`。

## 2. SQL 隱碼注入防止（基本功能 ⑦）

| 檔案 | 查詢 | 防護 |
|------|------|------|
| `login_process.jsp` | 依帳號查詢會員 | PreparedStatement `?` |
| `register_process.jsp` | 新增會員 | PreparedStatement `?` |
| `member.jsp` | 查詢會員資料 | PreparedStatement `?` |
| `product.jsp` | 查商品 / 留言數 / 留言列表（含分頁 LIMIT） | PreparedStatement `?` |
| `add.jsp` | 新增留言 | PreparedStatement `?` |
| `index.jsp` | 訪客計數器 | **已由 Statement 改為 PreparedStatement** |

→ 全站查詢皆為參數化查詢，無字串拼接，達成資料隱碼注入防止。

## 3. 密碼雜湊（加分，超重要）

- 工具：[`src/util/PasswordUtil.java`](../src/util/PasswordUtil.java)，採 **加鹽 SHA-256**（僅用 JDK 內建 `java.security`，免外部 jar）。
- `register_process.jsp`：註冊時產生隨機 `salt`，儲存 `SHA-256(salt + 密碼)` 至 `password`，並存 `salt`。
- `login_process.jsp`：以帳號取出 `salt` + `password`，用 `PasswordUtil.verify()` 比對，**不再比對明文**。
- 種子帳號（`schema.sql` 內已雜湊）：
  - `admin / admin1234`（role = admin）
  - `demo / demo1234`（role = user）

## 4. 個資法 / Cookie（延伸 6）

- [`cookie-consent.js`](../cookie-consent.js)：首次造訪顯示 Cookie 同意條，按「我同意」寫入 1 年期 cookie，並連結隱私權政策。
- [`privacy.html`](../privacy.html)：依《個人資料保護法》說明蒐集類別、目的、Cookie 使用、資料安全與當事人權利。
- 已於以下頁面引入同意條與頁尾「隱私權政策」連結：
  `index.jsp`、`member.jsp`、`product.jsp`、`cart.html`、`check.html`、`about.html`、`tops.html`、`bottoms.html`、`login.jsp`。

---

## 5. 整合測試檢查表

### 部署前提
- 將 `src/util/DBUtil.java`、`src/util/PasswordUtil.java` 編譯到 `WEB-INF/classes/util/`。
- `WEB-INF/lib` 放入 `mysql-connector-j`（JDBC 驅動）。
- 執行 `mysql -u root -p < db/schema.sql` 建立 `shopdb` 與種子資料。

### 測試項目
- [ ] 首頁訪客計數器數字會增加（資料來自 `shopdb.counter`）。
- [ ] 首次進站底部出現 Cookie 同意條；按「我同意」後消失，重整不再出現。
- [ ] 以 `demo / demo1234` 登入成功；錯誤密碼登入失敗。
- [ ] 註冊新帳號後，資料庫 `members.password` 為 64 字雜湊、`salt` 有值（非明文）。
- [ ] `product.jsp?id=1` ~ `15` 皆能顯示商品（種子 15 筆）。
- [ ] 商品留言依時間由新到舊排列（最新在最上）、可正常顯示中文。
- [ ] 頁尾「隱私權政策」可連到 `privacy.html`。

---

## 6. 已知缺口（屬其他組員範圍，整合時需補）

| 缺少檔案 / 功能 | 影響 | 負責 |
|----------------|------|------|
| `products.js` | 搜尋⑤無資料來源、無法運作 | 組員A |
| `check_login.jsp` | 首頁登入狀態列、加入購物車的登入判斷失效 | 組員C |
| `delete_comment.jsp` | 留言「刪除」按鈕 404（`add.jsp` 已補寫 `user_id` 供比對） | 組員C |
| `addToCart`（Servlet）| 商品詳細頁加入購物車 404、庫存②不會扣減 | 組員B |

> 備註：資料庫已預留 `product.stock`、`orders`、`order_items`、`members.role`，
> 組員B 可直接據此實作購買扣庫存、結帳建立訂單與管理者訂單瀏覽。
