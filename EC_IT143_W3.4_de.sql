/*****************************************************************************************************************
NAME:    EC_IT143_W3.4_de.sql
PURPOSE: Answer eight AdventureWorks2022 questions using SQL queries, joins, aggregate functions,
         filtering, sorting, and INFORMATION_SCHEMA metadata views.

MODIFICATION LOG:
Ver      Date        Author          Description
-----   ----------   -------------   -------------------------------------------------------------------------------
1.0     11/09/2026   David Ebedot    Created this script for the IT143 W3.4 AdventureWorks Create Answers assignment.

RUNTIME:
Approximately 10 seconds or less (estimated; actual runtime depends on the SQL Server environment).

NOTES:
This script answers eight questions originally submitted by Olympe Usabe for the IT143 3.3
Adventure Works—Create Questions discussion. The queries use the AdventureWorks2022 sample
database. Each question is documented with its original author, purpose, and estimated runtime.
The script uses SELECT statements only and does not modify database records.

******************************************************************************************************************/

USE AdventureWorks2022;
GO

/******************************************************************************************************************
Q1: Which ten products have the highest list prices?
Original Author: Olympe Usabe
Purpose: Identify the ten most expensive products by list price.
Estimated Runtime: Less than 1 second.
******************************************************************************************************************/

SELECT TOP 10
    ProductID,
    Name AS ProductName,
    ListPrice
FROM Production.Product
ORDER BY ListPrice DESC;
GO

/******************************************************************************************************************
Q2: How many products have a list price above $3,000?
Original Author: Olympe Usabe
Purpose: Count products with a list price greater than $3,000.
Estimated Runtime: Less than 1 second.
******************************************************************************************************************/

SELECT
    COUNT(*) AS NumberOfProducts
FROM Production.Product
WHERE ListPrice > 3000;
GO

/******************************************************************************************************************
Q3: Which product names and subcategory names are included in the Bikes category?
Original Author: Olympe Usabe
Purpose: List bicycle products and their subcategories by joining three related tables.
Estimated Runtime: Less than 1 second.
******************************************************************************************************************/

SELECT
    p.Name AS ProductName,
    ps.Name AS SubcategoryName
FROM Production.Product AS p
INNER JOIN Production.ProductSubcategory AS ps
    ON p.ProductSubcategoryID = ps.ProductSubcategoryID
INNER JOIN Production.ProductCategory AS pc
    ON ps.ProductCategoryID = pc.ProductCategoryID
WHERE pc.Name = 'Bikes'
ORDER BY
    ps.Name,
    p.Name;
GO

/******************************************************************************************************************
Q4: Which vendors supply each product, and what standard price does each vendor list for that product?
Original Author: Olympe Usabe
Purpose: Display vendor names, supplied products, and their standard prices.
Estimated Runtime: Less than 1 second.
******************************************************************************************************************/

SELECT
    v.Name AS VendorName,
    p.Name AS ProductName,
    pv.StandardPrice
FROM Purchasing.ProductVendor AS pv
INNER JOIN Purchasing.Vendor AS v
    ON pv.BusinessEntityID = v.BusinessEntityID
INNER JOIN Production.Product AS p
    ON pv.ProductID = p.ProductID
ORDER BY
    v.Name,
    p.Name;
GO

/******************************************************************************************************************
Q5: For orders placed during calendar year 2013, show each sales territory and its total order amount,
    including tax and freight. Sort territories from highest to lowest total.
Original Author: Olympe Usabe
Purpose: Compare sales performance across territories using each order's TotalDue amount.
Estimated Runtime: Less than 1 second.
******************************************************************************************************************/

SELECT
    st.Name AS SalesTerritory,
    SUM(soh.TotalDue) AS TotalOrderAmount
FROM Sales.SalesOrderHeader AS soh
INNER JOIN Sales.SalesTerritory AS st
    ON soh.TerritoryID = st.TerritoryID
WHERE soh.OrderDate >= '20130101'
    AND soh.OrderDate < '20140101'
GROUP BY
    st.Name
ORDER BY
    TotalOrderAmount DESC;
GO

/******************************************************************************************************************
Q6: For every product with inventory records, total the quantity across its inventory locations.
    Show only products with fewer than 100 recorded units and sort from the lowest total upward.
Original Author: Olympe Usabe
Purpose: Identify products with low recorded inventory by summing quantities across locations.
Estimated Runtime: Less than 1 second.
******************************************************************************************************************/

SELECT
    p.ProductID,
    p.Name AS ProductName,
    SUM(pi.Quantity) AS TotalInventory
FROM Production.Product AS p
INNER JOIN Production.ProductInventory AS pi
    ON p.ProductID = pi.ProductID
GROUP BY
    p.ProductID,
    p.Name
HAVING SUM(pi.Quantity) < 100
ORDER BY
    TotalInventory ASC;
GO

/******************************************************************************************************************
Q7: Using the INFORMATION_SCHEMA.COLUMNS view, what are the column names and data types defined
    for the Production.Product table?
Original Author: Olympe Usabe
Purpose: Display column names and data types for the Production.Product table.
Estimated Runtime: Less than 1 second.
******************************************************************************************************************/

SELECT
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'Production'
    AND TABLE_NAME = 'Product'
ORDER BY
    ORDINAL_POSITION;
GO

/******************************************************************************************************************
Q8: Using the INFORMATION_SCHEMA.TABLES view, what are the names and table types of user tables
    in the Production schema?
Original Author: Olympe Usabe
Purpose: Identify base tables within the Production schema.
Estimated Runtime: Less than 1 second.
******************************************************************************************************************/

SELECT
    TABLE_NAME,
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'Production'
    AND TABLE_TYPE = 'BASE TABLE'
ORDER BY
    TABLE_NAME;
GO
