/* 
Data Cleaning and Data Exploration Project Portfolio

Skills used: ALTER, CREATE, RENAME, UNION, JOINS, CTE, Window Functions, Aggregate Functions, Converting Data Types

*/


-- renaming jansales columns
ALTER TABLE jansales RENAME COLUMN `Order ID` TO order_id;
ALTER TABLE jansales RENAME COLUMN `Product` TO product;
ALTER TABLE jansales RENAME COLUMN `Quantity Ordered` TO quantity_ordered;
ALTER TABLE jansales RENAME COLUMN `Price Each` TO price_each;
ALTER TABLE jansales RENAME COLUMN `Order Date` TO order_date;
ALTER TABLE jansales RENAME COLUMN `Purchase Address` TO purchase_address;

-- renaming febsales columns
ALTER TABLE febsales RENAME COLUMN `Order ID` TO order_id;
ALTER TABLE febsales RENAME COLUMN `Product` TO product;
ALTER TABLE febsales RENAME COLUMN `Quantity Ordered` TO quantity_ordered;
ALTER TABLE febsales RENAME COLUMN `Price Each` TO price_each;
ALTER TABLE febsales RENAME COLUMN `Order Date` TO order_date;
ALTER TABLE febsales RENAME COLUMN `Purchase Address` TO purchase_address;

-- renaming marsales columns
ALTER TABLE marsales RENAME COLUMN `Order ID` TO order_id;
ALTER TABLE marsales RENAME COLUMN `Product` TO product;
ALTER TABLE marsales RENAME COLUMN `Quantity Ordered` TO quantity_ordered;
ALTER TABLE marsales RENAME COLUMN `Price Each` TO price_each;
ALTER TABLE marsales RENAME COLUMN `Order Date` TO order_date;
ALTER TABLE marsales RENAME COLUMN `Purchase Address` TO purchase_address;

-- renaming aprsales columns
ALTER TABLE aprsales RENAME COLUMN `Order ID` TO order_id;
ALTER TABLE aprsales RENAME COLUMN `Product` TO product;
ALTER TABLE aprsales RENAME COLUMN `Quantity Ordered` TO quantity_ordered;
ALTER TABLE aprsales RENAME COLUMN `Price Each` TO price_each;
ALTER TABLE aprsales RENAME COLUMN `Order Date` TO order_date;
ALTER TABLE aprsales RENAME COLUMN `Purchase Address` TO purchase_address;

-- renaming maysales columns
ALTER TABLE maysales RENAME COLUMN `Order ID` TO order_id;
ALTER TABLE maysales RENAME COLUMN `Product` TO product;
ALTER TABLE maysales RENAME COLUMN `Quantity Ordered` TO quantity_ordered;
ALTER TABLE maysales RENAME COLUMN `Price Each` TO price_each;
ALTER TABLE maysales RENAME COLUMN `Order Date` TO order_date;
ALTER TABLE maysales RENAME COLUMN `Purchase Address` TO purchase_address;

-- renaming junesales columns
ALTER TABLE junesales RENAME COLUMN `Order ID` TO order_id;
ALTER TABLE junesales RENAME COLUMN `Product` TO product;
ALTER TABLE junesales RENAME COLUMN `Quantity Ordered` TO quantity_ordered;
ALTER TABLE junesales RENAME COLUMN `Price Each` TO price_each;
ALTER TABLE junesales RENAME COLUMN `Order Date` TO order_date;
ALTER TABLE junesales RENAME COLUMN `Purchase Address` TO purchase_address;

-- renaming julysales columns
ALTER TABLE julysales RENAME COLUMN `Order ID` TO order_id;
ALTER TABLE julysales RENAME COLUMN `Product` TO product;
ALTER TABLE julysales RENAME COLUMN `Quantity Ordered` TO quantity_ordered;
ALTER TABLE julysales RENAME COLUMN `Price Each` TO price_each;
ALTER TABLE julysales RENAME COLUMN `Order Date` TO order_date;
ALTER TABLE julysales RENAME COLUMN `Purchase Address` TO purchase_address;

-- renaming augsales columns
ALTER TABLE augsales RENAME COLUMN `Order ID` TO order_id;
ALTER TABLE augsales RENAME COLUMN `Product` TO product;
ALTER TABLE augsales RENAME COLUMN `Quantity Ordered` TO quantity_ordered;
ALTER TABLE augsales RENAME COLUMN `Price Each` TO price_each;
ALTER TABLE augsales RENAME COLUMN `Order Date` TO order_date;
ALTER TABLE augsales RENAME COLUMN `Purchase Address` TO purchase_address;

-- renaming septsales columns
ALTER TABLE septsales RENAME COLUMN `Order ID` TO order_id;
ALTER TABLE septsales RENAME COLUMN `Product` TO product;
ALTER TABLE septsales RENAME COLUMN `Quantity Ordered` TO quantity_ordered;
ALTER TABLE septsales RENAME COLUMN `Price Each` TO price_each;
ALTER TABLE septsales RENAME COLUMN `Order Date` TO order_date;
ALTER TABLE septsales RENAME COLUMN `Purchase Address` TO purchase_address;

-- renaming octsales columns 
ALTER TABLE octsales RENAME COLUMN `Order ID` TO order_id;
ALTER TABLE octsales RENAME COLUMN `Product` TO product;
ALTER TABLE octsales RENAME COLUMN `Quantity Ordered` TO quantity_ordered;
ALTER TABLE octsales RENAME COLUMN `Price Each` TO price_each;
ALTER TABLE octsales RENAME COLUMN `Order Date` TO order_date;
ALTER TABLE octsales RENAME COLUMN `Purchase Address` TO purchase_address;

-- renaming novsales columns
ALTER TABLE novsales RENAME COLUMN `Order ID` TO order_id;
ALTER TABLE novsales RENAME COLUMN `Product` TO product;
ALTER TABLE novsales RENAME COLUMN `Quantity Ordered` TO quantity_ordered;
ALTER TABLE novsales RENAME COLUMN `Price Each` TO price_each;
ALTER TABLE novsales RENAME COLUMN `Order Date` TO order_date;
ALTER TABLE novsales RENAME COLUMN `Purchase Address` TO purchase_address;


-- renaming decsales columns
ALTER TABLE decsales RENAME COLUMN `Order ID` TO order_id;
ALTER TABLE decsales RENAME COLUMN `Product` TO product;
ALTER TABLE decsales RENAME COLUMN `Quantity Ordered` TO quantity_ordered;
ALTER TABLE decsales RENAME COLUMN `Price Each` TO price_each;
ALTER TABLE decsales RENAME COLUMN `Order Date` TO order_date;
ALTER TABLE decsales RENAME COLUMN `Purchase Address` TO purchase_address;



-- cleaning aprsales table that had blank or space in the fields
DELETE FROM aprsales WHERE product= " " ;

-- cleaning aprsales table that had column header data in the fields
DELETE FROM aprsales WHERE product= "Product";

-- creating a new table using CREATE TABLE with January to December sales into one new table using UNION 

CREATE TABLE yearly_sales AS (
SELECT *  
FROM jansales
UNION ALL 
SELECT * 
FROM febsales 
UNION ALL 
SELECT *
FROM marsales 
UNION ALL 
SELECT *
FROM aprsales
UNION ALL
SELECT * 
FROM maysales 
UNION ALL
SELECT * 
FROM junesales 
UNION ALL 
SELECT * 
FROM julysales 
UNION ALL 
SELECT *
FROM augsales 
UNION ALL 
SELECT * 
FROM septsales
UNION ALL
SELECT * 
FROM octsales
UNION ALL 
SELECT * 
FROM novsales
UNION ALL 
SELECT * 
FROM decsales);

-- converting order_date from string to datetime type but needed to convert the format into a legal one as the original had no seconds only hr and min
UPDATE yearly_sales  SET order_date =
  DATE_FORMAT(STR_TO_DATE(order_date, '%m/%d/%Y %H:%i'),'%Y-%m-%d %H:%i:%s');

-- obtaining the total_prices for each transactions;
SELECT 
	product,
    quantity_ordered,
    order_date,
    MONTHNAME(order_date) AS monthdate,
    price_each,
    quantity_ordered * price_each AS total_price
FROM yearly_sales;

-- obtaining the average transaction prices each month;
WITH revenue AS (
SELECT 
	product,
    quantity_ordered,
    order_date,
    MONTHNAME(order_date) AS monthdate,
    price_each,
    quantity_ordered * price_each AS total_price
FROM yearly_sales)

SELECT 
	monthdate,
	ROUND(AVG(total_price),2) AS average_transactions
FROM revenue
GROUP BY monthdate;

-- total sales amount monthly
SELECT MONTHNAME(order_date) as monthdate, ROUND(SUM(quantity_ordered * price_each)) AS total_monthly_sales
FROM yearly_sales
GROUP BY monthdate;

-- average sales monthly
SELECT MONTHNAME(order_date) as monthdate, ROUND(AVG(quantity_ordered * price_each)) AS avg_monthly_sales
FROM yearly_sales
GROUP BY monthdate;

-- total item quantity of orders monthly
SELECT
	MONTHNAME(order_date) AS monthdate,
	SUM(quantity_ordered) AS total_items_ordered
FROM yearly_sales
GROUP BY monthdate;

-- finding out the time of the day (morning, afternoon or evening) most purchases were made

WITH temp AS (
SELECT 
	product,
    order_date,
CASE 
    WHEN CONVERT(order_date, TIME) >= '05:00:00' AND CONVERT(order_date, TIME) < '12:00:00'
    THEN 'Morning'
    WHEN CONVERT (order_date, TIME) >= '12:00:00' AND CONVERT(order_date, TIME) < '17:00:00' 
    THEN 'Afternoon'
    ELSE 'Evening'
END AS time_of_day

FROM yearly_sales)

SELECT
	time_of_day,
	COUNT(product) AS num_transactions
FROM temp
GROUP BY time_of_day
ORDER BY num_transactions desc;

-- total amount of transactions by time of day

WITH temp AS (
SELECT 
	product,
    order_date,
    quantity_ordered * price_each AS total_price,
CASE 
    WHEN CONVERT(order_date, TIME) >= '05:00:00' AND CONVERT(order_date, TIME) < '12:00:00'
    THEN 'Morning'
    WHEN CONVERT (order_date, TIME) >= '12:00:00' AND CONVERT(order_date, TIME) < '17:00:00' 
    THEN 'Afternoon'
    ELSE 'Evening'
END AS time_of_day

FROM yearly_sales) 

SELECT 
	time_of_day,
    ROUND(SUM(total_price),2) AS transaction_total
FROM temp
GROUP BY time_of_day
ORDER BY transaction_total desc;

-- seasonal differences in sales

WITH temp2 AS (
SELECT 
	order_date,
    quantity_ordered,
    price_each,
    quantity_ordered * price_each AS total_price,
    product,
CASE 
	WHEN CONVERT(order_date, DATE) >= '2019-03-01' AND CONVERT(order_date, DATE) <='2019-05-31' 
    THEN 'Spring'
    WHEN CONVERT(order_date, DATE) >= '2019-06-01' AND CONVERT(order_date, DATE) <= '2019-08-31' 
    THEN 'Summer'
    WHEN CONVERT(order_date, DATE) >= '2019-09-01' AND CONVERT(order_date, DATE) <= '2019-11-30' 
    THEN 'Autumn'
	ELSE 'Winter'
END AS season

FROM yearly_sales)

SELECT 
	season,
    ROUND(SUM(total_price), 2)  AS revenue
FROM temp2
GROUP BY season
ORDER BY revenue desc;

-- to obtain the number of transaction for the year

SELECT 
	COUNT(*) AS total_transactions
FROM yearly_sales;

-- to obtain the average quantity per transactions

SELECT 
	ROUND(AVG(quantity_ordered),2) 
FROM yearly_sales;


-- to obtain the average amount per transaction

WITH total_price_table AS (
SELECT 
	product,
    order_date,
    quantity_ordered * price_each AS total_price
FROM yearly_sales)

SELECT 
	ROUND(AVG(total_price),2) 
FROM total_price_table;










