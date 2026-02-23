### **🛍️ Retail Business Intelligence & Customer Analytics (SQL Project)**

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

- Reviewed table relationships and keys

- Checked for NULL values and duplicates

- Used JOINS to combine tables

- Applied SUM(), AVG(), COUNT() for metrics

- Used window functions like RANK() and LAG()

- Performed month, week, and state-based analysis

**📊 Key Insights**

**📅 Sales Trends**

| Area                  | Key Insight                                                         |
| --------------------- | ------------------------------------------------------------------- |
| Monthly Revenue       | November recorded the highest revenue.                              |
| Peak Day              | Saturday generates the highest sales.                               |
| Target Achievement    | 2023 showed fluctuations; some months overachieved targets.         |
| Revenue Concentration | Small % of products contribute major share of revenue (80/20 rule). |


**🌍 State Performance**

| Area                   | Key Insight                                          |
| ---------------------- | ---------------------------------------------------- |
| Highest Revenue State  | MH generated the highest total revenue.              |
| Revenue per Customer   | TN shows strong revenue per customer.                |
| Underperforming Region | WB records comparatively lower revenue per customer. |
| Category Preference    | Sports leads in most states; Fashion leads in MH.    |


**👥 Customer Insights**

| Area                 | Key Insight                                                |
| -------------------- | ---------------------------------------------------------- |
| Purchase Frequency   | Most customers purchased only once.                        |
| High-Value Customers | Few customers contribute significantly higher revenue.     |
| Inactive Customers   | Many customers inactive for 90+ days.                      |
| Revenue Source       | New customers generate more revenue than repeat customers. |


**📦 Product Insights**

| Area                  | Key Insight                                                          |
| --------------------- | -------------------------------------------------------------------- |
| Top Category          | Sports generates highest revenue and profit.                         |
| High Revenue Products | Some products earn high revenue with low quantity (premium pricing). |
| Return Analysis       | Several products show high return rates.                             |
| Cross-Selling         | Weak association between most product pairs.                         |


**🚀 Skills Demonstrated**

- SQL Joins

- Aggregations

- Window Functions

- KPI Calculation

- Business Insight Generation

**📌 Conclusion**

This project demonstrates how SQL can be used to analyze retail data and support data-driven business decisions. It highlights sales performance, customer behavior, and product profitability in a structured and practical way.
