-- ============================================
-- Lesson 5: Create Sellers Table
-- ============================================

USE ecommerce_analytics;

CREATE TABLE sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix INT,
    seller_city VARCHAR(100),
    seller_state CHAR(2)
);

SHOW TABLES;

DESCRIBE sellers;