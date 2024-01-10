

SELECT 
	orderdate
FROM BIT_DB.FebSales
WHERE orderdate between '02/13/19 00:00' AND '02/18/19 00:00';

SELECT 
	location
FROM BIT_DB.FebSales 
WHERE orderdate = '02/18/19 01:35';

SELECT 
	sum(quantity)
FROM BIT_DB.FebSales 
WHERE orderdate like '02/18/19%';

SELECT 
	distinct Product
FROM BIT_DB.FebSales
WHERE Product like '%Batteries%';

SELECT distinct Product, Price
FROM BIT_DB.FebSales 
WHERE Price like '%.99';

/*Select the products and quantities from Los Angeles in February*/
SELECT 
	product, 
    SUM(quantity)
FROM BIT_DB.FebSales
WHERE location like '%Los Angeles%'
GROUP BY Product;

SELECT * 
FROM Franklin.retailsales;

Select 
	month, 
    SUM(total_orders) AS t FROM retailsales
GROUP BY month
ORDER BY t;

SELECT month, 
    ROUND(AVG(returns),2) AS Average_Monthly_Returns,
    ROUND(AVG(Total_Sales),2) AS Average_Monthly_Sales,
    ROUND(ROUND(AVG(Total_Sales),2) + ROUND(AVG(returns),2),0) AS Average_Sales_Last_Two_Years
FROM retailsales
    WHERE Year = '2018' 
		OR Year = '2019'
GROUP BY month
ORDER BY Average_Sales_Last_Two_Years desc;
       
SELECT 
    year, 
    month, Total_Sales
FROM retailsales
    WHERE Total_Sales > (SELECT AVG(Total_Sales) FROM retailsales)
    ORDER BY year desc;