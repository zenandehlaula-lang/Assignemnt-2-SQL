✅ 1. Install MySQL
Windows / Mac / Linux

Download MySQL Community Server from:

👉 https://dev.mysql.com/downloads/mysql/

Install:

MySQL Server

MySQL Workbench

During installation:

Set a root password

Remember it (you will use it to log in)

✅ 2. Open MySQL Workbench

Open MySQL Workbench

Click your local connection

Log in using your MySQL password

✅ 3. Create a Database

In Workbench, run:

CREATE DATABASE cafe_sales;
USE cafe_sales;


This sets your default working database.

✅ 4. Import Your CSV Files
Import dirty_cafe_sales.csv

In the SCHEMAS panel → right-click your database → Table Data Import Wizard

Select dirty_cafe_sales.csv

Name the table: dirty_cafe_sales

Ensure all columns map correctly

Finish import

Import Price per item.csv

Repeat the same process and name the table:

item_price_lookup

✅ 5. Create the Clean Working Table

Copy the imported data into a new working table:

DROP TABLE IF EXISTS clean_cafe_sales;

CREATE TABLE clean_cafe_sales AS
SELECT * FROM dirty_cafe_sales;

✅ 6. Create Reference Table for Item Prices
CREATE SCHEMA IF NOT EXISTS ref;

CREATE TABLE ref.item_prices (
    Item VARCHAR(50) PRIMARY KEY,
    Price_Per_Unit DECIMAL(10,2)
);

INSERT INTO ref.item_prices (Item, Price_Per_Unit) VALUES
('Coffee', 2.00),
('Cake', 3.00),
('Cookie', 1.00),
('Salad', 5.00),
('Smoothie', 4.00),
('Sandwich', 4.00),
('Juice', 3.00),
('Tea', 1.50);

✅ 7. Use the Reference Table to Fix Missing Item or Price
UPDATE clean_cafe_sales c
JOIN ref.item_prices r
    ON c.Price_Per_Unit = r.Price_Per_Unit
SET c.Item = r.Item;

UPDATE clean_cafe_sales c
JOIN ref.item_prices r
    ON c.Item = r.Item
SET c.Price_Per_Unit = r.Price_Per_Unit;

✅ 8. Recalculate Price, Quantity, and Total Spent
SET SQL_SAFE_UPDATES = 0;

UPDATE clean_cafe_sales
SET Total_Spent = Price_Per_Unit * Quantity;

UPDATE clean_cafe_sales
SET Quantity = Total_Spent / Price_Per_Unit
WHERE Price_Per_Unit > 0;

UPDATE clean_cafe_sales
SET Price_Per_Unit = Total_Spent / Quantity
WHERE Quantity > 0;

SET SQL_SAFE_UPDATES = 1;

✅ 9. Create Final Table
DROP TABLE IF EXISTS final_cafe_sales;

CREATE TABLE final_cafe_sales AS
SELECT *
FROM clean_cafe_sales;

✅ 10. Clean Transaction_Date Column
Convert invalid date formats:
ALTER TABLE final_cafe_sales
MODIFY COLUMN Transaction_Date VARCHAR(50);

UPDATE final_cafe_sales
SET Transaction_Date = NULL
WHERE Transaction_Date = ''
   OR Transaction_Date = '0000-00-00'
   OR Transaction_Date IS NULL;

ALTER TABLE final_cafe_sales
MODIFY COLUMN Transaction_Date DATE;

Fill missing dates with latest valid date:
SET @latest_date = (
    SELECT MAX(Transaction_Date)
    FROM final_cafe_sales
);

UPDATE final_cafe_sales
SET Transaction_Date = @latest_date
WHERE Transaction_ID IN (
    SELECT Transaction_ID
    FROM (
        SELECT Transaction_ID
        FROM final_cafe_sales
        WHERE Transaction_Date IS NULL
    ) AS t
);

✅ 11. Delete Rows Where Total_Spent Is NULL
DELETE FROM final_cafe_sales
WHERE Transaction_ID IN (
    SELECT Transaction_ID
    FROM (
        SELECT Transaction_ID
        FROM final_cafe_sales
        WHERE Total_Spent IS NULL
    ) AS t
);

✅ 12. Count Total Rows
SELECT COUNT(*) AS number_of_rows
FROM final_cafe_sales;
