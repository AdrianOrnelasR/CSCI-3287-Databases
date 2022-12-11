-- question 1: understanding scheme 
-- 1.1
use information_schema; 


SELECT SUM(table_rows) 
   FROM information_schema.tables
   WHERE table_schema = 'aw'; -- count = 119753

-- 1.2 run 
SELECT COUNT(*) 
	FROM information_schema.tables; -- count = 98

-- 1.3
	-- count actully counts how many rows are present in each table while schema uses an 
	-- approximation while taking into account reccent changes like delete & insert, resulting in a bad approximation.

-- 1.4
	-- count is less effective because it goes though each row while schema doesnt enter the rows at all 
	-- "InnoDB is a storage engine for the database management system MySQL and MariaDB." (google)

-- 2

SELECT * 
	FROM information_schema.columns;

SELECT DISTINCT table_name, column_name 
	FROM information_schema.COLUMNS
    WHERE table_schema = 'aw' AND column_key = 'PRI';      

-- 3

-- 4
	-- The purpose of the recession relation on the columns of VacationHours on Phone because it is 
	-- used to represent that the phone numbers are available if vacationHours are valid.

-- 5
use aw;

SELECT EnglishProductSubcategoryName -- correct answer 
	FROM DimProductSubcategory
    WHERE ProductCategoryKey = 1;

-- wtf answer 
SELECT ModelName, EnglishDescription
	FROM DimProduct
    WHERE ProductSubCategoryKey=1;

-- 6
SELECT ProductKey, UnitPrice
	FROM FactInternetSales 
    RIGHT JOIN DimTime ON FactInternetSales.OrderDateKey
    WHERE CalendarYear = '2004';

SELECT DimProductSubcategory.EnglishProductSubcategoryName, ProfitVolume.total
	FROM (SELECT SUM(ProductAndUnitPrice.unitprice) AS total, DimProduct.ProductSubcategoryKey AS ProductSubcategoryKey
		FROM (SELECT ProductKey, UnitPrice
			FROM FactInternetSales
			RIGHT JOIN DimTime ON FactInternetSales.OrderDateKey
			WHERE FullDateAlternateKey BETWEEN '2004-01-01' AND '2004-12-31') AS ProductAndUnitPrice
		JOIN DimProduct ON ProductAndUnitPrice.ProductKey = DimProduct.ProductKey
        WHERE DimProduct.ProductSubcategoryKey in (1,2,3)
        GROUP BY DimProduct.ProductSubcategoryKey) AS ProfitVolume
	JOIN DimProductSubcategory ON DimProductSubcategory.ProductSubcategoryKey = ProfitVolume.ProductSubcategoryKey;

SELECT DimProductSubcategory.EnglishProductSubcategoryName, ProfitVolume.DollarVolume
	FROM (SELECT SUM(ProductAndPrice.unitprice) AS DollarVolume, DimProduct.ProductSubcategoryKey AS ProductSubcategoryKey
		FROM (SELECT ProductKey, UnitPrice
			FROM FactInternetSales
			RIGHT JOIN DimTime ON FactInternetSales.OrderDateKey
			WHERE FullDateAlternateKey BETWEEN '2004-01-01' AND '2004-12-31') AS ProductAndPrice
		JOIN DimProduct ON ProductAndPrice.ProductKey = DimProduct.ProductKey
        WHERE DimProduct.ProductSubcategoryKey in (1,2,3)
        GROUP BY DimProduct.ProductSubcategoryKey) AS ProfitVolume
	JOIN DimProductSubcategory ON DimProductSubcategory.ProductSubcategoryKey = ProfitVolume.ProductSubcategoryKey;

(SELECT SUM(ProductAndPrice.unitprice) AS DollarVolume, DimProduct.ProductSubcategoryKey AS ProductSubcategoryKey
		FROM (SELECT ProductKey, UnitPrice
			FROM FactInternetSales
			RIGHT JOIN DimTime ON FactInternetSales.OrderDateKey
			WHERE FullDateAlternateKey BETWEEN '2004-01-01' AND '2004-12-31') AS ProductAndPrice
		JOIN DimProduct ON ProductAndPrice.ProductKey = DimProduct.ProductKey
        WHERE DimProduct.ProductSubcategoryKey in (1,2,3)
        GROUP BY DimProduct.ProductSubcategoryKey);

SELECT DimProductSubcategory.EnglishProductSubcategoryName, ProfitVolume.DollarVolumeOfUnit
	FROM (SELECT SUM(ProductsUnitPrice.unitprice) AS DollarVolumeOfUnit, DimProduct.ProductSubcategoryKey AS ProductSubcategoryKey
		FROM (SELECT ProductKey, UnitPrice
				FROM FactInternetSales
				RIGHT JOIN DimTime ON FactInternetSales.OrderDateKey
				WHERE FullDateAlternateKey BETWEEN '2004-01-01' AND '2004-12-31') AS ProductsUnitPrice
		JOIN DimProduct ON ProductsUnitPrice.ProductKey = DimProduct.ProductKey
		WHERE DimProduct.ProductSubcategoryKey = 1 || DimProduct.ProductSubcategoryKey = 2 || DimProduct.ProductSubcategoryKey = 3
		GROUP BY DimProduct.ProductSubcategoryKey) AS ProfitVolume
	JOIN DimProductSubcategory ON DimProductSubcategory.ProductSubcategoryKey = ProfitVolume.ProductSubcategoryKey;

SELECT DimProductSubcategory.EnglishProductSubcategoryName, ProfitVolume.DollarVolume
	FROM (SELECT SUM(ProductAndPrice.unitprice) AS DollarVolume, DimProduct.ProductSubcategoryKey AS ProductSubcategoryKey
		FROM (SELECT ProductKey, UnitPrice
				FROM FactInternetSales
				RIGHT JOIN DimTime ON FactInternetSales.OrderDateKey
				WHERE FullDateAlternateKey BETWEEN '2004-01-01' AND '2004-12-31') AS ProductAndPrice
		JOIN DimProduct ON ProductAndPrice.ProductKey = DimProduct.ProductKey
		WHERE DimProduct.ProductSubcategoryKey in (1,2,3)
		GROUP BY DimProduct.ProductSubcategoryKey)
JOIN DimProductSubcategory ON DimProductSubcategory.ProductSubcategoryKey = ProfitVolume.ProductSubcategoryKey;

        


-- 7
SELECT EnglishProductSubcategoryName 
    FROM DimProductSubcategory
    WHERE ProductCategoryKey != 1;
    
-- 8




-- 9
-- List and compare the total sales quantities (number of bikes, NOT dollars) of bikes sold (all 
-- model types) by customer gender by year and month. In which year and month were bike 
-- sales to females the highest? Provide your SQL query, and your answer set along with your 
-- answer to the question.  

SELECT *
	FROM FactInternetSales;
    
SELECT *
	FROM DimCustomer;
    
SELECT *
	FROM FactInternetSales;
    
SELECT *
	FROM DimTime;
    
SELECT DimCustomer.Gender, sum(Sumie.OrderQuantity)
	FROM (SELECT OrderQuantity, CustomerKey
		FROM FactInternetSales
		JOIN DimProduct ON FactInternetSales.ProductKey = DimProduct.ProductKey
		WHERE DimProduct.ProductSubcategoryKey in (1,2,3)) AS Sumie
    JOIN DimCustom er ON Sumie.CustomerKey = DimCustomer.CustomerKey
	GROUP BY DimCustomer.Gender;
    
SELECT ProductKey, UnitPrice
	FROM FactInternetSales 
    RIGHT JOIN DimTime ON FactInternetSales.OrderDateKey
    WHERE CalendarYear = '2004';    

SELECT DimCustomer.Gender, sum(Sumie.OrderQuantity)
	FROM (SELECT OrderQuantity, CustomerKey
		FROM FactInternetSales
		JOIN DimProduct ON FactInternetSales.ProductKey = DimProduct.ProductKey
		WHERE DimProduct.ProductSubcategoryKey in (1,2,3)) AS Sumie
    JOIN DimCustomer ON Sumie.CustomerKey = DimCustomer.CustomerKey
	GROUP BY DimCustomer.Gender;

SELECT MonthNumberOfYear, CalendarYear
	FROM DimTime;
    

SELECT DimCustomer.Gender, sum(Sumie.OrderQuantity), Sumie.DayNumberOfMonth, Sumie.CalendarYear
FROM (SELECT FactInternetSales.OrderQuantity, FactInternetSales.CustomerKey, DimTime.DayNumberOfMonth, DimTime.CalendarYear 
     	FROM FactInternetSales
      	JOIN DimProduct ON FactInternetSales.ProductKey = DimProduct.ProductKey
      	JOIN DimTime ON FactInternetSales.OrderDateKey = DimTime.TimeKey
      	WHERE DimProduct.ProductSubcategoryKey in (1,2,3)
     ) AS Sumie
JOIN DimCustomer ON Sumie.CustomerKey = DimCustomer.CustomerKey
GROUP BY DimCustomer.Gender, Sumie.DayNumberOfMonth, Sumie.CalendarYear
ORDER BY sum(Sumie.OrderQuantity) DESC;

-- 10
-- For the year 2004, which State/Province yielded the highest margin for AdventureWorks?  
-- (HINT:  use the customer’s State/Province.)   Provide your SQL query, and your answer set 
-- along with your answer to the question. 

SELECT StateProvinceName
	FROM DimCustomer JOIN DimGeography ON DimCustomer.GeographyKey
    GROUP BY StateProvinceName;

SELECT StateProvinceName
	FROM FactInternetSales
		JOIN DimCustomer ON DimCustomer.CustomerKey = FactInternetSales.CustomerKey
			JOIN DimGeography ON DimGeography.GeographyKey = DimCustomer.GeographyKey
				JOIN DimTime ON DimTime.TimeKey = FactInternetSales.OrderDateKey
				WHERE DimTime.CalendarYear = '2004'
GROUP BY StateProvinceName;


SELECT StateProvinceName, SUM(SalesAmount - TotalProductCost) AS MarginByState
FROM FactInternetSales
JOIN DimCustomer ON DimCustomer.CustomerKey = FactInternetSales.CustomerKey
JOIN DimGeography ON DimGeography.GeographyKey = DimCustomer.GeographyKey
JOIN DimTime ON DimTime.TimeKey = FactInternetSales.OrderDateKey
WHERE DimTime.CalendarYear = '2004'
GROUP BY StateProvinceName
ORDER BY MarginByState DESC;

SELECT StateProvinceName, SUM(SalesAmount - TotalProductCost - TaxAmt) AS MarginByState
FROM FactInternetSales
JOIN DimCustomer ON DimCustomer.CustomerKey = FactInternetSales.CustomerKey
JOIN DimGeography ON DimGeography.GeographyKey = DimCustomer.GeographyKey
JOIN DimTime ON DimTime.TimeKey = FactInternetSales.OrderDateKey
WHERE DimTime.CalendarYear = '2004'
GROUP BY StateProvinceName
ORDER BY MarginByState DESC;
