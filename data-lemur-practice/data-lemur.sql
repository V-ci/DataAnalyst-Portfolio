SELECT 
  tweets_per_user AS tweet_bucket,
  count(user_id) AS users_num
  FROM (
  SELECT 
  user_id,
  count(tweet_id) AS tweets_per_user
FROM tweets
WHERE tweet_date BETWEEN '2022-01-01' AND '2022-12-31'
GROUP BY user_id) AS total_tweets
GROUP BY tweet_bucket;

SELECT 
  candidate_id
FROM candidates
WHERE skill IN ('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(skill) = 3
ORDER BY candidate_id;

SELECT page_id
FROM pages p
LEFT JOIN page_likes pl 
  USING (page_id)
WHERE liked_date IS NULL 
ORDER BY page_id ASC;

SELECT 
  part,
  assembly_step
FROM parts_assembly
WHERE finish_date IS NULL;

SELECT
  SUM (CASE WHEN device_type = 'laptop' THEN 1 ELSE 0 END) AS laptop_views,
  SUM (CASE WHEN device_type IN ('tablet', 'phone') THEN 1 ELSE 0 END) AS mobile_views
FROM viewership;

SELECT 
  user_id,
  MAX(post_date::DATE) - MIN(post_date::DATE) AS date_diff
FROM posts
WHERE DATE_PART ('year', post_date::DATE) = 2021
GROUP BY user_id
HAVING COUNT(post_id) > 1;

SELECT 
  sender_id,
  COUNT(sent_date) AS num_sent
FROM messages
WHERE sent_date BETWEEN '2022-08-01' AND '2022-08-31'
GROUP BY sender_id 
ORDER BY num_sent DESC
LIMIT 2;

SELECT 
  COUNT(DISTINCT company_id) AS duplicate_companies
FROM (
SELECT 
  company_id,
  COUNT(job_id) AS job_count
FROM job_listings
GROUP BY company_id, title, description
) AS duplicate_count
WHERE job_count > 1;

SELECT 
  u.city,
  COUNT(t.order_id) AS total_orders
FROM trades t
JOIN users u 
  ON t.user_id = u.user_id
WHERE t.status = 'Completed'
GROUP BY  u.city
ORDER BY total_orders DESC
LIMIT 3;

SELECT 
  EXTRACT(MONTH FROM submit_date) AS mth,
  product_id,
  ROUND(AVG(stars),2) AS avg_stars 
FROM reviews
GROUP BY mth, product_id
ORDER BY mth, product_id;

SELECT 
  app_id,
  ROUND(100.0 * 
  COUNT(CASE WHEN event_type = 'click' THEN 1 ELSE NULL END) /
  COUNT(CASE WHEN event_type = 'impression' THEN 1 ELSE NULL END), 2) AS ctr
FROM events
WHERE timestamp BETWEEN '2022-01-01' AND '2022-12-31'
GROUP BY app_id;

SELECT 
  user_id
FROM emails e
JOIN texts t
 USING(email_id)
WHERE signup_action = 'Confirmed' AND t.action_date = e.signup_date + INTERVAL '1 day';

SELECT 
  DISTINCT(card_name),
  MAX(issued_amount) - MIN (issued_amount) AS difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY difference DESC;

WITH total_cte AS (
SELECT 
  SUM(order_occurrences * item_count::DECIMAL) AS total_items,
  SUM(order_occurrences) AS total_orders
FROM items_per_order)

SELECT 
  ROUND(total_items / total_orders, 1) AS mean
FROM total_cte;

SELECT 
  drug,
  total_sales - cogs AS total_profit
FROM pharmacy_sales
ORDER by total_profit DESC
LIMIT 3;


SELECT 
  manufacturer,
  COUNT(drug),
  ABS(SUM(total_sales - cogs)) AS total_loses
FROM pharmacy_sales
WHERE total_sales - cogs <= 0
GROUP BY manufacturer
ORDER BY total_loses DESC;

SELECT 
  manufacturer,
  CONCAT('$', ROUND(SUM(total_sales) / 1000000), ' million') AS sale_mil
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY SUM(total_sales) DESC, manufacturer;

WITH trans_num AS (
    SELECT user_id, 
        spend, transaction_date, ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY transaction_date) AS row_num
FROM transactions)
SELECT user_id, spend, transaction_date
FROM trans_num
WHERE row_num = 3;

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




