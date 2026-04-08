WITH customer_month AS (
    SELECT DISTINCT
        customer_key,
        DATE_TRUNC('month', order_date) AS month
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
),

retention_flag AS (
    SELECT
        customer_key,
        month,
        LAG(month) OVER (
            PARTITION BY customer_key
            ORDER BY month
        ) AS prev_month
    FROM customer_month
),

monthly_metrics AS (
    SELECT
        month,
        COUNT(DISTINCT customer_key) AS active_customers,
        COUNT(DISTINCT CASE
            WHEN prev_month = month - INTERVAL '1 month'
            THEN customer_key
        END) AS retained_customers
    FROM retention_flag
    GROUP BY month
)

SELECT
    month,
    active_customers,
    retained_customers,
    ROUND(
        retained_customers * 100.0
        / NULLIF(LAG(active_customers) OVER (ORDER BY month), 0),
        2
    ) AS retention_rate
FROM monthly_metrics
ORDER BY month;