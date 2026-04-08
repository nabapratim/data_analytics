/*======================EDA(Exploratory Data Analysis)=========================*/
-----------------------------------------------------------------------------------------
-------------------------database exploration-----------------------------
-----------table exploration-----------
SELECT 
  table_name 
FROM information_schema.tables 
WHERE table_schema='gold';

----------column exploration-----------
SELECT 
 *
FROM information_schema.columns
WHERE  table_schema = 'gold' AND table_name = 'dim_customers';
--------------
SELECT 
 *
FROM information_schema.columns
WHERE  table_schema = 'gold' AND table_name = 'dim_products';
--------------
SELECT 
 *
FROM information_schema.columns
WHERE  table_schema = 'gold' AND table_name = 'fact_sales';
--------------------------------------------------------------------------
------------------------dimension exploration-----------------------------
SELECT DISTINCT
 country
FROM gold.dim_customers;
--------------
SELECT DISTINCT
  category,
  subcategory,
  product_name
FROM gold.dim_products
ORDER BY category;
--------------------------------------------------------------------------
------------------------date exploration----------------------------------
SELECT      -------range of the dataset--------
  first_order,
  latest_order,
  order_range_days,
  (EXTRACT(YEAR FROM latest_order)-EXTRACT(YEAR FROM first_order)) * 12 
  +(EXTRACT(MONTH FROM latest_order)-EXTRACT(MONTH FROM first_order)) AS order_range_year 
FROM(
  SELECT 
	 MIN(order_date) AS first_order,
	 MAX(order_date) AS latest_order,
	 MAX(order_date)-MIN(order_date) AS order_range_days
  FROM gold.fact_sales);
---------------------------
SELECT
  MIN(shipping_date - order_date) AS min_shipping_time,
  MAX(shipping_date - order_date) AS max_shipping_time
FROM gold.fact_sales;
---------------------------
SELECT
   MIN(birthdate) AS oldest_customer,
   AGE(CURRENT_DATE, MIN(birthdate)) AS oldest_age,
   MAX(birthdate) AS youngest_customer,
   AGE(CURRENT_DATE, MAX(birthdate)) AS youngest_age
FROM gold.dim_customers;
-----for age as integer-----
/*
SELECT
   MIN(birthdate) AS oldest_customer,
   EXTRACT(YEAR FROM AGE(CURRENT_DATE, MIN(birthdate)))::INT AS oldest_age,
   MAX(birthdate) AS youngest_customer,
   EXTRACT(YEAR FROM AGE(CURRENT_DATE, MAX(birthdate)))::INT AS youngest_age
FROM gold.dim_customers;
*/
----------------------------------------------------------------------------
---------------------------measure exploration------------------------------
---find total sales 
SELECT 'Total sales' as measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
----------
UNION ALL
----------
---find no. of items sold
SELECT 'Total sale quantity' as measure_name, SUM(quantity) AS measure_value FROM gold.fact_sales
----------
UNION ALL
----------
---average selling price
SELECT 'Average selling price' as measure_name, ROUND(AVG(price), 2) AS measure_value FROM gold.fact_sales
----------
UNION ALL
----------
---	total number of orders
SELECT 'Total number of orders' as measure_name, COUNT(DISTINCT order_number) AS measure_value FROM gold.fact_sales
----------
UNION ALL
----------
---total no. of customers
SELECT 'Total number of customers' as measure_name, COUNT(customer_id) AS measure_value FROM gold.dim_customers
----------
UNION ALL
----------
---total no. of products
SELECT 'Total number of products' as measure_name, COUNT(DISTINCT product_id) AS measure_value FROM gold.dim_products
----------
UNION ALL
----------
---total number of customer has placed order
SELECT 'Total customer who ordered' as measure_name, COUNT(DISTINCT customer_key) AS measure_value FROM gold.fact_sales;
-----------------------------------------------------------------------------------------------------------------
-------------------------------------------magnitude analysis----------------------------------------------------
---total customers by countries
SELECT 
  country,
  COUNT(customer_id) AS total_customer
FROM gold.dim_customers
GROUP BY country
ORDER BY COUNT(customer_id) DESC;
-------------------------------
---total customer by gender
SELECT 
  gender,
  COUNT(customer_id) AS total_customer
FROM gold.dim_customers
GROUP BY gender
ORDER BY COUNT(customer_id) DESC;
-------------------------------
---total products by category
SELECT 
  category,
  COUNT(DISTINCT product_id) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY COUNT(DISTINCT product_id) DESC;
--------------------------------
---average cost in each category
SELECT 
  category,
  ROUND(AVG(cost), 2) AS average_cost
FROM gold.dim_products
GROUP BY category
ORDER BY ROUND(AVG(cost), 2) DESC;
---------------------------------
---total revenue by category
SELECT
    p.category,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
GROUP BY p.category
ORDER BY total_revenue DESC;
---------------------------------
--- distribution of sold items across countries
SELECT
    c.country,
    SUM(f.quantity) AS total_sold_items
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY c.country
ORDER BY total_sold_items DESC;
----------------------------------------------------------------------------------
--------------------------ranking analysis----------------------------------------
/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

-- Which 5 products Generating the Highest Revenue?
SELECT *
FROM (
    SELECT
        p.product_name,
        SUM(f.sales_amount) AS total_revenue,
        RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) AS rank_products
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.product_name
) AS ranked_products
WHERE rank_products <= 5;

-- What are the 5 worst-performing products in terms of sales?
SELECT *
FROM (
    SELECT
        p.product_name,
        SUM(f.sales_amount) AS total_revenue,
        RANK() OVER (ORDER BY SUM(f.sales_amount) ASC) AS rank_products
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.product_name
) AS ranked_products
WHERE rank_products <= 5;

-- Find the top 10 customers who have generated the highest revenue
SELECT TOP 10
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_revenue DESC;

-- The 3 customers with the fewest orders placed
SELECT TOP 3
    c.customer_key,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
GROUP BY 
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_orders ;




