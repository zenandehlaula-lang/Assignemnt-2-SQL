DROP DATABASE IF EXISTS `cafe_sales`;
CREATE DATABASE `cafe_sales`;
USE `cafe_sales`;


CREATE TABLE dirty_cafe_sales (
  Transaction_ID VARCHAR(30),
  Item VARCHAR(30),
  Quantity INT,
  Price_per_unit INT,
  Total_spent INT,
  Location VARCHAR (30),
  Transaction_date DATE
  );

LOAD DATA LOCAL INFILE 'Assignment 2 SQL/Dirty_cafe_sales_cleaning_project/data/dirty_cafe_sales.csv'
INTO TABLE dirty_cafe_sales
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(`Transaction ID`, `Item`, `Quantity`, `Price Per Unit`,
 `Total Spent`, `Payment Method`, `Location`, `Transaction Date`);

-- Verify load
SELECT COUNT(*) as total_rows FROM dirty_cafe_sales;
-- Expected: 10 000

-- Show first 10 rows with all issues visible
SELECT * FROM dirty_cafe_sales LIMIT 10;
SELECT 
    'Data Quality Issues Summary' as category,
    COUNT(*) as issue_count,
    'See details below' as notes
FROM dirty_cafe_sales
UNION ALL 
SELECT 
    'Duplicate Transaction ID' AS category,
    COUNT(*) - COUNT(DISTINCT `Transaction ID`) AS issue_count,
    CONCAT(
        'Duplicates: ',
        (SELECT GROUP_CONCAT(`Transaction ID`)
         FROM (
             SELECT `Transaction ID`
             FROM dirty_cafe_sales
             GROUP BY `Transaction ID`
             HAVING COUNT(*) > 1
         ) AS d)
    ) AS notes
FROM dirty_cafe_sales

UNION ALL
SELECT 
    'Invalid/missing items' as category,
    COUNT(*) as issue_count,
    'Rows without valid identifier' as notes
FROM dirty_cafe_sales
WHERE `Item` IS NULL OR `Item` = 'ERROR' OR `Item` = 'UNKNOWN' OR `Item` = ''

UNION ALL
SELECT 
    'Invalid/missing Quantity' as category,
    COUNT(*) as issue_count,
    'Rows without valid identifier' as notes
FROM dirty_cafe_sales
WHERE `Quantity` IS NULL OR `Quantity` = 'ERROR' OR `Quantity` = 'UNKNOWN' OR `Quantity` = ''

UNION ALL
SELECT 
    'Invalid/missing total spent' as category,
    COUNT(*) as issue_count,
    'Rows without valid identifier' as notes
FROM dirty_cafe_sales
WHERE `Total Spent` IS NULL OR `Total Spent` = 'ERROR' OR `Total Spent` = 'UNKNOWN' OR `Total spent` = ''

UNION ALL
SELECT 
    'Invalid/missing Payment Method' as category,
    COUNT(*) as issue_count,
    'Rows without valid identifier' as notes
FROM dirty_cafe_sales
WHERE `Payment Method` IS NULL OR `Payment Method` = 'ERROR' OR `Payment Method` = 'UNKNOWN' OR `Payment Method` = ''

UNION ALL
SELECT 
    'Invalid/missing Location' as category,
    COUNT(*) as issue_count,
    'Rows without valid identifier' as notes
FROM dirty_cafe_sales
WHERE `Location` IS NULL OR `Location` = 'ERROR' OR `Location` = 'UNKNOWN' OR `Location` = ''

UNION ALL
SELECT 
    'Invalid/missing Quantity' as category,
    COUNT(*) as issue_count,
    'Rows without valid identifier' as notes
FROM dirty_cafe_sales
WHERE `Quantity` IS NULL OR `Quantity` = 'ERROR' OR `Quantity` = 'UNKNOWN' OR `Quantity` = ''
    
UNION ALL
SELECT 
    'Invalid/missing Transaction Date' as category,
    COUNT(*) as issue_count,
    'Rows without valid identifier' as notes
FROM dirty_cafe_sales
WHERE `Transaction Date` IS NULL OR `Transaction Date` = 'ERROR' OR `Transaction Date` = 'UNKNOWN' OR `Transaction Date` = ''
