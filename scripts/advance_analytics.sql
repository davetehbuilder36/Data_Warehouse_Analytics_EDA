USE DataWarehouseAnalytics;

-- Advance SQL Analysis;
-----------------------------------------------------------------------------------

-- Change over time trends
SELECT 
year(order_date) AS order_year,
MONTH(order_date) AS order_month,
SUM(sales_amount) AS total_sales,
COUNT(DISTINCT customer_key) AS total_customers,
SUM(quantity) as total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY year(order_date), MONTH(order_date)
ORDER BY year(order_date), MONTH(order_date)

----------------------------------------------------------------------------

-- Comulitive Analysis
SELECT 
order_date,
total_sales,
SUM(total_sales) OVER (ORDER BY order_date) as running_total_sales,
avg(total_sales) OVER (ORDER BY order_date) as running_avg_sales
FROM
	(SELECT
	DATETRUNC(YEAR, order_date) as order_date,
	sum(sales_amount) as total_sales,
	avg(sales_amount) as avarge_sales
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(YEAR, order_date)
	)t;

--------------------------------------------------------------------------------------------------

-- Perfomance Analysis

/* Analyze the yearly performance of products by comparing their sales
to both the average sales performance of the product and the previous year's sales */

WITH yearly_product_sales AS
(SELECT
	YEAR(f.order_date) as order_year,
	p.product_name,
	SUM(f.sales_amount) as current_sales
FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON f.product_key = p.product_key
WHERE YEAR(f.order_date) IS NOT NULL
GROUP BY YEAR(f.order_date), p.product_name
)

SELECT
order_year,
product_name,
current_sales,
avg(current_sales) OVER (PARTITION BY product_name) avg_sales,
current_sales - avg(current_sales) OVER (PARTITION BY product_name) as diff_sales,
CASE
	WHEN current_sales - avg(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above avg'
	WHEN current_sales - avg(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Belove avg'
	ELSE 'avg'
END avg_change,
-- year - over - year analysis
LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) py_sales,
current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS diff_py,
CASE
	WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
	WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
	ELSE 'no change'
END avg_change
FROM yearly_product_sales
ORDER BY  product_name, order_year

------------------------------------------------------------------------------------------------------------------
-- Part-to-whole analysis

-- Which categories contribute the most to overall sales?
WITH category_sales AS(
SELECT
SUM(s.sales_amount) AS total_sales,
p.category
FROM  [gold].[fact_sales] s
LEFT JOIN [gold].[dim_products] p
ON s.product_key = p.product_key
GROUP BY category)

SELECT 
total_sales,
category,
CONCAT(ROUND((CAST(total_sales AS FLOAT) / (SUM(total_sales) OVER())) * 100, 2), '%') AS category_percentage
FROM category_sales
ORDER BY total_sales DESC

----------------------------------------------------------------------------------------------------------------
-- Data Segmentation

/* Segment products into cost ranges and
count how many products fall into each segment */

WITH product_segments AS (
    SELECT
        product_key,
        product_name,
        cost,
        CASE
            WHEN cost < 100 THEN 'Below 100'
            WHEN cost BETWEEN 100 AND 500 THEN '100-500'
            WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
            ELSE 'Above 1000'
        END AS cost_range
    FROM gold.dim_products
)

SELECT
    cost_range,
    COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC;

/* Group customers into three segments based on their spending behavior:
   - VIP: Customers with at least 12 months of history and spending more than  5,000.
   - Regular: Customers with at least 12 months of history but spending  5,000 or less.
   - New: Customers with a lifespan less than 12 months.
   And find the total number of customers by each group
*/

WITH customer_lifespan AS(
SELECT
c.customer_key,
SUM(s.sales_amount) AS total_sales,
MIN(s.order_date) AS first_order,
MAX(s.order_date) AS last_order,
DATEDIFF(MONTH, MIN(s.order_date),MAX(s.order_date)) as lifespan
FROM [gold].[fact_sales] s
LEFT JOIN gold.dim_customers c
ON s.customer_key = c.customer_key
GROUP BY c.customer_key)

SELECT
customer_segments,
count(customer_key) as total_customers
FROM
(SELECT 
customer_key,

CASE WHEN total_sales > 5000 AND lifespan >= 12 THEN 'VIP'
	 WHEN total_sales <= 5000 AND lifespan >= 12 THEN 'regular'
	 else 'new'
END customer_segments
FROM customer_lifespan) t
GROUP BY customer_segments
ORDER BY total_customers DESC
