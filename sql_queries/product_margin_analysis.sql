-- Profitability analysis by category
SELECT 
    p.category,
    SUM(oi.sale_price) AS total_revenue,
    SUM(oi.sale_price - p.cost) AS gross_profit,
    ROUND((SUM(oi.sale_price - p.cost) / SUM(oi.sale_price)) * 100, 2) AS margin_percent
FROM `bigquery-public-data.thelook_ecommerce.order_items` AS oi
JOIN `bigquery-public-data.thelook_ecommerce.products` AS p ON oi.product_id = p.id
WHERE oi.status NOT IN ('Cancelled', 'Returned')
GROUP BY 1
ORDER BY total_revenue DESC
