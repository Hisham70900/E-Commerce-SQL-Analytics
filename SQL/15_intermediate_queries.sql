-- ============================================
-- Lesson 15: Intermediate SQL
-- ============================================

USE ecommerce_analytics;

-- Query 27: Classify orders by status

SELECT
    order_id,
    order_status,
    CASE
        WHEN order_status = 'delivered' THEN 'Completed'
        WHEN order_status = 'canceled' THEN 'Cancelled'
        ELSE 'Other'
    END AS order_category
FROM orders;

-- Query 28: Count orders by business category

SELECT
    CASE
        WHEN order_status = 'delivered' THEN 'Completed'
        WHEN order_status = 'canceled' THEN 'Cancelled'
        ELSE 'Other'
    END AS order_category,
    COUNT(*) AS total_orders
FROM orders
GROUP BY
    CASE
        WHEN order_status = 'delivered' THEN 'Completed'
        WHEN order_status = 'canceled' THEN 'Cancelled'
        ELSE 'Other'
    END
ORDER BY total_orders DESC;

-- Query 29: Sellers with revenue greater than 100,000

SELECT
    seller_id,
    SUM(price) AS total_revenue
FROM order_items
GROUP BY seller_id
HAVING SUM(price) > 100000
ORDER BY total_revenue DESC;

-- Query 30: Products priced above average

SELECT
    order_id,
    product_id,
    price
FROM order_items
WHERE price > (
    SELECT AVG(price)
    FROM order_items
)
ORDER BY price DESC;

-- Query 31: Sellers with above-average revenue

SELECT
    seller_id,
    SUM(price) AS total_revenue
FROM order_items
GROUP BY seller_id
HAVING SUM(price) > (
    SELECT AVG(seller_revenue)
    FROM (
        SELECT
            seller_id,
            SUM(price) AS seller_revenue
        FROM order_items
        GROUP BY seller_id
    ) AS seller_totals
)
ORDER BY total_revenue DESC;

-- Query 32: Customers with multiple orders

SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(DISTINCT o.order_id) > 1
ORDER BY total_orders DESC;

-- Query 33: Customer spending using a CTE

WITH customer_spending AS (
    SELECT
        c.customer_unique_id,
        SUM(oi.price) AS total_spent
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_unique_id
)

SELECT
    customer_unique_id,
    total_spent
FROM customer_spending
ORDER BY total_spent DESC
LIMIT 10;

-- Query 34: Customers spending above average

WITH customer_spending AS (
    SELECT
        c.customer_unique_id,
        SUM(oi.price) AS total_spent
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_unique_id
)

SELECT
    customer_unique_id,
    total_spent
FROM customer_spending
WHERE total_spent > (
    SELECT AVG(total_spent)
    FROM customer_spending
)
ORDER BY total_spent DESC;

-- Query 35: Customers with more than 3 orders

SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(DISTINCT o.order_id) > 3
ORDER BY total_orders DESC;

-- Query 36: Customers with no orders

SELECT
    c.customer_unique_id,
    c.customer_id
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL
ORDER BY c.customer_unique_id;

-- Query 37: Top 10 customers by total spending

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

-- Query 38: Customers with the most orders

SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
ORDER BY total_orders DESC
LIMIT 10;

-- Query 39: Top 10 product categories by revenue

SELECT
    p.product_category_name,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 10;

-- Query 40: Top 10 sellers by revenue

SELECT
    seller_id,
    ROUND(SUM(price), 2) AS total_revenue
FROM order_items
GROUP BY seller_id
ORDER BY total_revenue DESC
LIMIT 10;

-- Query 41: Average order value

SELECT
    ROUND(AVG(order_total), 2) AS average_order_value
FROM (
    SELECT
        o.order_id,
        SUM(oi.price) AS order_total
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY o.order_id
) AS order_totals;

-- Query 42: High-value orders

SELECT
    o.order_id,
    ROUND(SUM(oi.price), 2) AS order_total
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY o.order_id
HAVING SUM(oi.price) > 10000
ORDER BY order_total DESC;

-- Query 43: Revenue by order status

SELECT
    o.order_status,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY o.order_status
ORDER BY total_revenue DESC;

-- Query 44: Average order value by status

SELECT
    o.order_status,
    ROUND(AVG(order_total), 2) AS average_order_value
FROM orders o
JOIN (
    SELECT
        order_id,
        SUM(price) AS order_total
    FROM order_items
    GROUP BY order_id
) AS order_totals
    ON o.order_id = order_totals.order_id
GROUP BY o.order_status
ORDER BY average_order_value DESC;

-- Query 45: Monthly revenue

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

-- Query 46: Monthly order volume

SELECT
    YEAR(order_purchase_timestamp) AS order_year,
    MONTH(order_purchase_timestamp) AS order_month,
    COUNT(*) AS total_orders
FROM orders
WHERE order_status = 'delivered'
GROUP BY
    YEAR(order_purchase_timestamp),
    MONTH(order_purchase_timestamp)
ORDER BY
    order_year,
    order_month;

-- Query 47: Orders by day of week

SELECT
    DAYNAME(order_purchase_timestamp) AS day_of_week,
    COUNT(*) AS total_orders
FROM orders
WHERE order_status = 'delivered'
GROUP BY DAYNAME(order_purchase_timestamp)
ORDER BY total_orders DESC;

-- Query 48: Average delivery time by order status

SELECT
    o.order_status,
    ROUND(
        AVG(
            DATEDIFF(
                o.order_delivered_customer_date,
                o.order_purchase_timestamp
            )
        ), 2
    ) AS average_delivery_days
FROM orders o
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY o.order_status
ORDER BY average_delivery_days;

-- Query 49: Late delivery rate

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

-- Query 50: Average customer review score

SELECT
    ROUND(AVG(review_score), 2) AS average_review_score
FROM order_reviews;