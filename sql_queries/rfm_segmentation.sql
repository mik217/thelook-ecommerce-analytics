-- RFM-customer segmentation
WITH user_data AS (
  SELECT
    user_id,
    DATE_DIFF(DATE('2024-01-01'), DATE(MAX(created_at)), DAY) AS recency,
    COUNT(DISTINCT order_id) AS frequency,
    SUM(sale_price) AS monetary
  FROM `bigquery-public-data.thelook_ecommerce.order_items`
  WHERE status NOT IN ('Cancelled', 'Returned')
  GROUP BY 1
),
scores AS (
  SELECT *,
    NTILE(4) OVER (ORDER BY recency DESC) AS r,
    NTILE(4) OVER (ORDER BY frequency ASC) AS f
  FROM user_data
)
SELECT *,
  CASE 
    WHEN r >= 3 AND f >= 3 THEN 'Champions'
    WHEN r <= 2 AND f >= 3 THEN 'At Risk'
    WHEN r >= 3 AND f <= 2 THEN 'New / Potential'
    ELSE 'Lost'
  END AS segment
FROM scores
