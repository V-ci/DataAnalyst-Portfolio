SELECT 
  sender_id,
  COUNT(sent_date) AS num_sent
FROM messages
WHERE sent_date BETWEEN '2022-08-01' AND '2022-08-31'
GROUP BY sender_id 
ORDER BY num_sent DESC
LIMIT 2;
