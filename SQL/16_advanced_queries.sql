-- Query 51: Rank sellers by revenue

SELECT
    seller_id,
    ROUND(SUM(price), 2) AS total_revenue,
    RANK() OVER (
        ORDER BY SUM(price) DESC
    ) AS revenue_rank
FROM order_items
GROUP BY seller_id
ORDER BY revenue_rank;

-- Query 52: Rank sellers using ROW_NUMBER

SELECT
    seller_id,
    total_revenue,
    ROW_NUMBER() OVER (
        ORDER BY total_revenue DESC
    ) AS seller_rank
FROM (
    SELECT
        seller_id,
        ROUND(SUM(price), 2) AS total_revenue
    FROM order_items
    GROUP BY seller_id
) AS seller_revenue
ORDER BY seller_rank
LIMIT 10;

-- Query 53: Seller contribution to total revenue

SELECT
    seller_id,
    ROUND(SUM(price), 2) AS seller_revenue,
    ROUND(
        100.0 * SUM(price) /
        SUM(SUM(price)) OVER (),
        2
    ) AS revenue_percentage
FROM order_items
GROUP BY seller_id
ORDER BY seller_revenue DESC;

-- Query 54: Running monthly revenue

WITH monthly_revenue AS (
    SELECT
        YEAR(o.order_purchase_timestamp) AS order_year,
        MONTH(o.order_purchase_timestamp) AS order_month,
        SUM(oi.price) AS monthly_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY
        YEAR(o.order_purchase_timestamp),
        MONTH(o.order_purchase_timestamp)
)
SELECT
    order_year,
    order_month,
    ROUND(monthly_revenue, 2) AS monthly_revenue,
    ROUND(
        SUM(monthly_revenue) OVER (
            ORDER BY order_year, order_month
        ),
        2
    ) AS cumulative_revenue
FROM monthly_revenue
ORDER BY order_year, order_month;

-- Query 55: Rank products by revenue

SELECT
    product_id,
    ROUND(SUM(price), 2) AS total_revenue,
    RANK() OVER (
        ORDER BY SUM(price) DESC
    ) AS revenue_rank
FROM order_items
GROUP BY product_id
ORDER BY revenue_rank;

-- Query 56: Top 10 products by units sold

SELECT
    product_id,
    COUNT(*) AS units_sold,
    RANK() OVER (
        ORDER BY COUNT(*) DESC
    ) AS sales_rank
FROM order_items
GROUP BY product_id
ORDER BY sales_rank
LIMIT 10;

-- Query 57: Rank product categories by revenue

SELECT
    p.product_category_name,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    RANK() OVER (
        ORDER BY SUM(oi.price) DESC
    ) AS revenue_rank
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY revenue_rank;

-- Query 58: Average product price by category

SELECT
    p.product_category_name,
    ROUND(AVG(oi.price), 2) AS average_price,
    COUNT(*) AS items_sold
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.product_category_name
HAVING COUNT(*) >= 10
ORDER BY average_price DESC;

-- Query 59: Rank customers by total spending

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
    ROUND(total_spent, 2) AS total_spent,
    RANK() OVER (
        ORDER BY total_spent DESC
    ) AS spending_rank
FROM customer_spending
ORDER BY spending_rank
LIMIT 20;

-- Query 60: Customer Lifetime Value

WITH customer_lifetime_value AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.price) AS lifetime_value
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_unique_id
)
SELECT
    customer_unique_id,
    total_orders,
    ROUND(lifetime_value, 2) AS lifetime_value
FROM customer_lifetime_value
ORDER BY lifetime_value DESC
LIMIT 20;