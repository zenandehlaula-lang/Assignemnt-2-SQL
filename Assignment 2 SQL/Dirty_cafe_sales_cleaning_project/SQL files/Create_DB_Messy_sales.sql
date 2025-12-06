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

LOAD DATA LOCAL INFILE ''
INTO TABLE dirty_cafe_sales
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(`Transaction ID`, `Item`, `Quantity`, `Price Per Unit`,
 `Total Spent`, `Payment Method`, `Location`, `Transaction Date`);

