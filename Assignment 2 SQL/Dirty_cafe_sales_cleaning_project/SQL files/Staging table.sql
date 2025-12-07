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
