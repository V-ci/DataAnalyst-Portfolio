SELECT 
  app_id,
  ROUND(100.0 * 
  COUNT(CASE WHEN event_type = 'click' THEN 1 ELSE NULL END) /
  COUNT(CASE WHEN event_type = 'impression' THEN 1 ELSE NULL END), 2) AS ctr
FROM events
WHERE timestamp BETWEEN '2022-01-01' AND '2022-12-31'
GROUP BY app_id;
