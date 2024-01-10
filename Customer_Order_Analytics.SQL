#In this SQL, I'm querying a database with multiple tables in it to quantify statistics about customer and order data. 

/*Selecting the total amount of orders placed in January*/
SELECT 
	COUNT(orderID) 
FROM BIT_DB.JanSales;

/*Selecting the total number of iPhones sold in January*/
SELECT 
	Count(Product) 
FROM BIT_DB.JanSales
WHERE Product = 'iPhone';

/*Select the customer account numbers for all the orders placed in February*/
SELECT 
	acctnum
FROM BIT_DB.customers cust
	INNER JOIN BIT_DB.FebSales Feb
		ON cust.order_id=FEB.orderid;

/*Selecting the cheapest product sold in January and it's price*/
SELECT 
	Product,
	MIN(price)
FROM BIT_DB.JanSales;

/*Selecting the total revenue for each product sold in January*/
SELECT 
	SUM(price* quantity) AS revenue, 
    product
FROM BIT_DB.JanSales
GROUP BY product;

/*Selecting products sold to a specific address in specific table*/
SELECT 
	product, 
    quantity, 
    SUM(price*quantity) AS Total_Revenue FROM BIT_DB.FebSales
WHERE location='548 Lincoln St, Seattle, WA 98101'
GROUP BY product;

/*Selecting customers who ordered more than 2 products and average amount for those customers in February*/
SELECT 
count(cust.acctnum), 
avg(quantity*price)
FROM BIT_DB.FebSales Feb
	LEFT JOIN BIT_DB.customers cust
		ON FEB.orderid=cust.order_id
WHERE Feb.Quantity>2;

/*Select the products and quantities sold in Los Angeles in February*/  
SELECT 
	product, 
    SUM(quantity)
FROM BIT_DB.FebSales
WHERE location like '%Los Angeles%'
GROUP BY Product;

/*Select locations in NY that received at least 3 orders in January and how much they received*/
SELECT 
	distinct location, 
	COUNT(orderID) 
FROM BIT_DB.JanSales
WHERE location like '%NY%'
GROUP BY location
HAVING COUNT(orderID)>2;

/*Select the amount of each type of headphone sold in January*/
SELECT 
	product, 
	SUM(quantity) 
FROM BIT_DB.FebSales
WHERE product like '%headphone%'
GROUP BY product;

/*Select the average amount spent per account in February*/
SELECT 
	SUM(quantity*price)/COUNT(cust.acctnum)
FROM BIT_DB.FebSales Feb
	LEFT JOIN BIT_DB.customers cust
		ON FEB.orderid=cust.order_id; 

/*Select the average amount per account in February*/
SELECT 
	SUM(feb.quantity)/COUNT(cust.acctnum) AS Avg_Per_Customer
FROM BIT_DB.FebSales feb
	LEFT JOIN BIT_DB.customers cust
		ON Feb.orderid=cust.order_id;

/*Select the product with most revenue in January and it's total amount*/
SELECT 
	product, 
	SUM(quantity*price)
FROM BIT_DB.JanSales
GROUP BY product 
ORDER BY SUM(quantity*price) desc
LIMIT 1;
