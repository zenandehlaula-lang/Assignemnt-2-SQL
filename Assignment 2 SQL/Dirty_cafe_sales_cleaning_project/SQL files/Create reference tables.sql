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



