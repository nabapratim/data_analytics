/*=======================================================================================
COMMULATIVE ANALYSIS
=======================================================================================*/

/*---------------------------------------------------------------------------------------
***Helps understand whether the is business growing or declining***
---------------------------------------------------------------------------------------*/

-- Calculate the total sales per month 
-- and the running total of sales over time 
-- and the running average over time
WITH monthly_sale AS(
SELECT 
	date_trunc('month', order_date) AS month,
	SUM(sales_amount) AS total_sales
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY 
	date_trunc('month', order_date)
), running_total AS(
SELECT
   month,
   total_sales,
   SUM(total_sales) OVER(ORDER BY month) AS total_running_total
FROM monthly_sale
)
SELECT
   month,
   total_sales,
   total_running_total,
   ROUND(AVG(total_sales) OVER(ORDER BY month), 2) AS moving_average
FROM running_total;