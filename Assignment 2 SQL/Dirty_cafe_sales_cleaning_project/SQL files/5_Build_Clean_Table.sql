USE cafe_sales;

---------------------------------------------------------
-- 1. Create final_cafe_sales from clean_cafe_sales
---------------------------------------------------------
DROP TABLE IF EXISTS final_cafe_sales;

CREATE TABLE final_cafe_sales AS
SELECT *
FROM clean_cafe_sales;

---------------------------------------------------------
-- 2. Replace empty or NULL Payment Method, Location,
--    and Transaction Date with 'Other'
---------------------------------------------------------

SET SQL_SAFE_UPDATES = 0;

-- Replace NULL or empty Payment Method
UPDATE final_cafe_sales
SET `Payment_Method` = 'Other'
WHERE `Payment_Method` IS NULL
   OR `Payment_Method` = '';

-- Replace NULL or empty Location
UPDATE final_cafe_sales
SET `Location` = 'Other'
WHERE `Location` IS NULL
   OR `Location` = '';



SET SQL_SAFE_UPDATES = 1;



ALTER TABLE final_cafe_sales
ADD PRIMARY KEY (Transaction_ID);



-- 1. Allow VARCHAR temporarily so invalid dates don't break conversion
ALTER TABLE final_cafe_sales
MODIFY COLUMN Transaction_Date VARCHAR(50);


-- 2. Convert invalid / empty dates to NULL
UPDATE final_cafe_sales c
JOIN (
    SELECT Transaction_ID
    FROM final_cafe_sales
    WHERE Transaction_Date = ''
       OR Transaction_Date = '0000-00-00'
       OR Transaction_Date IS NULL
) AS t ON c.Transaction_ID = t.Transaction_ID
SET c.Transaction_Date = NULL;


-- 3. Convert column back to DATE
ALTER TABLE final_cafe_sales
MODIFY COLUMN Transaction_Date DATE;


-- 4. capture latest valid date
SET @latest_date = (
    SELECT MAX(Transaction_Date)
    FROM final_cafe_sales
    WHERE Transaction_Date IS NOT NULL
);


-- 5. Fill NULL transaction dates with latest date (safe-mode compliant)
UPDATE final_cafe_sales c
JOIN (
    SELECT Transaction_ID
    FROM final_cafe_sales
    WHERE Transaction_Date IS NULL
) AS t ON c.Transaction_ID = t.Transaction_ID
SET c.Transaction_Date = @latest_date;


-- 6. Delete rows with NULL Total_Spent (safe-mode compliant)
DELETE c
FROM final_cafe_sales c
JOIN (
    SELECT Transaction_ID
    FROM final_cafe_sales
    WHERE Total_Spent IS NULL
) AS t ON c.Transaction_ID = t.Transaction_ID;

