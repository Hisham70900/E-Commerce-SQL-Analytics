

-- =====================================================
-- Lesson 12: Import CSV Data
-- =====================================================

USE ecommerce_analytics;

LOAD DATA LOCAL INFILE '/home/m16labs/E-Commerce-SQL-Analytics/Dataset/olist_customers_dataset.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM customers;

LOAD DATA LOCAL INFILE '/home/m16labs/E-Commerce-SQL-Analytics/Dataset/olist_orders_dataset.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM orders;

LOAD DATA LOCAL INFILE '/home/m16labs/E-Commerce-SQL-Analytics/Dataset/olist_products_dataset.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM products;

LOAD DATA LOCAL INFILE '/home/m16labs/E-Commerce-SQL-Analytics/Dataset/olist_sellers_dataset.csv'
INTO TABLE sellers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM sellers;

LOAD DATA LOCAL INFILE '/home/m16labs/E-Commerce-SQL-Analytics/Dataset/olist_order_items_dataset.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM order_items;

LOAD DATA LOCAL INFILE '/home/m16labs/E-Commerce-SQL-Analytics/Dataset/olist_order_payments_dataset.csv'
INTO TABLE order_payments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM order_payments;

LOAD DATA LOCAL INFILE '/home/m16labs/E-Commerce-SQL-Analytics/Dataset/olist_order_reviews_dataset.csv'
INTO TABLE order_reviews
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM order_reviews;

LOAD DATA LOCAL INFILE '/home/m16labs/E-Commerce-SQL-Analytics/Dataset/olist_geolocation_dataset.csv'
INTO TABLE geolocation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM geolocation;

LOAD DATA LOCAL INFILE '/home/m16labs/E-Commerce-SQL-Analytics/Dataset/product_category_name_translation.csv'
INTO TABLE category_translation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) FROM category_translation;

SHOW TABLES;