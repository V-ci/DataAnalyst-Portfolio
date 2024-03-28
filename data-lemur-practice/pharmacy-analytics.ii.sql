SELECT 
  manufacturer,
  COUNT(drug),
  ABS(SUM(total_sales - cogs)) AS total_loses
FROM pharmacy_sales
WHERE total_sales - cogs <= 0
GROUP BY manufacturer
ORDER BY total_loses DESC;
