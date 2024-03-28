WITH CTE AS (
SELECT abr.age_bucket,
  SUM(act.time_spent) FILTER (WHERE act.activity_type = 'send') AS time_send,
  SUM(act.time_spent) FILTER (WHERE act.activity_type = 'open') AS time_open
FROM activities act
INNER JOIN age_breakdown abr
ON act.user_id = abr.user_id
WHERE act.activity_type IN ('send', 'open')
GROUP BY abr.age_bucket)

SELECT age_bucket, 
  ROUND(time_send / (time_send + time_open)*100.0, 2) AS percentage_sending,
  ROUND(time_open / (time_send + time_open)*100.0, 2) AS percentage_opening
FROM CTE
GROUP BY age_bucket, cte.time_send, cte.time_open;
