# STANDARD DAY 資料庫設計（ERD）

統一資料庫：**`shopdb`**（`utf8mb4` / `utf8mb4_unicode_ci`，支援中文）
建表與種子資料請見 [`schema.sql`](schema.sql)。

## ER 圖

```mermaid
erDiagram
    members ||--o{ orders          : "下訂單"
    members ||--o{ product_comment : "發表留言"
    product ||--o{ product_comment : "被留言"
    product ||--o{ order_items     : "被購買"
    orders  ||--o{ order_items     : "包含明細"

    members {
        int id PK
        varchar username UK
        varchar password "SHA-256 雜湊"
        varchar salt "每人獨立鹽值"
        varchar name
        varchar email
        varchar phone
        varchar role "user / admin"
        timestamp created_at
    }

    product {
        int id PK
        varchar name
        int price
        varchar image
        text description
        varchar category "tops / bottoms"
        int stock "庫存數量"
        timestamp created_at
    }

    product_comment {
        int id PK
        int product_id FK
        int user_id FK "可為 NULL"
        varchar username
        int rating
        text content
        timestamp create_time "排序用，最新在上"
    }

    counter {
        int id PK
        int count "訪客累計人數"
    }

    orders {
        int id PK
        int member_id FK
        varchar recipient_name
        varchar phone
        varchar address
        varchar payment
        int total
        varchar status "pending / paid ..."
        timestamp created_at
    }

    order_items {
        int id PK
        int order_id FK
        int product_id FK
        varchar name
        int price
        varchar size
        int quantity
    }
```

> `counter` 為單列計數表，與其他表無外鍵關聯，故獨立於關係圖之外。

## 資料表說明

| 資料表 | 用途 | 對應功能 / 負責人 |
|--------|------|------------------|
| `members` | 會員帳號、登入資訊 | 登入控制④、密碼雜湊(加分) ／ 組員C・D |
| `product` | 商品資料、庫存 | 商品陳列①、庫存②、搜尋⑤ ／ 組員A・B |
| `product_comment` | 商品留言 / 評價 | 留言板③ ／ 組員C |
| `counter` | 訪客計數器 | 計數器⑥ ／ 組員C |
| `orders` / `order_items` | 訂單與明細 | 購物車結帳(延伸①)、管理者訂單(延伸③) ／ 組員B |

## 與既有程式的對應（為何這樣設計）

- `members(name, email, phone)` ← `member.jsp` 的 `SELECT name, email, phone WHERE id=?`
- `members(username, password, salt)` ← `login_process.jsp` 改為取出 salt+hash 後比對（不再比對明文）
- `product(name, price, image, description)` ← `product.jsp` 的 `SELECT * FROM product WHERE id=?`
- `product_comment(... ORDER BY create_time DESC)` ← `product.jsp` 留言列表「最新在最上」
- `counter(count)` ← `index.jsp` 訪客計數器（已由原 `counter` 資料庫移入 `shopdb`）

## 新增欄位（為日後功能預留）

- `product.stock`：組員B「購買後庫存減少」。
- `product.category`：分類頁 / 搜尋。
- `members.role`：管理者功能（上架商品、瀏覽訂單）。
- `orders` / `order_items`：組員B 結帳與訂單瀏覽。
