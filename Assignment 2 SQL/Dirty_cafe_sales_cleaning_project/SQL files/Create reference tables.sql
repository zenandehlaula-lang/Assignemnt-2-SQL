DROP TABLE IF EXISTS clean_item_price;

CREATE TABLE clean_item_price AS
SELECT
    Item,
    MIN(CAST(`Price Per Unit` AS DECIMAL(10,2))) AS Price_Per_Unit
FROM dirty_cafe_sales
WHERE `Price Per Unit` REGEXP '^[0-9]+(\\.[0-9]+)?$'
  AND Item IS NOT NULL
  AND Item NOT IN ('UNKNOWN', 'ERROR')
GROUP BY Item;

DROP TABLE IF EXISTS clean_cafe_sales;

CREATE TABLE clean_cafe_sales AS
SELECT *
FROM dirty_cafe_sales;

-- Fix Item based on Price
UPDATE clean_cafe_sales c
JOIN ref.item_prices r
    ON c.Price_Per_Unit = r.Price_Per_Unit
SET c.Item = r.Item
WHERE c.Price_Per_Unit IS NOT NULL;

-- Fix Price based on Item
UPDATE clean_cafe_sales c
JOIN ref.item_prices r
    ON c.Item = r.item
SET c.Price_Per_Unit = r.Price_Per_Unit
WHERE c.Item IS NOT NULL;
