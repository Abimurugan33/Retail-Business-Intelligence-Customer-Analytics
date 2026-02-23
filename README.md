**🛍️ Retail Business Intelligence & Customer Analytics (SQL Project)**

**📌 Overview**

This project analyzes a **retail business dataset using SQL** to generate insights on sales performance, customer behavior, and product trends.

The goal is to transform raw transactional data into clear, actionable business insights.

**📂 Dataset Tables**

| Table        | Description                       | Primary Key            | Key Columns                  |
| ------------ | --------------------------------- | ---------------------- | ---------------------------- |
| customer     | Customer details                  | customer_id            | name, city, state, join_date |
| products     | Product information               | product_id             | name, category, brand, price |
| orders       | Order-level details               | order_id               | date, status                 |
| order_items  | Product-level transaction details | (order_id, product_id) | unit_price, quantity         |
| sales_target | Monthly sales targets             | (year, month)          | target_sales                 |

***🎯 Project Goal**

To evaluate revenue trends, customer engagement, and product performance using SQL queries and analytical techniques.

**🛠️ Process Followed**

Reviewed table relationships and keys

Checked for NULL values and duplicates

Used JOINS to combine tables

Applied SUM(), AVG(), COUNT() for metrics

Used window functions like RANK() and LAG()

Performed month, week, and state-based analysis

**📊 Key Insights**

**📅 Sales Trends**

November recorded the highest revenue.

Saturday is the strongest sales day.

Sales performance fluctuated across months.

**🌍 State Performance**

MH generated the highest total revenue.

TN shows strong revenue per customer.

Some states show lower performance despite having customers.

**👥 Customer Insights**

Most customers purchased only once.

Many high-value customers are currently inactive.

New customers contribute more revenue than repeat customers.

**📦 Product Insights**

Sports category generates the highest revenue.

A small percentage of products contribute a large share of revenue (80/20 rule).

Some products show high return rates.

**🚀 Skills Demonstrated**

SQL Joins

Aggregations

Window Functions

KPI Calculation

Business Insight Generation

**📌 Conclusion**

This project demonstrates how SQL can be used to analyze retail data and support data-driven business decisions. It highlights sales performance, customer behavior, and product profitability in a structured and practical way.
