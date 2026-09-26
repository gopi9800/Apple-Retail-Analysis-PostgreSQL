# Apple Retail Analysis — PostgreSQL

## Overview

This project uses PostgreSQL to analyze a retail business dataset covering
stores, products, categories, sales, and warranty claims.

The analysis focuses on sales performance, store-level trends, product
performance, and warranty behavior using business-oriented SQL queries.

## Business Objectives

The project answers business questions related to:

- Store performance across countries
- Product and category pricing
- Sales volume and trends
- Store growth and yearly performance
- Warranty claim behavior
- Warranty claim rates by country
- Product performance
- Running sales totals
- Time-based sales analysis

## Analysis Performed

### Store & Sales Analysis

- Number of stores by country
- Total units sold by store
- Highest-selling stores
- Best-selling day for each store
- Store sales growth across years
- Monthly running sales totals by store
- Monthly sales trends by country

### Product & Category Analysis

- Average product price by category
- Unique products sold over time
- Least-selling products by country
- Product price segmentation
- Sales performance across products and categories

### Warranty Analysis

- Percentage of warranty claims currently in progress
- Warranty claims by year
- Warranty claims filed within 180 days of purchase
- Warranty claims for recently launched products
- Warranty claims by product category
- Warranty claim rate by country
- Warranty claims across different product price segments

## SQL Techniques Used

- SELECT statements
- INNER JOIN
- LEFT JOIN
- GROUP BY
- HAVING
- Aggregate Functions
- CASE Statements
- Common Table Expressions (CTEs)
- Subqueries
- Window Functions
- RANK()
- DENSE_RANK()
- LAG()
- Running Totals
- Date and Time Functions
- EXTRACT()
- TO_CHAR()
- Conditional Calculations
- Percentage Calculations
- Year-over-Year Growth Analysis

## Database Tables

The analysis uses the following tables:

- `category`
- `products`
- `sales`
- `store`
- `warranty`

## Tools

- PostgreSQL
- pgAdmin

