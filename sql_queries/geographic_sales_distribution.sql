-- Geographical breakdown of sales (Countries and Cities)
SELECT 
    u.country,
    u.city,
    SUM(oi.sale_price) AS total_revenue,
    COUNT(DISTINCT oi.order_id) AS total_orders
FROM `bigquery-public-data.thelook_ecommerce.order_items` AS oi
JOIN `bigquery-public-data.thelook_ecommerce.users` AS u 
    ON oi.user_id = u.id
WHERE oi.status NOT IN ('Cancelled', 'Returned')
GROUP BY 1, 2
ORDER BY total_revenue DESC
