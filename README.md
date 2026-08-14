# 🛒 E-Commerce SQL Analytics

A complete SQL-based e-commerce data analytics project using MySQL and the Brazilian E-Commerce Public Dataset by Olist.

## 📌 Project Overview

This project demonstrates how SQL can be used to build, clean, analyze, and extract business insights from a real-world e-commerce dataset.

The project covers the complete data analytics workflow:

CSV Dataset → MySQL Database → Data Cleaning → SQL Analysis → Business Insights

## 🎯 Objectives

- Build a relational e-commerce database using MySQL
- Import and validate real-world e-commerce data
- Establish relationships between tables using primary and foreign keys
- Perform data-quality checks
- Analyze sales, customers, products, sellers, payments, reviews, and deliveries
- Generate business KPIs using SQL
- Apply basic, intermediate, and advanced SQL techniques

## 🗂️ Dataset

The project uses the Brazilian E-Commerce Public Dataset by Olist.

The dataset contains information about:

- Customers
- Orders
- Products
- Sellers
- Order Items
- Payments
- Reviews
- Geolocation
- Product Categories

## 🗄️ Database Structure

The MySQL database is named:

`ecommerce_analytics`

### Tables

| Table | Description |
|---|---|
| customers | Customer information |
| orders | Order and delivery information |
| products | Product details |
| sellers | Seller information |
| order_items | Products included in each order |
| order_payments | Payment information |
| order_reviews | Customer reviews |
| geolocation | Geographic information |
| category_translation | Product category translations |

## 🔗 Relationships

Main relationships include:

customers → orders

orders → order_items

products → order_items

sellers → order_items

orders → order_payments

orders → order_reviews

## 🧹 Data Cleaning

The project includes SQL-based data-quality checks for:

- Missing IDs
- NULL values
- Duplicate records
- Invalid prices
- Invalid review scores
- Invalid payment values
- Delivery-date inconsistencies
- Referential integrity

## 📊 SQL Analysis

The project contains 90 SQL analysis queries covering:

### Basic SQL

- SELECT
- WHERE
- DISTINCT
- COUNT
- SUM
- AVG
- MIN / MAX
- GROUP BY
- ORDER BY
- LIMIT
- JOIN
- Date functions

### Intermediate SQL

- CASE statements
- HAVING
- Subqueries
- CTEs
- LEFT JOIN
- Aggregations
- Customer analysis

### Advanced SQL

- Window functions
- RANK()
- ROW_NUMBER()
- Running totals
- Revenue percentages
- Customer ranking
- Customer lifetime value
- Advanced CTEs

## 📈 Business Analysis

The project analyzes:

- Total customers and orders
- Revenue
- Average order value
- Monthly revenue trends
- Top-selling products
- Top product categories
- Top-performing sellers
- Customer spending
- Repeat customers
- Payment methods
- Customer review scores
- Delivery performance
- Late delivery rates
- Revenue by state
- Seller performance

## 🛠️ Technologies Used

- MySQL
- SQL
- DBeaver
- VS Code
- Git
- GitHub

## 📁 Project Structure

```text
E-Commerce-SQL-Analytics/
│
├── Dataset/
│
├── SQL/
│   ├── 01_database.sql
│   ├── 02_customers_table.sql
│   ├── 03_orders_table.sql
│   ├── 04_products_table.sql
│   ├── 05_sellers_table.sql
│   ├── 06_order_items_table.sql
│   ├── 07_order_payments_table.sql
│   ├── 08_order_reviews_table.sql
│   ├── 09_geolocation_table.sql
│   ├── 10_category_translation_table.sql
│   ├── 11_foreign_keys.sql
│   ├── 12_import_data.sql
│   ├── 13_data_cleaning.sql
│   ├── 14_basic_queries.sql
│   ├── 15_intermediate_queries.sql
│   ├── 16_advanced_queries.sql
│   └── 17_final_analysis.sql
│
└── README.md