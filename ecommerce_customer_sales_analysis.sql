-- STEP 1: CREATE DATABASE

CREATE DATABASE ecommerce_project;
USE ecommerce_project;



-- STEP 2: CREATE SALES TABLE

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    order_date DATE,
    customer_id INT,
    product VARCHAR(50),
    category VARCHAR(50),
    quantity INT,
    price INT
);



-- STEP 3: CREATE HELPER TABLE (1–10)

CREATE TABLE numbers (num INT);

INSERT INTO numbers (num)
VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10);



-- STEP 4: INSERT 8,000+ SALES RECORDS

-- (8 × 10 × 10 × 10 = 8000 records)

INSERT INTO orders (order_date, customer_id, product, category, quantity, price)

SELECT 
    DATE_ADD('2024-01-01', INTERVAL FLOOR(RAND()*365) DAY),
    FLOOR(1000 + (RAND()*2000)),
    ELT(FLOOR(1 + (RAND()*4)), 'Laptop','Mobile','Headphones','Smartwatch'),
    ELT(FLOOR(1 + (RAND()*3)), 'Electronics','Accessories','Gadgets'),
    FLOOR(1 + (RAND()*5)),
    FLOOR(5000 + (RAND()*50000))
FROM numbers a
CROSS JOIN numbers b
CROSS JOIN numbers c
CROSS JOIN (
    SELECT num FROM numbers LIMIT 8
) d;



-- STEP 5: CHECK TOTAL RECORDS

SELECT COUNT(*) AS total_records FROM orders;



-- KPI 1: TOTAL REVENUE

SELECT 
    SUM(quantity * price) AS total_revenue
FROM orders;



-- KPI 2: MONTHLY REVENUE TREND

SELECT 
    MONTH(order_date) AS month,
    SUM(quantity * price) AS monthly_revenue
FROM orders
GROUP BY MONTH(order_date)
ORDER BY month;



-- KPI 3: TOP-SELLING PRODUCTS

SELECT 
    product,
    SUM(quantity) AS total_quantity_sold,
    SUM(quantity * price) AS product_revenue
FROM orders
GROUP BY product
ORDER BY product_revenue DESC;



-- KPI 4: REPEAT CUSTOMERS

SELECT 
    customer_id,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY customer_id
HAVING COUNT(order_id) > 1
ORDER BY total_orders DESC;



-- KPI 5: CUSTOMER RETENTION INSIGHT
-- (Customers with more than 3 orders)

SELECT 
    COUNT(*) AS loyal_customers
FROM (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(order_id) > 3
) AS retention_data;
