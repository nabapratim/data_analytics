/*============================================================
-- New_vs_Returning
-- PURPOSE:
     Compare business value of New vs Returning customers
     Supports retention vs acquisition strategy
============================================================*/

WITH first_purchase AS (
    SELECT
        customer_key,
        MIN(order_date) AS first_order_date
    FROM gold.fact_sales
    GROUP BY customer_key
),

orders_enriched AS (
    SELECT
        f.customer_key,
        f.order_number,
        f.order_date,
        f.quantity * f.price AS revenue,
        CASE
            WHEN f.order_date = fp.first_order_date THEN 'New'
            ELSE 'Returning'
        END AS customer_type
    FROM gold.fact_sales f
    JOIN first_purchase fp
        ON f.customer_key = fp.customer_key
),

total_counts AS (
    SELECT
        customer_type,
        COUNT(DISTINCT customer_key) AS customers,
        COUNT(DISTINCT order_number) AS orders,
        SUM(revenue) AS total_revenue
    FROM orders_enriched
    GROUP BY customer_type
)

SELECT
    customer_type,
    customers,
    orders,
    total_revenue,
    ROUND(total_revenue / NULLIF(orders, 0), 2) AS aov,
    ROUND(orders::numeric / NULLIF(customers, 0), 2) AS orders_per_customer,
    ROUND(total_revenue / NULLIF(customers, 0), 2) AS revenue_per_customer
FROM total_counts
ORDER BY customer_type;