USE shopdb;

ALTER TABLE product_comment
  DROP FOREIGN KEY fk_comment_product,
  DROP FOREIGN KEY fk_comment_member,
  ADD CONSTRAINT fk_comment_product
    FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE,
  ADD CONSTRAINT fk_comment_member
    FOREIGN KEY (user_id) REFERENCES members(id) ON DELETE SET NULL;

ALTER TABLE cart
  DROP FOREIGN KEY fk_cart_member,
  DROP FOREIGN KEY fk_cart_product,
  DROP INDEX unique_cart_item,
  ADD COLUMN size VARCHAR(10) NOT NULL DEFAULT 'M' AFTER quantity,
  ADD UNIQUE KEY unique_cart_item (user_id, product_id, size),
  ADD CONSTRAINT fk_cart_member
    FOREIGN KEY (user_id) REFERENCES members(id) ON DELETE CASCADE,
  ADD CONSTRAINT fk_cart_product
    FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE;

ALTER TABLE orders
  DROP FOREIGN KEY fk_order_member,
  ADD CONSTRAINT fk_order_member
    FOREIGN KEY (member_id) REFERENCES members(id) ON DELETE SET NULL;

ALTER TABLE order_items
  DROP FOREIGN KEY fk_item_order,
  DROP FOREIGN KEY fk_item_product,
  ADD CONSTRAINT fk_item_order
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  ADD CONSTRAINT fk_item_product
    FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE SET NULL;
