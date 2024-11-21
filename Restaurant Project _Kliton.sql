-- Objective 1
-- Explore the items table
-- Your first objective is to better understand the items table by finding the 
-- number of rows in the table, the least and most expensive items, 
-- and the item prices within each category.

-- Task 1 
-- 1. View the menu_items table and write a query to find the number of items on the menu
-- 2. What are the least and most expensive items on the menu?
-- 3. How many Italian dishes are on the menu? What are the least and most expensive Italian dishes on the menu?
-- 4. How many dishes are in each category? What is the average dish price within each category?

SELECT * FROM menu_items; 

-- 1. What are the least and most expensive items on the menu?
SELECT * FROM menu_items
order by price; 
-- Least expensive item is Edaname

SELECT * FROM menu_items
order by price Desc; 
-- Most expensive item is Shrimp Scampi 


-- 2. How many Italian dishes are on the menu? What are the least and most expensive Italian dishes on the menu?
SELECT Count(*) as number_of_Italian_Dishes
FROM menu_items
where category = 'Italian'; 
-- There are 9 Italian Dishes 

SELECT * FROM menu_items
where category = 'Italian' 
order by price; 
-- The least expensive Italian dish is Spaghetti $14.50

SELECT 
    *
FROM
    menu_items
WHERE
    category = 'Italian'
ORDER BY price DESC;
-- The most expensive Italian dish is Shrimp Scampi $19.95

-- 3. How many dishes are in each category? 
SELECT 
    category, COUNT(menu_item_id) AS num_dishes
FROM
    menu_items
GROUP BY category; 
-- American 6, Asian 8, Mexican 9, Italian 9 

-- 4. What is the average dish price within each category?
SELECT 
    category, AVG(price) AS average_food_group_price
FROM
    menu_items
GROUP BY category
ORDER BY average_food_group_price DESC; 
-- The most expensive group dishes are Italian $16.75 


-- Objective 2
-- Explore the orders table
-- Your second objective is to better understand the orders table by finding the date range,
-- the number of items within each order, and the orders with the highest number of items.

-- Task 2
-- 1. View the order_details table. What is the date range of the table?
-- 2. How many orders were made within this date range? 
-- 3. How many items were ordered within this date range?
-- 4. Which orders had the most number of items?
-- 5. How many orders had more than 12 items?

-- 1. View the order_details table. What is the date range of the table?
SELECT 
    *
FROM
    order_details; 
-- View the table first to get a general idea of the data 
-- order_id refers to the orders Primary Keys, while order_details_id refers to the items

SELECT 
    *
FROM
    order_details
ORDER BY order_date; 
-- or -- 
SELECT 
    MIN(order_date), MAX(order_date)
FROM
    order_details; 
-- The date range is from 2023-01-01 to 2023-03-31 

-- 2. How many orders were made within this date range?  
SELECT count(distinct order_id) as num_order
FROM order_details; 
-- The number of orders total are 5,370 

-- 3. How many items were ordered within this date range?
SELECT 
    COUNT(*)
FROM
    order_details AS num_items;
-- The number of items ordered are 12,234 

-- 4. Which orders had the most number of items?
SELECT 
    order_id, COUNT(item_id) AS num_items
FROM
    order_details
GROUP BY order_id
ORDER BY num_items DESC; 
-- Solution - There were multiple orders that were tied at 14 items (order_id 1957,2675,4305,3473,440,443)

-- 5. How many orders had more than 12 items?
SELECT 
    COUNT(*)
FROM
    (SELECT 
        order_id, COUNT(item_id) AS num_items
    FROM
        order_details
    GROUP BY order_id
    HAVING num_items > 12) AS num_orders;
-- There were 20 orders with more than 12 items 


-- Objective 3  - Analyze customer behavior
-- Your final objective is to combine the items and orders tables, 
-- find the least and most ordered categories, and dive into the details of the highest spend orders.

-- Task 3 
-- 1. Combine the menu_items and order_details tables into a single table
-- 2. What were the least and most ordered items? What categories were they in?
-- 3. What were the top 5 orders that spent the most money?
-- 4. View the details of the highest spend order. Which specific items were purchased?
-- 5. View the details of the top 5 highest spend orders

-- 1. Combine the menu_items and order_details tables into a single table
SELECT *
FROM order_details
        LEFT JOIN menu_items ON order_details.item_id = menu_items.menu_item_id; 

-- 2. What were the least and most ordered items? What categories were they in?
SELECT item_name,category, Count(order_details_id) as num_orders
FROM order_details 
	left join menu_items ON menu_items.menu_item_id = order_details.item_id
    group by item_name, category
    order by num_orders desc; 
-- The Least ordered item is Chicken Tacos and the Most ordered item is Hamburger

SELECT item_name, category, Count(order_details_id) as num_orders
FROM order_details 
	left join menu_items ON menu_items.menu_item_id = order_details.item_id
    group by item_name, category 
    order by num_orders desc; 
-- add category from menu_items to both Select and Group by query 
-- The food categories that are selling well are American, Asian and the least popular are Mexican food 

-- 3. What were the top 5 orders that spent the most money?
SELECT order_id, SUM(price) as total_spend
FROM order_details od
        LEFT JOIN menu_items mi ON od.item_id = mi.menu_item_id
GROUP BY order_id 
ORDER BY total_spend desc
LIMIT 5; 
--  The top five orders total money spend range from $185-192, order 440 highest money spend

-- 4. View the details of the highest spend order. Which specific items were purchased?
SELECT category, count(item_id) AS num_order
FROM order_details od
        LEFT JOIN menu_items mi ON od.item_id = mi.menu_item_id
WHERE order_id = 440 
GROUP BY category; 
-- The highest number of food category items from order 440 were Italian 

-- 5. View the details of the top 5 highest spend orders
SELECT category, count(item_id) AS num_order
FROM order_details od
        LEFT JOIN menu_items mi ON od.item_id = mi.menu_item_id
WHERE order_id IN (440, 2075, 1957, 330, 2675)
GROUP BY category
ORDER BY num_order DESC;

SELECT order_id, category, count(item_id) AS num_order
FROM order_details od
        LEFT JOIN menu_items mi ON od.item_id = mi.menu_item_id
WHERE order_id IN (440, 2075, 1957, 330, 2675)
GROUP BY order_id, category
-- The top food category items from the top orders were Italian 


