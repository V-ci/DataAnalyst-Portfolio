SELECT page_id
FROM pages p
LEFT JOIN page_likes pl 
  USING (page_id)
WHERE liked_date IS NULL 
ORDER BY page_id ASC;
