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
 