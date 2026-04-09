-----------------------------------------------------------------------------------------------------------------
-------------------------------------------magnitude_analysis----------------------------------------------------
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
-------------------------------------------------------------------------------------------