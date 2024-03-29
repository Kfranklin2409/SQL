## For this project, I downloaded a database that contained various data about music download sales with multiple tables that incluced, but not limited to, artist, tracks, invoices, customers, and employeee among others. I then performed analytical queries on the data to combine and obtain various data from the database. The queries increase in depth from top to bottom. 

-- Select track name with invoice line ID
SELECT 
	t.Name, 
    i.InvoiceLineId 
FROM tracks t
    LEFT JOIN invoice_items i
		ON t.TrackId=i.TrackId;
    
-- Select specific location of customers, ID numbers, and their order totals
SELECT A.CustomerId, FirstName,
       LastName,
       Country,
       SUM(Total) AS Order_Total
FROM chinook.customers A
	LEFT OUTER JOIN Invoices B 
		ON A.CustomerId = B.CustomerId
 WHERE Country = 'Brazil'
 GROUP BY A.CustomerId
;
 
-- Select the total number of customers for each Support Agent 
SELECT 
    SupportRepId,
    LastName,
    FirstName,
    COUNT(SupportRepId) AS Sales
FROM Employees
	JOIN customers 
		ON customerS.SupportRepId = employees.EmployeeId
GROUP BY SupportRepId
ORDER BY sales DESC;

-- Select all customers of a specific sales support agent with phone numbers to send thank you messages
SELECT FirstName,
       LastName,
       Phone,
       SupportRepId
FROM customers
 WHERE SupportRepId = 3 AND 
       Phone != 'null'
 ORDER BY LastName;
 
-- Select all customers, their country, order totals, and sales support agent
SELECT 
    A.Lastname,
    A.Firstname,
    Country,
    SUM(Total) AS Total_Order,
    B.FirstName AS Rep_FirstName,
    B.LastName AS Rep_LastName
FROM customers A
	LEFT OUTER JOIN employees B 
        ON A.SupportRepId = B.EmployeeId
	LEFT OUTER JOIN ices C 
		ON C.CustomerId = A.CustomerId
GROUP BY A.CustomerId
ORDER BY Total_Order DESC;
 
-- Select the total number of invoices From 2009 where the customer spent at least $10
SELECT 
    COUNT(*)
FROM Invoices
WHERE InvoiceDate LIKE '2009%' AND Total >= 10;
       
-- Select all customers, their total number of orders, and their total amount spent
SELECT 
    LastName,
    FirstName,
    COUNT(B.CustomerId) AS Number_of_Orders,
    SUM(Total) AS Order_Total
FROM Customers A
	LEFT OUTER JOIN invoices B 
		ON A.CustomerID = B.CustomerId
GROUP BY A.CustomerId
ORDER BY Order_Total DESC;
 
 -- Select which tracks were purchased by customers include the invoice and invoice total
SELECT 
	t.name AS Track_Name, 
    cust.LastName, 
    cust.FirstName, 
    inv.InvoiceID, inv.total
FROM tracks t
	JOIN invoice_items i
        ON t.TrackId=i.TrackId
	JOIN invoices inv
        ON i.invoiceId=inv.invoiceId
	JOIN customers cust
        ON inv.CustomerId=cust.CustomerId
ORDER BY cust.customerId;
 
-- Select sale support agents' total sales and total number of sales.
SELECT 
    A.LastName,
    A.Firstname,
    SUM(C.Total) AS Sales_Total,
    COUNT(SupportRepId) AS Sales
FROM Employees A
	LEFT OUTER JOIN customers B 
		ON A.EmployeeId = B.SupportRepId
	LEFT OUTER JOIN Invoices C 
        ON B.CustomerId = C.CustomerId
WHERE title = 'Sales Support Agent'
GROUP BY A.EmployeeId
ORDER BY Sales_Total DESC;
 
-- Select all invoices and their totals for each sales support agent
SELECT 
	A.LastName, 
    A.FirstName, 
    InvoiceId, 
    InvoiceDate, 
    total
FROM employees A
	OUTER JOIN customers B 
		ON A.EmployeeId = B.SupportRepId
	OUTER JOIN Invoices C
        ON B.CustomerId = C.CustomerId
WHERE title = 'Sales Support Agent'
ORDER BY A.LastName;
        
-- Select all tracks, including its artist, album title, media type, and genre. 
SELECT 
	A.Name AS Track_Name, 
    E.Name AS Artist, 
    B.Title AS Album_Title, 
    C.Name AS Media_Type, 
    D.Name AS Genre
FROM tracks A
    LEFT OUTER JOIN albums B
		ON A.AlbumId = B.AlbumId
    LEFT OUTER JOIN media_types C
		ON A.MediaTypeId = C.MediaTypeId
    LEFT OUTER JOIN genres D
		ON A.GenreId = D.GenreId
    LEFT OUTER JOIN artists E
		ON B.ArtistId = E.ArtistId
ORDER BY E.ArtistId;

-- Select list of customers and their distinct billing countries  
SELECT DISTINCT 
	B.BillingCountry, 
    A.Lastname, 
    A.FirstName 
FROM chinook.Invoices B
    LEFT JOIN Chinook.customers A
		ON B.CustomerId = A.CustomerId
ORDER BY BillingCountry;

-- Select the Invoice Total, Customer name, Country, and Sales Agent name for all invoices and customers
SELECT 
	emp.LastName AS AgentLastName, 
	emp.Firstname AS AgentFirstName, 
    cust.FirstName AS CustomerFirstName, 
    cust.LastName AS CustomerLastName, 
    cust.Country, inv.total
FROM chinook.employees emp 
	JOIN chinook.Customers cust 
		ON cust.SupportRepId = emp.EmployeeId
	JOIN chinook.Invoices Inv 
		ON Inv.CustomerId = cust.CustomerId;