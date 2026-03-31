/*
SQL Advanced Data Analytics Project

Skills used: Complex Queries, Window Functions, CTE, Subqueries, Reports

*/

USE eda_portfolioproject;

--
--  1. Change-Over-Time Analysis (Trends)
-- 

-- Changes over Year: A high-level overview insights that helps with strategic decision making (Performance by each year)
SELECT 
	YEAR(order_date) AS order_year,
	SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM fact_sales
WHERE order_date <> ''
GROUP BY 1
ORDER BY 1;

-- Changes over Month: Detailed insight to discover seasonality
SELECT 
	MONTH(order_date) AS order_month,
	SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM fact_sales
WHERE order_date <> ''
GROUP BY 1
ORDER BY 1;

SELECT 
	YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
	SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM fact_sales
WHERE order_date <> ''
GROUP BY 1,2
ORDER BY 1,2;


SELECT 
    DATE_FORMAT(order_date, '%Y-%m-01') AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM fact_sales
WHERE order_date <> ''
GROUP BY 1
ORDER BY 1;

SELECT 
    DATE_FORMAT(order_date, '%Y-%b') AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM fact_sales
WHERE order_date <> ''
GROUP BY 1
ORDER BY 1;


--
-- 2. Cumulative Analysis
--

-- Calculate the total sales per month 
SELECT 
    DATE_FORMAT(order_date, '%Y-%m-01') AS order_date,
    SUM(sales_amount) AS total_sales
FROM fact_sales
WHERE order_date <> ''
GROUP BY 1
ORDER BY 1;

-- Calculate the running total of sales over time.
SELECT
	order_date,
    total_sales,
	SUM(total_sales) OVER (PARTITION BY order_date ORDER BY order_date) AS running_total_sales
FROM (
SELECT 
    DATE_FORMAT(order_date, '%Y-%m-01') AS order_date,
    SUM(sales_amount) AS total_sales
FROM fact_sales
WHERE order_date <> ''
GROUP BY 1
ORDER BY 1) t;


-- Calculate the moving average of price over time
SELECT
	order_date,
    total_sales,
	SUM(total_sales) OVER (PARTITION BY order_date ORDER BY order_date) AS running_total_sales,
    FORMAT(AVG(avg_price) OVER (PARTITION BY order_date ORDER BY order_date),2) AS moving_avg_price
FROM (
SELECT 
    DATE_FORMAT(order_date, '%Y-01-01') AS order_date,
    SUM(sales_amount) AS total_sales,
    AVG(price) AS avg_price    
FROM fact_sales
WHERE order_date <> ''
GROUP BY 1
ORDER BY 1) t;


--
-- Performance Analysis
-- 

-- Current Sales vs Average Sales Performance 
WITH yearly_product_sales AS (
SELECT
	YEAR(f.order_date) AS order_year,
    p.product_name,
    SUM(f.sales_amount) AS current_sales
FROM fact_sales f
LEFT JOIN dim_products p
	ON f.product_key = p.product_key
WHERE order_date <> ''
GROUP BY 1,2
ORDER BY 1 )
SELECT 
	order_year,
    product_name,
    current_sales,
    FORMAT(AVG(current_sales) OVER (PARTITION BY product_name),0) AS avg_sales,
    FORMAT(current_sales - AVG(current_sales ) OVER (PARTITION BY product_name),0) AS diff_avg,
    CASE WHEN FORMAT(current_sales - AVG(current_sales ) OVER (PARTITION BY product_name),0) > 0 THEN 'Above Avg'
         WHEN FORMAT(current_sales - AVG(current_sales ) OVER (PARTITION BY product_name),0) < 0 THEN 'Below Avg'
         ELSE 'Avg'
	END avg_change
FROM yearly_product_sales
ORDER BY 2,1;


-- Current Sales vs Average Sales  vs Previous Year Sales Performance [Year-Over-Year Analysis]
WITH yearly_product_sales AS (
SELECT
	YEAR(f.order_date) AS order_year,
    p.product_name,
    SUM(f.sales_amount) AS current_sales
FROM fact_sales f
LEFT JOIN dim_products p
	ON f.product_key = p.product_key
WHERE order_date <> ''
GROUP BY 1,2
ORDER BY 1 )
SELECT 
	order_year,
    product_name,
    current_sales,
    FORMAT(AVG(current_sales) OVER (PARTITION BY product_name),0) AS avg_sales,
    FORMAT(current_sales - AVG(current_sales ) OVER (PARTITION BY product_name),0) AS diff_avg,
    CASE WHEN FORMAT(current_sales - AVG(current_sales ) OVER (PARTITION BY product_name),0) > 0 THEN 'Above Avg'
         WHEN FORMAT(current_sales - AVG(current_sales ) OVER (PARTITION BY product_name),0) < 0 THEN 'Below Avg'
         ELSE 'Avg'
	END avg_change,
    LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS py_sales,
    FORMAT(current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year),0) AS diff_py,
	CASE WHEN FORMAT(current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year),0) > 0 THEN 'Increase'
         WHEN FORMAT(current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year),0) < 0 THEN 'Decrease'
         ELSE 'No Change'
	END py_change
FROM yearly_product_sales
ORDER BY 2,1;


--
-- 3. Proportional Analysis (Part-to-Whole)
-- 

-- Which categories contribute the most to overall sales
SELECT * FROM dim_products;

WITH category_sales AS (
SELECT 
	p.category,
    SUM(f.sales_amount) AS total_sales
FROM fact_sales f
LEFT JOIN dim_products p
	ON f.product_key = p.product_key
GROUP BY 1)

SELECT 
	category,
    total_sales,
    SUM(total_sales) OVER() AS overall_sales,
    CONCAT(ROUND((total_sales / SUM(total_sales) OVER()) * 100,2), '%') AS percent_of_total
FROM category_sales
ORDER BY 2 DESC;


-- Which sub-categories contribute the most to overall sales
WITH subcategory_sales AS (
SELECT 
	p.subcategory,
    SUM(f.sales_amount) AS total_sales    
FROM fact_sales f
LEFT JOIN dim_products p
	ON f.product_key = p.product_key
GROUP BY 1)

SELECT
	subcategory,
    total_sales,
    SUM(total_sales) OVER() AS overall_sales,
    CONCAT(ROUND((total_sales / SUM(total_sales) OVER())*100,2),'%') AS percent_cntr
FROM subcategory_sales
ORDER BY 2 DESC;


--
-- 5. Data Segmentation [CASE WHEN STATEMENT]
--

-- Segment products into cost ranges and count how many products fall into each segment
SELECT * FROM dim_products;

WITH product_segments AS (
SELECT 
	product_key,
    product_name,
    cost,
    CASE WHEN cost < 100 THEN 'Below 100'
		 WHEN cost BETWEEN 100 AND 500 THEN '100-500'
         WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
         ELSE 'Above 1000'
	END cost_range
FROM dim_products)

SELECT 
	cost_range,
    COUNT(product_key) AS total_products
FROM product_segments
GROUP BY 1
ORDER BY 2 DESC;

-- Group customers into three segments based on their spending behavior.
/*
-- VIP: at least 12 months of history and spending more than €5,000. 
-- Regular: at least 12 months of history but spending €5,000 or less.
-- New: lifespan less than 12 months. 
AND find the total number of customers by each group*/

WITH customer_spending AS (
SELECT 
	c.customer_key,
    SUM(f.sales_amount) AS total_spending,
    MIN(f.order_date) AS first_order,
    MAX(f.order_date) AS last_order,
    TIMESTAMPDIFF(month, MIN(f.order_date), MAX(f.order_date)) AS lifespan
FROM fact_sales f 
LEFT JOIN dim_customers c
	ON f.customer_key = c.customer_key
GROUP BY 1)

SELECT 
	customer_segment,
    COUNT(customer_key) AS total_customers
FROM (
SELECT 
	customer_key,
    lifespan,
    CASE WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
		 WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
         ELSE 'New'
	END customer_segment    
FROM customer_spending ) t
GROUP BY 1
ORDER BY 2 DESC;
   
   
--
-- 6. Customer Reports 
--

/*
Purpose: 
-	This report consolidates key customer metrics and behaviors 
Highlights: 
1.	Gathers essentials fields such as names, ages and transaction details 
2.	Segment customers into categories (VIP, Regular, New) and age groups.
3.	Aggregates customer-level metrics:
-	total orders 
-	total sales 
-	total quantity purchased 
-	total products 
-	lifespan (in months)
4.	Calculates valuable KPIs: 
-	Recency (months since last order)
-	Average order value
-	Average monthly spend
 
*/

-- Step 1: Gathers essentials fields such as names, ages and transaction details 
SELECT 
	f.order_number,
    f.product_key,
    f.order_date,
    f.sales_amount,
    f.quantity,
    c.customer_key,
    c.customer_number,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    timestampdiff(year, c.birthdate, NOW()) AS age
 FROM fact_sales f
 LEFT JOIN dim_customers c
	ON f.customer_key = c.customer_key
WHERE order_date <> '';


-- Step 2: Customer Aggregations: Summarizes key metrics at the customer level
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
    timestampdiff(year, c.birthdate, NOW()) AS age
 FROM fact_sales f
 LEFT JOIN dim_customers c
	ON f.customer_key = c.customer_key
WHERE order_date <> '')

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
	TIMESTAMPDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
FROM base_query 
-- WHERE customer_key = 7
GROUP BY 1,2,3,4;


-- Step 3: Final Result
CREATE VIEW report_customers AS 
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
    timestampdiff(year, c.birthdate, NOW()) AS age
 FROM fact_sales f
 LEFT JOIN dim_customers c
	ON f.customer_key = c.customer_key
WHERE order_date <> '')

, customer_aggregation AS (
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
	TIMESTAMPDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
FROM base_query 
-- WHERE customer_key = 7
GROUP BY 1,2,3,4)

SELECT
	customer_key,
    customer_number,
    customer_name,
	age,
    CASE WHEN age < 20 THEN 'Under 20'
         WHEN age between 20 and 29 THEN '20-29'
         WHEN age between 30 and 39 THEN '30-39'
         WHEN age between 40 and 49 THEN '40-49'
		ELSE '50 and above'
    END AS age_group,
	CASE WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
		 WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
         ELSE 'New'
	END customer_segment, 
    total_orders,
	total_sales,
	total_quantity,
	total_products,
	last_order_date,
    TIMESTAMPDIFF(month,last_order_date, NOW()) AS recency,
	lifespan,
    
    -- Compute average order value (AVO)
    CASE WHEN total_sales = 0 THEN 0
		ELSE total_sales / total_orders 
	END AS avg_order_value,
    
   -- Compute average monthly spend
   CASE WHEN lifespan = 0 THEN total_sales
		ELSE total_sales / lifespan
	END AS avg_monthly_spend
    
FROM customer_aggregation;



 SELECT 
	customer_segment,
    COUNT(customer_name) AS total_customers,
    SUM(total_sales) total_sales
 FROM report_customers
 GROUP BY 1;



/*
Product Report: Create an SQL VIEW to provide Product Insights

Purpose: 
-	This report consolidates key product metrics and behaviors 
Highlights: 
1.	Gathers essentials fields such as product name, category, subcategory and cost. 
2.	Segment products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
3.	Aggregates product-level metrics:
-	total orders 
-	total sales 
-	total quantity sold
-	total customers (unique)
-	lifespan (in months)
4.	Calculates valuable KPIs: 
-	Recency (months since last sale)
-	Average order revenue (AOR)
-	Average monthly revenue
 
*/
SELECT * FROM dim_products;


CREATE VIEW report_products AS 
WITH base_query AS (
/*-----------------------------------------------------------------------
1) Base Query: Retrieves core columns from fact_sales and dim_products
--------------------------------------------------------------------------*/
SELECT 
	f.order_number,
    f.order_date,
    f.customer_key,
    f.sales_amount,
    f.quantity,
	p.product_key,
	p.product_name,
    p.category,
    p.subcategory,
    p.cost
 FROM fact_sales f
 LEFT JOIN dim_products p
	ON f.product_key = p.product_key
WHERE order_date <> '') 

, product_aggregation AS (
/*-----------------------------------------------------------------------
2) Product Aggregations: Summarizes key metrics at the product level
--------------------------------------------------------------------------*/
SELECT 
	product_key,
    product_name,
    category,
    subcategory,
    cost,
    COUNT(DISTINCT order_number) AS total_orders,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity_sold,
    ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF (quantity,0)),1) AS avg_selling_price,
    COUNT(DISTINCT customer_key) AS total_customers,
    MAX(order_date) AS last_order_date,
	TIMESTAMPDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
FROM base_query 
GROUP BY 1,2,3,4,5)

/*-----------------------------------------------------------------------
3) Final Query : Combine all products results into one output
--------------------------------------------------------------------------*/
SELECT 
	product_key,
    product_name,
    category,
    subcategory,
    cost,
    last_order_date,
    TIMESTAMPDIFF(month,last_order_date, NOW()) AS recency,
    CASE WHEN total_sales > 50000 THEN 'High-performer'
		 WHEN total_sales >= 10000 THEN 'Mid-Range'
         ELSE 'Low-Performer'
	END AS product_segment,
    lifespan,
	total_orders,
	total_sales,
	total_quantity_sold,
	total_customers,
	avg_selling_price,
	CASE WHEN total_orders = 0 THEN 0
		ELSE total_sales / total_orders
	END AS avg_order_revenue,
    CASE WHEN lifespan = 0 THEN total_sales
		ELSE total_sales / total_orders
	END AS avg_monthly_revenue
FROM product_aggregation;


SELECT
*
FROM report_products;










