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