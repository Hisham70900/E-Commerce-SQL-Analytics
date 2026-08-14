-- ============================================
-- Lesson 17: Final Business Analysis
-- ============================================

USE ecommerce_analytics;

-- Query 61: Overall Business KPIs

SELECT
    (SELECT COUNT(*) FROM customers) AS total_customers,
    (SELECT COUNT(*) FROM orders) AS total_orders,
    (SELECT COUNT(*) FROM products) AS total_products,
    (SELECT COUNT(*) FROM sellers) AS total_sellers,
    (SELECT ROUND(SUM(price), 2) FROM order_items) AS total_revenue,
    (SELECT ROUND(AVG(price), 2) FROM order_items) AS average_item_price;

-- Query 62: Total revenue from delivered orders

SELECT
    ROUND(SUM(oi.price), 2) AS delivered_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';

-- Query 63: Orders by status

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- Query 64: Revenue by payment type

SELECT
    op.payment_type,
    ROUND(SUM(op.payment_value), 2) AS total_payment_value
FROM order_payments op
GROUP BY op.payment_type
ORDER BY total_payment_value DESC;

-- Query 65: Average review score by order status

SELECT
    o.order_status,
    ROUND(AVG(r.review_score), 2) AS average_review_score,
    COUNT(*) AS total_reviews
FROM orders o
JOIN order_reviews r
    ON o.order_id = r.order_id
GROUP BY o.order_status
ORDER BY average_review_score DESC;

-- Query 66: Top 10 product categories by revenue

SELECT
    p.product_category_name,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 10;

-- Query 67: Top 10 sellers by revenue

SELECT
    seller_id,
    ROUND(SUM(price), 2) AS total_revenue
FROM order_items
GROUP BY seller_id
ORDER BY total_revenue DESC
LIMIT 10;

-- Query 68: Monthly revenue trend

SELECT
    YEAR(o.order_purchase_timestamp) AS order_year,
    MONTH(o.order_purchase_timestamp) AS order_month,
    ROUND(SUM(oi.price), 2) AS monthly_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp)
ORDER BY
    order_year,
    order_month;

-- Query 69: Delivery performance

SELECT
    ROUND(
        AVG(
            DATEDIFF(
                order_delivered_customer_date,
                order_purchase_timestamp
            )
        ), 2
    ) AS average_delivery_days,
    ROUND(
        AVG(
            DATEDIFF(
                order_estimated_delivery_date,
                order_purchase_timestamp
            )
        ), 2
    ) AS average_estimated_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;

-- Query 70: Top 10 customers by spending

SELECT
    c.customer_unique_id,
    ROUND(SUM(oi.price), 2) AS total_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_unique_id
ORDER BY total_spent DESC
LIMIT 10;

-- Query 71: Customers who placed more than one order

SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(DISTINCT o.order_id) > 1
ORDER BY total_orders DESC;

-- Query 72: Late delivery rate

SELECT
    ROUND(
        100.0 * SUM(
            CASE
                WHEN order_delivered_customer_date > order_estimated_delivery_date
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS late_delivery_rate_percent
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;

-- Query 73: Average customer review score

SELECT
    ROUND(AVG(review_score), 2) AS average_review_score,
    COUNT(*) AS total_reviews
FROM order_reviews;

-- Query 74: Average order value

SELECT
    ROUND(AVG(order_total), 2) AS average_order_value
FROM (
    SELECT
        o.order_id,
        SUM(oi.price) AS order_total
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY o.order_id
) AS order_totals;

-- Query 75: Top 10 categories by items sold

SELECT
    p.product_category_name,
    COUNT(*) AS items_sold
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY items_sold DESC
LIMIT 10;

-- Query 76: Payment method usage

SELECT
    payment_type,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(payment_value), 2) AS total_payment_value
FROM order_payments
GROUP BY payment_type
ORDER BY total_orders DESC;

-- Query 77: Review score distribution

SELECT
    review_score,
    COUNT(*) AS total_reviews,
    ROUND(
        100.0 * COUNT(*) / (SELECT COUNT(*) FROM order_reviews),
        2
    ) AS percentage_of_reviews
FROM order_reviews
GROUP BY review_score
ORDER BY review_score DESC;

-- Query 78: Customers by state

SELECT
    g.geolocation_state,
    COUNT(DISTINCT c.customer_unique_id) AS total_customers
FROM customers c
JOIN geolocation g
    ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix
GROUP BY g.geolocation_state
ORDER BY total_customers DESC;

-- Query 79: Revenue by customer state

SELECT
    g.geolocation_state,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM customers c
JOIN geolocation g
    ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY g.geolocation_state
ORDER BY total_revenue DESC;

-- Query 80: Safe revenue by customer state

WITH unique_zip_locations AS (
    SELECT
        geolocation_zip_code_prefix,
        MAX(geolocation_state) AS geolocation_state
    FROM geolocation
    GROUP BY geolocation_zip_code_prefix
)
SELECT
    g.geolocation_state,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM customers c
JOIN unique_zip_locations g
    ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY g.geolocation_state
ORDER BY total_revenue DESC;

-- Query 81: Average revenue per customer by state

WITH unique_zip_locations AS (
    SELECT
        geolocation_zip_code_prefix,
        MAX(geolocation_state) AS geolocation_state
    FROM geolocation
    GROUP BY geolocation_zip_code_prefix
),
state_data AS (
    SELECT
        g.geolocation_state,
        c.customer_unique_id,
        SUM(oi.price) AS customer_revenue
    FROM customers c
    JOIN unique_zip_locations g
        ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY
        g.geolocation_state,
        c.customer_unique_id
)
SELECT
    geolocation_state,
    ROUND(AVG(customer_revenue), 2) AS average_revenue_per_customer,
    COUNT(*) AS total_customers
FROM state_data
GROUP BY geolocation_state
ORDER BY average_revenue_per_customer DESC;

-- Query 81: Average revenue per customer by state

WITH unique_zip_locations AS (
    SELECT
        geolocation_zip_code_prefix,
        MAX(geolocation_state) AS geolocation_state
    FROM geolocation
    GROUP BY geolocation_zip_code_prefix
),
state_data AS (
    SELECT
        g.geolocation_state,
        c.customer_unique_id,
        SUM(oi.price) AS customer_revenue
    FROM customers c
    JOIN unique_zip_locations g
        ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY
        g.geolocation_state,
        c.customer_unique_id
)
SELECT
    geolocation_state,
    ROUND(AVG(customer_revenue), 2) AS average_revenue_per_customer,
    COUNT(*) AS total_customers
FROM state_data
GROUP BY geolocation_state
ORDER BY average_revenue_per_customer DESC;

-- Query 82: Average delivery time by customer state

WITH unique_zip_locations AS (
    SELECT
        geolocation_zip_code_prefix,
        MAX(geolocation_state) AS geolocation_state
    FROM geolocation
    GROUP BY geolocation_zip_code_prefix
)
SELECT
    g.geolocation_state,
    ROUND(
        AVG(
            DATEDIFF(
                o.order_delivered_customer_date,
                o.order_purchase_timestamp
            )
        ), 2
    ) AS average_delivery_days,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN unique_zip_locations g
    ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
GROUP BY g.geolocation_state
ORDER BY average_delivery_days DESC;

-- Query 83: Late delivery rate by customer state

WITH unique_zip_locations AS (
    SELECT
        geolocation_zip_code_prefix,
        MAX(geolocation_state) AS geolocation_state
    FROM geolocation
    GROUP BY geolocation_zip_code_prefix
)
SELECT
    g.geolocation_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(
        CASE
            WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS late_orders,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
                THEN 1
                ELSE 0
            END
        ) / COUNT(DISTINCT o.order_id),
        2
    ) AS late_delivery_rate_percent
FROM customers c
JOIN unique_zip_locations g
    ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY g.geolocation_state
ORDER BY late_delivery_rate_percent DESC;

-- Query 84: Revenue by seller state

SELECT
    s.seller_state,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM sellers s
JOIN order_items oi
    ON s.seller_id = oi.seller_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY s.seller_state
ORDER BY total_revenue DESC;

-- Query 85: Top 10 sellers by items sold

SELECT
    s.seller_id,
    s.seller_city,
    s.seller_state,
    COUNT(*) AS items_sold,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM sellers s
JOIN order_items oi
    ON s.seller_id = oi.seller_id
GROUP BY
    s.seller_id,
    s.seller_city,
    s.seller_state
ORDER BY items_sold DESC
LIMIT 10;

-- Query 86: Payment methods by revenue

SELECT
    payment_type,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(payment_value), 2) AS total_payment_value,
    ROUND(AVG(payment_value), 2) AS average_payment_value
FROM order_payments
GROUP BY payment_type
ORDER BY total_payment_value DESC;

-- Query 87: Average installments by payment type

SELECT
    payment_type,
    ROUND(AVG(payment_installments), 2) AS average_installments,
    MAX(payment_installments) AS maximum_installments,
    COUNT(DISTINCT order_id) AS total_orders
FROM order_payments
GROUP BY payment_type
ORDER BY average_installments DESC;

-- Query 88: Average review score by product category

SELECT
    p.product_category_name,
    ROUND(AVG(r.review_score), 2) AS average_review_score,
    COUNT(*) AS total_reviews
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
JOIN orders o
    ON oi.order_id = o.order_id
JOIN order_reviews r
    ON o.order_id = r.order_id
GROUP BY p.product_category_name
HAVING COUNT(*) >= 10
ORDER BY average_review_score DESC;

-- Query 89: High-performing categories

SELECT
    p.product_category_name,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(AVG(r.review_score), 2) AS average_review_score,
    COUNT(*) AS total_reviews
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
JOIN orders o
    ON oi.order_id = o.order_id
JOIN order_reviews r
    ON o.order_id = r.order_id
GROUP BY p.product_category_name
HAVING COUNT(*) >= 10
   AND AVG(r.review_score) >= 4
ORDER BY total_revenue DESC;

-- Query 90: Seller performance summary

SELECT
    s.seller_id,
    s.seller_city,
    s.seller_state,
    COUNT(*) AS items_sold,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(AVG(oi.price), 2) AS average_item_price
FROM sellers s
JOIN order_items oi
    ON s.seller_id = oi.seller_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY
    s.seller_id,
    s.seller_city,
    s.seller_state
ORDER BY total_revenue DESC
LIMIT 20;