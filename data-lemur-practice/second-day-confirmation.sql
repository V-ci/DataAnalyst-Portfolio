SELECT 
  user_id
FROM emails e
JOIN texts t
 USING(email_id)
WHERE signup_action = 'Confirmed' AND t.action_date = e.signup_date + INTERVAL '1 day';
