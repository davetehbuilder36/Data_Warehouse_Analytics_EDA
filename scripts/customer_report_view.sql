
/*
======================================================================
Customer Report
======================================================================

Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
    2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
        - total orders
        - total sales
        - total quantity purchased
        - total products
        - lifespan (in months)
    4. Calculates valuable KPIs:
        - recency (months since last order)
        - average order value
        - average monthly spend

======================================================================
*/
CREATE VIEW gold.report_customers AS
 -- 1. Gathers essential fields such as names, ages, and transaction details.
WITH base_query AS (
 SELECT
    f.order_number,
    f.product_key,
    f.order_date,
    f.sales_amount,
    f.quantity,
    c.customer_key,
    c.customer_number,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    DATEDIFF(year, c.birthdate, GETDATE()) AS age
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
WHERE order_date IS NOT NULL),
customer_aagregation as (
SELECT
    customer_key,
    customer_number,
    customer_name,
    age,
    COUNT(DISTINCT order_number) AS total_orders,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
    COUNT(DISTINCT product_key) AS total_products,
    MAX(order_date) AS last_order_date,
    DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
FROM base_query
WHERE age BETWEEN 18 AND 95
GROUP BY customer_key,
         customer_number,
         customer_name,
         age)
SELECT 
customer_key,
customer_number,
customer_name,
age,
CASE
    WHEN age BETWEEN 40 AND 49 THEN '40-49'
    WHEN age BETWEEN 50 AND 59 THEN '50-59'
    WHEN age BETWEEN 60 AND 69 THEN '60-69'
    WHEN age BETWEEN 70 AND 79 THEN '70-79'
    ELSE '80 and above'
END AS age_group,
total_orders,
total_sales,
CASE WHEN total_sales > 5000 AND lifespan >= 12 THEN 'vip'
	 WHEN total_sales <= 5000 AND lifespan >= 12 THEN 'regular'
	 else 'new'
END customer_segments,
last_order_date,
DATEDIFF(MONTH, last_order_date, GETDATE()) as recency,
total_quantity,
total_products,
lifespan,
--compute avarage order value (avo)
CASE WHEN total_quantity = 0 THEN 0 
     else total_sales / total_quantity 
END as avarage_sale,

-- compute avarage monthly spend
CASE WHEN lifespan  = 0 THEN total_sales
ELSE total_sales / lifespan 
END as avarage_monthly_spend
FROM customer_aagregation

--SELECT * FROM gold.report_customers
