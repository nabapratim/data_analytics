/*
===============================================================================
Part-to-Whole Analaysis
===============================================================================
Purpose:
    - To analyze how an individual part is performing comparing to overall.
    - For benchmarking and identifying high-performing entities.
===============================================================================
*/
-- Which categories contribute the most to overall sales?
WITH sales_category AS(
SELECT 
	p.category AS category,
	SUM(f.sales_amount) AS total_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY p.category
)
SELECT 
	category,
	total_sales,
	SUM(total_sales) OVER() AS overall_sales,
	ROUND((total_sales/SUM(total_sales) OVER())*100, 2) AS percentage_of_total
FROM sales_category
