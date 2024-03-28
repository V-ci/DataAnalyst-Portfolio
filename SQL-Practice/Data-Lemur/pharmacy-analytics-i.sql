SELECT 
  drug,
  total_sales - cogs AS total_profit
FROM pharmacy_sales
ORDER by total_profit DESC
LIMIT 3;
