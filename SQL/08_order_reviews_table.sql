-- ============================================
-- Lesson 8: Create Order Reviews Table
-- ============================================

USE ecommerce_analytics;

CREATE TABLE order_reviews (
    review_id VARCHAR(50) NOT NULL,
    order_id VARCHAR(50) NOT NULL,
    review_score INT,
    review_comment_title VARCHAR(255),
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME,

    PRIMARY KEY (review_id),

    CONSTRAINT fk_review_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);

SHOW TABLES;

DESCRIBE order_reviews;