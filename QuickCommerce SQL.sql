create database QuickCommerce;
use QuickCommerce;
CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    platform_name VARCHAR(100),
    product_category_id INT,
    order_datetime DATETIME,
    delivery_time_min INT,
    order_value_inr INT,
    delivery_delay VARCHAR(10),
    refund_requested INT,
    service_rating INT,
    customer_feedback TEXT,
    product_category_name VARCHAR(100),
    sla_delay VARCHAR(10),
    Segment VARCHAR(50),
    weekday VARCHAR(20),
    date DATE,
    order_hour INT
);


#Category Trends: Top 5 Product Categories by Revenue
SELECT 
    product_category_name, 
    SUM(order_value_inr) AS total_revenue, 
    ROUND(AVG(service_rating), 2) AS avg_rating
FROM orders
GROUP BY product_category_name
ORDER BY total_revenue DESC
LIMIT 5;

#Sales Analysis: Total Orders and Revenue by Platform
SELECT 
    platform_name, 
    COUNT(order_id) AS total_orders, 
    SUM(order_value_inr) AS total_revenue
FROM orders
GROUP BY platform_name
ORDER BY total_revenue DESC;

#Time Trends: Peak Ordering Hours
SELECT 
    order_hour, 
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY order_hour
ORDER BY total_orders DESC
LIMIT 5;

#Customer Segmentation: Revenue by Customer Type
SELECT 
    Segment, 
    COUNT(DISTINCT customer_id) AS unique_customers, 
    SUM(order_value_inr) AS total_spent
FROM orders
GROUP BY Segment
ORDER BY unique_customers DESC;

#Busiest Days of the Week
SELECT 
    weekday, 
    COUNT(order_id) AS total_orders, 
    SUM(order_value_inr) AS total_revenue
FROM orders
GROUP BY weekday
ORDER BY total_revenue DESC;

#Peak Ordering Hours
SELECT 
    order_hour, 
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY order_hour
ORDER BY total_orders DESC
LIMIT 5;

#Customer Segmentation Breakdown
SELECT 
    Segment, 
    COUNT(DISTINCT customer_id) AS unique_customers, 
    SUM(order_value_inr) AS total_spent
FROM orders
GROUP BY Segment
ORDER BY unique_customers DESC;

#Refund Requests by Platform
SELECT 
    platform_name, 
    SUM(refund_requested) AS total_refunds,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY platform_name
ORDER BY total_refunds DESC;

#Refund Requests by Platform
SELECT 
    platform_name, 
    SUM(refund_requested) AS total_refunds,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY platform_name
ORDER BY total_refunds DESC;

#Impact of Delays on Service Ratings
SELECT 
    delivery_delay, 
    COUNT(order_id) AS total_orders, 
    ROUND(AVG(service_rating), 2) AS average_rating
FROM orders
GROUP BY delivery_delay;

CREATE TABLE customers AS
SELECT DISTINCT customer_id, Segment
FROM orders;

CREATE TABLE categories AS
SELECT DISTINCT product_category_id, product_category_name
FROM orders;

#Revenue by Product Category
SELECT 
    c.product_category_name, 
    COUNT(o.order_id) AS total_orders,
    SUM(o.order_value_inr) AS total_revenue
FROM orders o
JOIN categories c ON o.product_category_id = c.product_category_id
GROUP BY c.product_category_name
ORDER BY total_revenue DESC;

#Customer Spend by Segment
SELECT 
    cust.Segment, 
    COUNT(o.order_id) AS total_orders,
    SUM(o.order_value_inr) AS total_revenue
FROM orders o
JOIN customers cust ON o.customer_id = cust.customer_id
GROUP BY cust.Segment
ORDER BY total_revenue DESC;

#The "Loyalist" Buying Habits
SELECT 
    c.product_category_name,
    COUNT(o.order_id) AS total_purchases,
    SUM(o.order_value_inr) AS total_spent
FROM orders o
JOIN customers cust ON o.customer_id = cust.customer_id
JOIN categories c ON o.product_category_id = c.product_category_id
WHERE cust.Segment = 'Loyalist'
GROUP BY c.product_category_name
ORDER BY total_spent DESC;

#Which Customers Complain the Most?
SELECT 
    cust.Segment,
    ROUND(AVG(o.service_rating), 2) AS average_rating,
    SUM(o.refund_requested) AS total_refunds
FROM orders o
JOIN customers cust ON o.customer_id = cust.customer_id
GROUP BY cust.Segment
ORDER BY average_rating ASC;