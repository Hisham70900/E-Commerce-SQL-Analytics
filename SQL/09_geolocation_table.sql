-- ============================================
-- Lesson 9: Create Geolocation Table
-- ============================================

USE ecommerce_analytics;

CREATE TABLE geolocation (
    geolocation_zip_code_prefix INT NOT NULL,
    geolocation_lat DECIMAL(10,8),
    geolocation_lng DECIMAL(11,8),
    geolocation_city VARCHAR(100),
    geolocation_state CHAR(2)
);

SHOW TABLES;

DESCRIBE geolocation;