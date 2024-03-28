WITH total_cte AS (
SELECT 
  SUM(order_occurrences * item_count::DECIMAL) AS total_items,
  SUM(order_occurrences) AS total_orders
FROM items_per_order)

SELECT 
  ROUND(total_items / total_orders, 1) AS mean
FROM total_cte;
