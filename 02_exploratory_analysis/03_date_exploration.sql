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