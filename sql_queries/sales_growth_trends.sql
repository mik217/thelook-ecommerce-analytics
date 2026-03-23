-- Analysis of income trends and growth rates (MoM Growth)
WITH monthly_sales AS (
  SELECT
    DATE_TRUNC(DATE(created_at), MONTH) AS month,
    SUM(sale_price) AS revenue
  FROM `bigquery-public-data.thelook_ecommerce.order_items`
  WHERE status NOT IN ('Cancelled', 'Returned')
    AND created_at < '2024-01-01' -- We trim off the incomplete year to ensure the trend is clear
  GROUP BY 1
)
SELECT
  month,
  ROUND(revenue, 2) AS current_month_revenue,
  ROUND(LAG(revenue) OVER (ORDER BY month), 2) AS prev_month_revenue,
  ROUND((revenue - LAG(revenue) OVER (ORDER BY month)) / LAG(revenue) OVER (ORDER BY month) * 100, 2) AS growth_percent
FROM monthly_sales
ORDER BY month ASC
