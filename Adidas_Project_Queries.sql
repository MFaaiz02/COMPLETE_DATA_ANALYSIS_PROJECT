-- CREATING DATABSE
CREATE DATABASE AdidasDB;
USE AdidasDB;

-- CREATING A TABLE
CREATE TABLE AdidasSales (
    Retailer            VARCHAR(100),
    Retailer_ID         VARCHAR(50),
    Invoice_Date        VARCHAR(50),
    Region              VARCHAR(50),
    State               VARCHAR(50),
    City                VARCHAR(50),
    Product             VARCHAR(100),
    Price_per_Unit      VARCHAR(50),
    Units_Sold          VARCHAR(50),
    Total_Sales         VARCHAR(50),
    Operating_Profit    VARCHAR(50),
    Sales_Method        VARCHAR(50)
);

SELECT * FROM AdidasSales;

-- WE IMPORTED THE DATA AS VARCHAR 
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'AdidasSales';

-- CHANGED THE DATATYPES MANNUALLY IN SQL 
ALTER TABLE AdidasSales ALTER COLUMN Retailer VARCHAR(100);

ALTER TABLE AdidasSales ALTER COLUMN Retailer_ID INT;

ALTER TABLE AdidasSales ALTER COLUMN Invoice_Date DATE;

ALTER TABLE AdidasSales ALTER COLUMN Region VARCHAR(50);

ALTER TABLE AdidasSales ALTER COLUMN State VARCHAR(50);

ALTER TABLE AdidasSales ALTER COLUMN City VARCHAR(50);

ALTER TABLE AdidasSales ALTER COLUMN Product VARCHAR(100);

ALTER TABLE AdidasSales ALTER COLUMN Price_per_Unit DECIMAL(10,2);

ALTER TABLE AdidasSales ALTER COLUMN Units_Sold INT;

ALTER TABLE AdidasSales ALTER COLUMN Total_Sales DECIMAL(20,2);

ALTER TABLE AdidasSales ALTER COLUMN Operating_Profit DECIMAL(12,2);

ALTER TABLE AdidasSales ALTER COLUMN Sales_Method VARCHAR(50);

-- CHECKED DATATYPES
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'AdidasSales';

-- one spelling mistake found in PRODUCT CATEGORY
UPDATE AdidasSales SET Product = 'Men''s Apparel' WHERE Product = 'Men''s aparel';

------------------------------------ BUISNESS PROBLEMS AND SOLUTIONS ------------------------------------

------------------------------------------ BEGINNER LEVEL -----------------------------------------------

-- Query 1: Show total revenue generated from all Adidas sales.
SELECT 
    SUM(TOTAL_SALES) AS TOTAL_REVENUE
FROM
    ADIDASSALES;

-- Query 2: Find total units sold overall.
SELECT 
    SUM(UNITS_SOLD) AS TOTAL_UNITS_SOLD
FROM
    ADIDASSALES;

-- Query 3: Count total number of transactions.
SELECT 
    COUNT(*) AS Total_Transactions
FROM
    ADIDASSALES;

-- Query 4: List unique products sold.
SELECT DISTINCT
    Product AS CATEGORIES
FROM
    ADIDASSALES;

-- Query 5: Show total revenue by product category.
SELECT 
    PRODUCT AS CATEGORY, SUM(TOTAL_SALES) AS TOTAL_REVENUE
FROM
    ADIDASSALES
GROUP BY PRODUCT;

-- Query 6: Find total revenue generated per state.
SELECT 
    STATE, SUM(TOTAL_SALES) AS TOTAL_REVENUE
FROM
    ADIDASSALES
GROUP BY State
ORDER BY TOTAL_REVENUE DESC;

-- Query 7: Total number of retailers participated in sales.
SELECT 
    COUNT(DISTINCT Retailer) AS Total_Retailers
FROM
    AdidasSales;

-- Query 8: Find total revenue per year.
SELECT 
    YEAR(Invoice_Date) AS Year,
    SUM(TOTAL_SALES) AS total_revenue
FROM
    AdidasSales
GROUP BY YEAR(Invoice_Date)
ORDER BY YEAR(Invoice_Date);

-- Query 9: Find total units sold each year.
SELECT 
    YEAR(Invoice_Date) AS Year,
    SUM(Units_Sold) AS TOAL_UNITS_SOLD
FROM
    AdidasSales
GROUP BY YEAR(Invoice_Date)
ORDER BY YEAR(Invoice_Date);

-- Query 10: Show revenue contribution percentage of each product category.
SELECT 
    Product AS Category,
    CONCAT(ROUND((SUM(Total_Sales) * 100.0) / (SELECT 
                            SUM(Total_Sales)
FROM
    AdidasSales),1),'%') AS Sales_Percentage
FROM
    AdidasSales
GROUP BY Product
ORDER BY Sales_Percentage DESC;


------------------------------------------ INTERMEDIATE LEVEL -----------------------------------------------
-- Query 11: Top 5 highest revenue-generating states.
SELECT 
        TOP 5 State,
        SUM(TOTAL_SALES) AS TOTAL_REVENUE
FROM AdidasSales
GROUP BY State
ORDER BY TOTAL_REVENUE DESC;

-- Query 12: Top 5 most profitable product categories.
SELECT 
        TOP 5 Product AS Category,
        SUM(Operating_Profit) AS Total_Profit
FROM AdidasSales
GROUP BY Product
ORDER BY Total_Profit DESC;

-- Query 13: Revenue + Profit summary by region.
SELECT Region,
       SUM(Total_Sales) AS Total_Revenue,
       SUM(Operating_Profit) AS Total_Profit
FROM AdidasSales
GROUP BY Region
ORDER BY Total_Revenue DESC;

-- Query 14: Top 10 cities by total sales revenue.
SELECT
        TOP 10 City,
        SUM(TOTAL_SALES) AS TOTAL_REVENUE
FROM AdidasSales
GROUP BY CITY
ORDER BY TOTAL_REVENUE DESC;

-- Query 15: Average revenue per unit sold for each product category.
SELECT Product AS Category,
       ROUND(SUM(Total_Sales) / SUM(Units_Sold),2) AS Avg_Revenue_Per_Unit
FROM AdidasSales
GROUP BY Product
ORDER BY Avg_Revenue_Per_Unit DESC;

-- Query 16: Show year-wise monthly sales trend to compare revenue performance across different years.
SELECT YEAR(Invoice_Date) AS Year, DATENAME(MONTH, Invoice_Date) AS Month,
       SUM(Total_Sales) AS Total_Revenue
FROM AdidasSales
GROUP BY YEAR(Invoice_Date), DATENAME(MONTH, Invoice_Date), MONTH(Invoice_Date)
ORDER BY Year, MONTH(Invoice_Date);

-- Query 17: Revenue & Profit comparison by Retailer.
SELECT RETAILER,SUM(TOTAL_SALES) AS TOTAL_REVENUE,
       SUM(Operating_Profit) AS TOTAL_PROFITS
FROM AdidasSales
GROUP BY RETAILER
ORDER BY TOTAL_REVENUE DESC;
       
-- Query 18: Which state has the highest average profit per unit sold?
SELECT TOP 1 State,
       SUM(Operating_Profit) / SUM(Units_Sold) AS Avg_Profit_Per_Unit
FROM AdidasSales
GROUP BY State
ORDER BY Avg_Profit_Per_Unit DESC;

-- Query 19: Find the most profitable sales method based on total profit.
SELECT Sales_Method,
       SUM(Operating_Profit) AS Total_Profit
FROM AdidasSales
GROUP BY Sales_Method
ORDER BY Total_Profit DESC;

-- Query 20: Revenue + Units Sold + Profit all compared by year.
SELECT YEAR(INVOICE_DATE) AS YEAR,
       SUM(TOTAL_SALES) AS TOTAL_REVENUE,
       SUM(UNITS_SOLD) AS TOTAL_UNITS_SOLD,
       SUM(OPERATING_PROFIT) AS TOTAL_PROFIT
FROM AdidasSales
GROUP BY YEAR(INVOICE_DATE)
ORDER BY YEAR;

------------------------------------------ ADVANCE LEVEL -----------------------------------------------
-- Query 21: Find the top-performing state within each region based on total revenue.
WITH RANKED_STATES AS
(SELECT 
        REGION,STATE,
        SUM(TOTAL_SALES) AS REVENUE,
        RANK() OVER (PARTITION BY Region ORDER BY SUM(Total_Sales) DESC) AS Rank_No
FROM AdidasSales
GROUP BY Region,State
)
SELECT REGION,STATE,REVENUE
FROM RANKED_STATES
WHERE RANK_NO = 1;

-- Q22: Find top 3 revenue-generating cities within each product category.
WITH RankedCitySales AS 
( SELECT Product,
           City,
           SUM(Total_Sales) AS Revenue,
           RANK() OVER (PARTITION BY Product ORDER BY SUM(Total_Sales) DESC) AS Rank_No
    FROM AdidasSales
    GROUP BY Product, City
)
SELECT Product, City, Revenue
FROM RankedCitySales
WHERE Rank_No <= 3
ORDER BY Product, Revenue DESC;

-- QUERY Q23: Identify the month with the highest sales in each year.
WITH YearMonthSales AS (
    SELECT YEAR(Invoice_Date) AS Year,
           DATENAME(MONTH, Invoice_Date) AS Month,
           SUM(Total_Sales) AS Revenue,
           RANK() OVER (PARTITION BY YEAR(Invoice_Date)
                        ORDER BY SUM(Total_Sales) DESC) AS Rank_No
    FROM AdidasSales
    GROUP BY YEAR(Invoice_Date), DATENAME(MONTH, Invoice_Date), MONTH(Invoice_Date)
)
SELECT Year, Month, Revenue
FROM YearMonthSales
WHERE Rank_No = 1
ORDER BY Year;

-- QUERY 24: Identify the most profitable retailer in each state.
WITH RANKED_RETAILERS AS (
    SELECT STATE, RETAILER,
           SUM(OPERATING_PROFIT) AS TOTAL_PROFIT,
           RANK() OVER(PARTITION BY STATE ORDER BY SUM(Operating_Profit) DESC) AS Rank_No
    FROM AdidasSales
    GROUP BY State, Retailer
)
SELECT State, Retailer, Total_Profit
FROM Ranked_Retailers
WHERE Rank_No = 1
ORDER BY Total_Profit DESC;

-- QUERY 25: Which product category shows the highest year-over-year revenue growth?
WITH YearWise AS(
    SELECT Product,
           YEAR(Invoice_Date) AS Sales_Year,
           SUM(Total_Sales) AS Revenue
    FROM AdidasSales
    GROUP BY Product, YEAR(Invoice_Date)
)
SELECT CurrentData.Product,
       CurrentData.Sales_Year,
       ((CurrentData.Revenue - PreviousData.Revenue)*100.0)/PreviousData.Revenue AS YoY_Growth_Percentage
FROM YearWise AS CurrentData
JOIN YearWise AS PreviousData
     ON CurrentData.Product = PreviousData.Product
    AND CurrentData.Sales_Year = PreviousData.Sales_Year + 1
ORDER BY YoY_Growth_Percentage DESC;

