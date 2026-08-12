-- ============================================
-- Lesson 13: Data Cleaning & Quality Checks
-- ============================================

USE ecommerce_analytics;

-- Check missing customer IDs
SELECT COUNT(*) AS missing_customer_ids
FROM customers
WHERE customer_id IS NULL;

-- Check missing order IDs
SELECT COUNT(*) AS missing_order_ids
FROM orders
WHERE order_id IS NULL;

-- Check missing product IDs
SELECT COUNT(*) AS missing_product_ids
FROM products
WHERE product_id IS NULL;

-- Check missing seller IDs
SELECT COUNT(*) AS missing_seller_ids
FROM sellers
WHERE seller_id IS NULL;