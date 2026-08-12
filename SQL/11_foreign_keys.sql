-- ============================================
-- Lesson 11: Add Foreign Key Relationships
-- ============================================

USE ecommerce_analytics;

-- Orders → Customers
ALTER TABLE orders
ADD CONSTRAINT fk_orders_customer
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);

-- Order Items → Orders
ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_order
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

-- Order Items → Products
ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_product
FOREIGN KEY (product_id)
REFERENCES products(product_id);

-- Order Items → Sellers
ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_seller
FOREIGN KEY (seller_id)
REFERENCES sellers(seller_id);

-- Order Payments → Orders
ALTER TABLE order_payments
ADD CONSTRAINT fk_payment_order
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

-- Order Reviews → Orders
ALTER TABLE order_reviews
ADD CONSTRAINT fk_review_order
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

SHOW TABLES;