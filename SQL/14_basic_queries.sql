USE ecommerce_analytics;

SELECT COUNT(*) AS total_customers
FROM customers;
SELECT COUNT(*) AS total_orders
FROM orders;
SELECT COUNT(*) AS total_products
FROM products;
SELECT COUNT(*) AS total_sellers
FROM sellers;

-- Query 5: List all order statuses

SELECT DISTINCT order_status
FROM orders;

-- Query 6: Number of orders by status

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- Query 7: Count delivered orders

SELECT COUNT(*) AS delivered_orders
FROM orders
WHERE order_status = 'delivered';

-- Query 8: Count orders that are not delivered

SELECT COUNT(*) AS non_delivered_orders
FROM orders
WHERE order_status <> 'delivered';

-- Query 9: Average product price

SELECT
    AVG(price) AS average_price
FROM order_items;

-- Query 10: Minimum and maximum product price

SELECT
    MIN(price) AS minimum_price,
    MAX(price) AS maximum_price
FROM order_items;

-- Query 11: Total product revenue

SELECT
    SUM(price) AS total_revenue
FROM order_items;

-- Query 12: Number of customers by city

SELECT
    customer_city,
    COUNT(*) AS total_customers
FROM customers
GROUP BY customer_city
ORDER BY total_customers DESC;

-- Query 13: Top 10 cities by customer count

SELECT
    customer_city,
    COUNT(*) AS total_customers
FROM customers
GROUP BY customer_city
ORDER BY total_customers DESC
LIMIT 10;

-- Query 14: Top 10 sellers by number of items sold

SELECT
    seller_id,
    COUNT(*) AS items_sold
FROM order_items
GROUP BY seller_id
ORDER BY items_sold DESC
LIMIT 10;

-- Query 15: Top 10 sellers by revenue

SELECT
    seller_id,
    COUNT(*) AS items_sold,
    SUM(price) AS total_revenue
FROM order_items
GROUP BY seller_id
ORDER BY total_revenue DESC
LIMIT 10;

-- Query 16: Revenue by product category

SELECT
    p.product_category_name,
    SUM(oi.price) AS total_revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC;

-- Query 17: Top 10 product categories by revenue

SELECT
    p.product_category_name,
    SUM(oi.price) AS total_revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 10;

-- Query 18: Top 10 categories by number of items sold

SELECT
    p.product_category_name,
    COUNT(*) AS items_sold
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY items_sold DESC
LIMIT 10;

-- Query 19: Top 10 customers by spending

SELECT
    c.customer_unique_id,
    SUM(oi.price) AS total_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_unique_id
ORDER BY total_spent DESC
LIMIT 10;

-- Query 20: Average customer spending

SELECT
    AVG(customer_total) AS average_customer_spending
FROM (
    SELECT
        c.customer_unique_id,
        SUM(oi.price) AS customer_total
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_unique_id
) AS customer_spending;

-- Query 21: Top 10 customers by number of orders

SELECT
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
ORDER BY total_orders DESC
LIMIT 10;

-- Query 22: Number of orders by year

SELECT
    YEAR(order_purchase_timestamp) AS order_year,
    COUNT(*) AS total_orders
FROM orders
GROUP BY YEAR(order_purchase_timestamp)
ORDER BY order_year;

-- Query 23: Number of orders by month

SELECT
    YEAR(order_purchase_timestamp) AS order_year,
    MONTH(order_purchase_timestamp) AS order_month,
    COUNT(*) AS total_orders
FROM orders
GROUP BY
    YEAR(order_purchase_timestamp),
    MONTH(order_purchase_timestamp)
ORDER BY
    order_year,
    order_month;

-- Query 24: Orders by day of week

SELECT
    DAYNAME(order_purchase_timestamp) AS day_of_week,
    COUNT(*) AS total_orders
FROM orders
GROUP BY DAYNAME(order_purchase_timestamp)
ORDER BY total_orders DESC;

-- Query 25: Average delivery time in days

SELECT
    AVG(
        DATEDIFF(
            order_delivered_customer_date,
            order_purchase_timestamp
        )
    ) AS avg_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;

-- Query 26: Late deliveries

SELECT
    COUNT(*) AS late_deliveries
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL
  AND order_delivered_customer_date > order_estimated_delivery_date;