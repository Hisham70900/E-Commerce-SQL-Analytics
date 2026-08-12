-- ============================================
-- Lesson 10: Create Category Translation Table
-- ============================================

USE ecommerce_analytics;

CREATE TABLE category_translation (
    product_category_name VARCHAR(100) NOT NULL,
    product_category_name_english VARCHAR(100),

    PRIMARY KEY (product_category_name)
);

SHOW TABLES;

DESCRIBE category_translation;