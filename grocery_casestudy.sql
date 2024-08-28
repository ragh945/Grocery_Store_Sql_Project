use grocery_store;
-- Dispalying the tables in grocery database
SELECT * FROM CATEGORIES;
SELECT * FROM CUSTOMERS;
SELECT * FROM EMPLOYEES;
SELECT * FROM OREDR_DETAILS;
SELECT * FROM ORDERS;
SELECT * FROM SUPPLIERS;
SELECT * FROM PRODUCTS;

-- 1. Find all customers who live in 'banglore'
 WITH CTE_ AS (SELECT * FROM CUSTOMERS
WHERE ADDRESS REGEXP "BENGALURU")
SELECT *
FROM CTE_
;

-- 2. List all categories.
SELECT  DISTINCT CAT_NAME FROM CATEGORIES;

-- 3. Retrieve all products along with their unit prices
SELECT PROD_NAME,PRICE FROM PRODUCTS
GROUP BY PROD_NAME,PRICE
ORDER BY PRICE DESC;


-- 4. List all products that belong to the 'Beverages' category.
SELECT PROD_NAME,CAT_NAME FROM CATEGORIES C
JOIN PRODUCTS P
ON C.CAT_ID=P.CAT_ID
WHERE CAT_NAME="BEVERAGES"
GROUP BY PROD_NAME,CAT_NAME;

-- 5. Find the total number of units sold for each product.
SELECT PROD_NAME,SUM(QUANTITY) AS UNITS_SOLD FROM ORDER_DETAILS OD
JOIN PRODUCTS P
USING(PROD_ID)
GROUP BY PROD_NAME
ORDER BY UNITS_SOLD DESC;

-- 6. List employees who have processed at least 25 orders.
WITH CTE_ AS (SELECT EMP_ID,COUNT(*) AS ORDERS FROM ORDERS
GROUP BY EMP_ID
HAVING ORDERS>=25
ORDER BY ORDERS DESC)
SELECT EMP_ID,EMP_NAME,ORDERS FROM CTE_ 
JOIN EMPLOYEES
USING(EMP_ID)
;

-- 7. Retrieve the average unit price of products in each category.
SELECT * FROM CATEGORIES;
SELECT CAT_ID,CAT_NAME,PROD_NAME,AVG(PRICE) FROM PRODUCTS
JOIN CATEGORIES
USING(CAT_ID)
GROUP BY PROD_NAME,CAT_ID,CAT_NAME;

-- 8. Find customers who have placed more than 5 orders.
 WITH CTE_ AS (SELECT CUST_ID,COUNT(*) AS ORDERS_PLACED FROM CUSTOMERS
JOIN ORDERS
USING (CUST_ID)
GROUP BY CUST_ID
HAVING ORDERS_PLACED>5
ORDER BY ORDERS_PLACED DESC)
SELECT * FROM CUSTOMERS
JOIN CTE_
USING(CUST_ID);

-- 9. List the top 3 customers based on the total amount spent.
SELECT CUST_ID,CUST_NAME,ORD_ID,SUM(TOTAL_PRICE) AS AMOUNT_SPENT FROM CUSTOMERS
JOIN ORDERS
USING(CUST_ID)
JOIN ORDER_DETAILS
USING(ORD_ID)
GROUP BY CUST_ID,CUST_NAME,ORD_ID
ORDER BY AMOUNT_SPENT DESC
LIMIT 3;


-- 10. Retrieve details of the top 5 products with the highest unit price.
SELECT PROD_NAME,SUM(PRICE) AS TOTAL FROM PRODUCTS
GROUP BY PROD_NAME
ORDER BY TOTAL DESC
LIMIT 5;

-- 11.List the products that have a higher unit price than the average unit price of all products.
SELECT * FROM PRODUCTS
WHERE PRICE>(SELECT AVG(PRICE) FROM PRODUCTS);

-- 12. Retrieve the product details of those that have never been ordered.
SELECT * FROM PRODUCTS
WHERE PROD_ID NOT IN (SELECT PROD_ID FROM ORDER_DETAILS);

-- 13. Retrieve the order details along with the customer and employee information for orders placed in the month May.
SELECT * FROM EMPLOYEES;
with cte_ as (SELECT *,monthname(str_to_date(REPLACE(ORDER_DATE,"/","-"),"%m-%d-%y")) as monthname_ FROM ORDERS
JOIN CUSTOMERS
USING(CUST_ID)
JOIN EMPLOYEES
USING (EMP_ID))
SELECT ORD_ID,ORDER_DATE,MONTHNAME_,EMP_ID,EMP_NAME,CUST_ID,CUST_NAME FROM CTE_
WHERE MONTHNAME_="MAY";

-- 14. which category of products is generating high revenue
select cat_name,sum(total_price) as revenue from categories
join products
using(cat_id)
join order_details
using(prod_id)
group by cat_name
order by revenue desc
limit 1;

-- 15.which supplier is suppling more products of category (from above ques) beverages 
with cte_ as (select * from supplier
join products
using(sup_id)
join categories
using(cat_id)
group by cat_name,sup_id,sup_name,prod_id,cat_id
having cat_name="Beverages")
select  sup_id,count(*) as cnt,sup_name from cte_
group by sup_id,sup_name
order by cnt  desc
limit 1;


-- 16.Find the suppliers who supply products in more than 3 different categories
SELECT * FROM SUPPLIER;
SELECT * FROM PRODUCTS;
SELECT * FROM CATEGORIES;
SELECT SUP_ID,COUNT(CAT_ID) AS S,SUP_NAME FROM SUPPLIER
JOIN PRODUCTS
USING(SUP_ID)
JOIN CATEGORIES
USING(CAT_ID)
GROUP BY SUP_ID,SUP_NAME
HAVING S>3;