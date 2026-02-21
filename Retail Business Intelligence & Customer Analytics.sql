use s1;
select * from orders;
select * from products;
select * from sales_targets;
select * from order_items;
select * from customers;

#CHECKING THE NULL VALUES COUNT IN EACH TABLE
#orders table
select 
sum(case when order_id is null then 1 else 0 end ) as category_id_null_count, 
sum(case when customer_id is null then 1 else 0 end ) as customer_id_null_count,
sum(case when order_date is null then 1 else 0 end ) as order_date_null_count,
sum(case when order_status is null then 1 else 0 end ) as order_status_null_count
from orders;

# Products Table
select 
sum(case when product_id is null then 1 else 0 end ) as product_id_null_count, 
sum(case when product_name is null then 1 else 0 end ) as product_name_null_count,
sum(case when category is null then 1 else 0 end ) as category_null_count,
sum(case when brand is null then 1 else 0 end ) as brand_null_count,
sum(case when price is null then 1 else 0 end ) as price_null_count
from products;

#Sales Target Table
select 
sum(case when year is null then 1 else 0 end ) as year_null_count, 
sum(case when month is null then 1 else 0 end ) as month_null_count,
sum(case when target_amount is null then 1 else 0 end ) as target_amount_null_count
from sales_targets ;

# Order Items Table
select 
sum(case when order_item_id is null then 1 else 0 end ) as order_item_id_null_count, 
sum(case when order_id is null then 1 else 0 end ) as order_id_null_count,
sum(case when product_id is null then 1 else 0 end ) as product_id_null_count,
sum(case when quantity is null then 1 else 0 end ) as quantity_null_count,
sum(case when unit_price is null then 1 else 0 end ) as unit_price_null_count
from order_items;

# Customers Table
select 
sum(case when customer_name is null then 1 else 0 end ) as customer_name_null_count, 
sum(case when city is null then 1 else 0 end ) as city_null_count,
sum(case when state is null then 1 else 0 end ) as state_null_count,
sum(case when join_date is null then 1 else 0 end ) as join_date_null_count,
sum(case when Year is null then 1 else 0 end ) as Year_null_count,
sum(case when Month is null then 1 else 0 end ) as Month_null_count,
sum(case when Day is null then 1 else 0 end ) as Day_null_count
from customers;

#THIS DATASET DOSE NOT HAVE ANY NULL VALUES 

select customer_id,count(*) as dup_count from customers
group by customer_id
having dup_count > 1;

select product_id,count(*) as dup_count from products
group by product_id
having dup_count > 1;

select order_id,count(*) as dup_count from orders
group by order_id
having dup_count > 1;

#date and time based sales analysis
#Monthly Sales Report
select 
extract(month from o.order_date) as months,
count(distinct oi.order_id) as total_orders,
sum(oi.quantity * oi.unit_price) as total_revenue,
sum(oi.quantity * oi.unit_price) / count(distinct oi.order_id) as avg_order_value
from orders o 
join order_items oi
on oi.order_id=o.order_id
group by extract(month from o.order_date)
order by  avg_order_value desc;

#Sales Trends by Day, Week, Month
select
dayname(o.order_id) as day_name,
week(o.order_id) as week_name,
month(o.order_id) as month_name,
count(distinct oi.order_id ) as total_orders,
sum(oi.quantity * oi.unit_price) as total_revenue
from orders o 
join order_items oi on o.order_id = oi.order_item_id
group by 
dayname(o.order_id),
week(o.order_id),
month(o.order_id)
order by 
 week_name,
 month_name;
 
#Top 3 Brands per Year
with yearly_brand_revenue as (
    select 
        year(o.order_date) as year,
        p.brand,
        SUM(oi.quantity * oi.unit_price) as revenue
    from orders o
    join order_items oi 
        on o.order_id = oi.order_id
    join products p 
        on oi.product_id = p.product_id
    group by year(o.order_date), p.brand
),
ranked_brands as (
    select *,
           rank() over (
               partition by year 
               order by revenue desc
           ) as rnk
    from yearly_brand_revenue
)
select 
    year,
    brand,
    revenue,
    rnk
from ranked_brands
where rnk <= 3
order by year, rnk;

# What is the peak shopping time?
select  
    DAYNAME(o.order_date) as weekday,
    COUNT(distinct o.order_id) as total_orders,
    SUM(oi.quantity * oi.unit_price) as total_revenue
from orders o
join order_items oi 
    on o.order_id = oi.order_id
group by DAYNAME(o.order_date)
order by total_orders desc;

#Analyze Order Cancellations
select month(order_date) as order_month,order_status,count(*) as analyze_order_status
from orders
group by order_month,order_status
order by  analyze_order_status;

#state-wise sales analysis
#Top-Selling Category by State 
 select 
 c.state,
 p.category,
 sum(oi.quantity * oi.unit_price) as total_revenue,
 rank() over(
 partition by  c.state
 order by sum(oi.quantity * oi.unit_price) desc
 ) as rnk
 from customers c 
 join orders o
 on c.customer_id=o.customer_id
 join order_items oi 
 on o.order_id=oi.order_id
 join products p
 on oi.product_id=p.product_id
 group by c.state,
 p.category;
 
#state-wise Customer Segmentation Dashboard
with state_metrics as(
select 
c.state,
count(distinct c.customer_id) as total_customers,
count(distinct o.order_id) as total_orders,
sum(oi.quantity * oi.unit_price ) as total_revenue,
round(
sum(oi.quantity * oi.unit_price )/count(distinct o.order_id),2
) as avg_order_value
from customers c
join orders o on c.customer_id=o.order_id
join order_items oi on o.order_id=oi.order_id
group by c.state
),
category_revenue AS (
    select 
        c.state,
        p.category,
        SUM(oi.quantity * oi.unit_price) AS revenue
    from customers c
    join orders o on c.customer_id = o.customer_id
    join order_items oi on o.order_id = oi.order_id
    join products p on oi.product_id = p.product_id
    group by c.state, p.category
),
ranked_categories as (
    select *,
           rank() over (partition by state order by revenue desc ) as rnk
    from category_revenue
)
select 
    sm.state,
    sm.total_customers,
    sm.total_revenue,
    sm.avg_order_value,
    rc.category as top_category
from state_metrics sm
join ranked_categories rc
    on sm.state = rc.state
where rc.rnk = 1
order by sm.total_revenue desc;

# Which regions are underperforming despite having many customers?
with region_metrics as (
    select
        c.state as region,
        COUNT(distinct c.customer_id) as customer_count,
        SUM(oi.quantity * oi.unit_price) as total_revenue
    from customers c
    join orders o on c.customer_id = o.customer_id
    join order_items oi on o.order_id = oi.order_id
    group by c.state
)
select
    region,
    customer_count,
    total_revenue,
    ROUND(total_revenue / customer_count, 2) AS revenue_per_customer,
    case 
        when customer_count > (select avg(customer_count) from region_metrics)
         and total_revenue < (select avg(total_revenue) from region_metrics)
        then 'Underperforming'
        else 'Normal'
   end as performance_flag
from region_metrics;

#sales based analysis
#Category Profitability Analysis
select
p.category,
sum(oi.quantity * oi.unit_price) as total_revenue,
sum(oi.quantity * oi.unit_price * 0.7) as total_cost,
sum(oi.quantity * oi.unit_price * 0.3) as total_profit,
round(
(sum(oi.quantity * oi.unit_price * 0.3)/
sum(oi.quantity * oi.unit_price))*100,2
) as profit_margin
from order_items oi 
join products p
on oi.product_id=p.product_id
group by p.category
order by total_profit desc;

# Which 20% of products bring 80% revenue?
with product_revenue as (
    select 
        p.product_id,
        p.product_name,
        SUM(oi.quantity * oi.unit_price) AS revenue
    from orders o
    join order_items oi on o.order_id = oi.order_id
    join products p on oi.product_id = p.product_id
    group by p.product_id, p.product_name
),
ranked_products as (
    select 
        product_id,
        product_name,
        revenue,
        sum(revenue) over () as total_revenue,
        sum(revenue) over (order by revenue desc) as cumulative_revenue,
        row_number() OVER (order by revenue desc) as product_rank,
        COUNT(*) over () as total_products
    from product_revenue
)
select 
    product_id,
    product_name,
    revenue,
    ROUND((revenue / total_revenue) * 100, 2) as revenue_percentage,
    ROUND((cumulative_revenue / total_revenue) * 100, 2) as cumulative_percentage,
    ROUND((product_rank / total_products) * 100, 2) as product_percentage
from ranked_products
where (product_rank / total_products) <= 0.20
order by revenue desc;

#RFM Analysis (Recency, Frequency, Monetary) 
 select 
 c.customer_id,
 datediff(
 (select max(order_date) from orders),
 max(o.order_date)
 ) as recency_days,
 count(distinct o.order_id) as frequency,
 sum(oi.quantity * oi.unit_price) as monetary
 from customers c
 join orders o
 on c.customer_id=o.order_id
 join order_items oi
 on o.order_id=oi.order_id
 group by c.customer_id
 order by monetary desc;
 
 #Are we hitting sales targets?
 WITH monthly_actual AS (
    SELECT 
        YEAR(o.order_date) AS year,
        MONTH(o.order_date) AS month,
        SUM(oi.quantity * oi.unit_price) AS actual_revenue
    FROM orders o
    JOIN order_items oi 
        ON o.order_id = oi.order_id
    GROUP BY YEAR(o.order_date), MONTH(o.order_date)
)
SELECT 
    t.year,
    t.month,
    t.target_amount,
    COALESCE(a.actual_revenue, 0) AS actual_revenue,
    COALESCE(a.actual_revenue, 0) - t.target_amount AS variance,
    ROUND(
        (COALESCE(a.actual_revenue, 0) / t.target_amount) * 100,
        2
    ) AS achievement_percentage
FROM sales_targets t
LEFT JOIN monthly_actual a
    ON t.year = a.year
    AND t.month = a.month
ORDER BY t.year, t.month;

#customer based analysis
# Which customers are most likely to reorder?
with rfm as (
    select 
        c.customer_id,
        c.customer_name,
        COUNT(distinct o.order_id) as frequency,
        SUM(oi.quantity * oi.unit_price) as monetary,
        DATEDIFF(CURDATE(), MAX(o.order_date)) as recency
    from customers c
    join orders o on c.customer_id = o.customer_id
    join order_items oi on o.order_id = oi.order_id
    group by c.customer_id, c.customer_name
)
select *
from rfm
order by frequency desc, monetary desc;

#Top 10 Highest Spending Customers (LTV)
select orders.customer_id,
sum(order_items.quantity * order_items.unit_price) as total_amount_spent
from orders
join order_items on orders.order_id = order_items.order_item_id
group by orders.customer_id
order by total_amount_spent desc limit 10;

#Identify Customers Inactive for 90+ Days
select 
customer_id,
max(order_date) as last_order_date,
datediff(current_date(),max(order_date)) as days_inactive
from orders 
group by customer_id
having datediff(current_date(),max(order_date))>90
order by days_inactive desc;

#How much revenue comes from repeat vs new customers?
select
    case 
        when o.order_date = first_orders.first_order_date 
        then 'New Customer'
        else 'Repeat Customer'
    end as customer_type,
    sum(oi.quantity * oi.unit_price) as total_revenue
from orders o

join (
        select
            customer_id, 
            min(order_date) as first_order_date
       from orders
        group by customer_id
     ) as first_orders
     on o.customer_id = first_orders.customer_id

join order_items oi 
    on o.order_id = oi.order_id
    
group by customer_type;

#product based analysis
#Which products get returned the most?
select
    p.product_id,
    p.product_name,
    sum(case
            when o.order_status = 'Returned' 
            then oi.quantity else 0 
        end) as returned_quantity,
        sum(oi.quantity) as total_quantity_sold,
        (
        sum(case 
                when o.order_status = 'Returned' 
                then oi.quantity else 0 
            end) 
        / sum(oi.quantity)
    ) * 100 as return_rate_percentage
from orders o
join order_items oi 
    on o.order_id = oi.order_id
join products p 
   on oi.product_id = p.product_id
group by  p.product_id, p.product_name
having returned_quantity > 0
order by return_rate_percentage desc;

#Product Performance Dashboard
select 
oi.product_id,
sum(oi.quantity) as total_quantity_sold,
sum(oi.quantity * oi.unit_price) as total_revenue,
count( distinct o.customer_id) as unique_customers,
sum(oi.quantity * oi.unit_price)/ sum(oi.quantity) as avg_selling_price
from orders o 
join order_items oi on o.order_id = oi.order_item_id
group by oi.product_id
order by total_revenue;

#Frequently Bought Together Products 
select 
p1.product_name as product_1,
p2.product_name as product_2,
count(*) as times_brought_together
from order_items oi1
join order_items oi2
on oi1.order_id=oi2.order_id
and oi1.product_id<oi2.product_id
join products p1
on oi1.product_id=p1.product_id
join products p2
on oi2.product_id=p2.product_id
group by 
p1.product_name,
p2.product_name
order by times_brought_together desc;
 
#Slow-Moving Products (Last 3 Months) 
select 
p.product_id,
p.product_name,
sum(oi.quantity) as total_quantity_sold
from orders o
join order_items oi
on o.order_id=oi.order_item_id
join products p
on oi.product_id=p.product_id
where o.order_date > DATE_SUB(CURRENT_DATE, INTERVAL 90 DAY)
group by p.product_id,
p.product_name
order by total_quantity_sold desc;

SELECT 
    t.month,
    t.target_amount,
    SUM(o.order_amount) AS actual_sales,
    
    SUM(o.order_amount) - t.target_amount AS variance,
    
    ROUND(
        (SUM(o.order_amount) / t.target_amount) * 100, 
        2
    ) AS achievement_percentage,
    
    CASE 
        WHEN SUM(o.order_amount) >= t.target_amount 
        THEN 'Target Met'
        ELSE 'Target Not Met'
    END AS target_status

FROM sales_targets t
LEFT JOIN orders o
    ON MONTH(o.order_date) = t.month
    AND YEAR(o.order_date) = t.year

GROUP BY 
    t.month, 
    t.target_amount

ORDER BY t.month;

 
 
 

 













 






