-- Used to confirm correct table being used 
SELECT table_schema, table_name, table_rows
	FROM information_schema.tables
	WHERE TABLE_SCHEMA LIKE 'classic%'; 
    
-- Question 1
SELECT DISTINCT country 
	FROM Offices;
    
-- Question 2
SELECT employeeNumber, lastName, firstName 
	FROM employees e INNER JOIN offices o
		ON e.officeCode = o.officeCode
	WHERE o.city = 'San Francisco';
    
-- Question 3
SELECT productCode, productName, productVendor, quantityInStock, productLine
	FROM products
    WHERE productline = 'Vintage Cars'
    AND buyPrice BETWEEN 50 AND 60;
    
-- Question 4
SELECT productCode, productName, productVendor, buyPrice, Min(MSRP)
	FROM products;

-- Question 5
SELECT productName, MAX(MSRP)
	FROM products;
    
-- Question 6
SELECT country, COUNT(customerName) AS 'Customers'
	FROM customers
    GROUP BY country
    HAVING COUNT(customerName) > 6
    ORDER BY country ASC;
    
-- Question 7
SELECT p.productCode, p.productName, COUNT(*) AS 'OrderCount'
	FROM products p INNER JOIN orderdetails od 
    	ON p.productCode = od.productCode
    WHERE p.productVendor = 'Welly Diecast Productions'
    GROUP BY p.productCode, p.productName;    
    
-- Question 8
SELECT e1.employeeNumber, CONCAT(e1.firstName, ' ',e1.lastName) AS 'Name'
	FROM employees e1 INNER JOIN employees e2
    ON  e1.reportsTO = e2.employeeNumber
    WHERE (e2.firstName = 'William' or e2.firstName = 'Mary')
    	AND e2.lastName = 'Patterson';
    
-- Question 9
SELECT employeeNumber, lastName, firstName
	FROM employees
    WHERE reportsTo IS NULL;
    
-- Question 10   
SELECT productName, productLine
	FROM products
    WHERE productLine = 'Motorcycles'
    AND LEFT(productName, 4) BETWEEN 1990 AND 2000;
    
-- Question 11
SELECT * 
  FROM orders
     WHERE (shippedDate BETWEEN '2004-11-01' AND '2004-11-30')
      AND DATEDIFF(requiredDate, shippedDate) < 3;

-- Question 12
 SELECT DISTINCT employeeNumber,e.firstName, e.lastName
	FROM employees e LEFT JOIN customers c ON c.salesRepEmployeeNumber = e.employeeNumber
    WHERE c.salesRepEmployeeNumber IS NULL;

-- Question 13
SELECT customerName 
	From customers
    WHERE country = 'Switzerland' 
    AND  customerNumber NOT IN (SELECT customerNumber FROM orders);

-- Question 14
SELECT c.customerName, SUM(od.quantityOrdered)
	FROM customers c INNER JOIN orders o
    	ON c.customerNumber = o.customerNumber
    INNER JOIN orderdetails od ON od.orderNumber = o.orderNumber
   	GROUP BY c.customerName
    HAVING SUM(od.quantityOrdered) > 1700;

-- Question 15
CREATE TABLE IF NOT EXISTS TopCustomers(
	Customernumber INT NOT NULL,
    ContactDate DATE NOT NULL,
    OrderCount INT NOT NULL,
    OrderTotal DECIMAL(9,2) NOT NULL,
    CONSTRAINT TopCustomer_PK PRIMARY KEY (CustomerNumber)
    );

-- Question 16
INSERT INTO TopCustomers
SELECT CustomerNumber, CURDATE() AS ContactDate, OrderCount, OrderTotal
	FROM (SELECT customerNumber, COUNT(customerNumber) AS OrderCount, SUM(priceEach*quantityOrdered)AS OrderTotal
		FROM orders o
		LEFT JOIN orderdetails od
			ON od.orderNumber = o.orderNumber
		GROUP BY customerNumber) AS subqu
	WHERE subqu.OrderTotal > 150000
    GROUP BY customerNumber
    ORDER BY customerNUMBER;
    
-- Question 17
SELECT *
  FROM TopCustomers
  ORDER BY OrderTotal DESC;
  
-- Question 18
ALTER TABLE TopCustomers ADD CreditRating INT;

-- Question 19
UPDATE TopCustomers SET CreditRating = FLOOR(RAND()*(9-0+1))+0;

-- Quetion 20
SELECT *
  FROM TopCustomers
  ORDER BY CreditRating DESC;

-- question 21
DROP TABLE TopCustomers; 