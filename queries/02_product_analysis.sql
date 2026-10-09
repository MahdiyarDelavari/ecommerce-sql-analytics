-- Task 05: Find the 10 best-selling products by units sold.
SELECT p.product_id,
       p.product_name,
       SUM(oi.quantity) AS units_sold
FROM order_items AS oi
JOIN products AS p
  ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
ORDER BY units_sold DESC, p.product_name ASC
LIMIT 10;
-- Result:
-- (162, 'Studio Books Item', 388)
-- (93, 'Pro Office Item', 381)
-- (157, 'Studio Electronics Item', 381)
-- (34, 'Ultra Automotive Item', 380)
-- (169, 'Flex Electronics Item', 379)
-- (215, 'Select Pet Item', 373)
-- (210, 'Select Books Item', 370)
-- (75, 'Compact Home Item', 369)
-- (42, 'Everyday Books Item', 367)
-- (14, 'Classic Clothing Item', 366)


-- Task 06: Find the total sales revenue for each product category.
SELECT c.category_name,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue
FROM order_items AS oi
JOIN products AS p
  ON p.product_id = oi.product_id
JOIN categories AS c
  ON c.category_id = p.category_id
GROUP BY c.category_name
ORDER BY total_revenue DESC;
-- Result:
-- ('Electronics', 1974368.66)
-- ('Outdoors', 1967456.99)
-- ('Automotive', 1912980.32)
-- ('Pet', 1876847.55)
-- ('Books', 1784166.64)
-- ('Home', 1759081.89)
-- ('Clothing', 1637162.86)
-- ('Beauty', 1613628.07)
-- ('Office', 1496667.4)
-- ('Grocery', 1432432.69)
-- ('Toys', 1431382.22)
-- ('Sports', 1335485.0)


-- Task 07: Find products that have never appeared in order_items.
-- Hint: LEFT JOIN ... WHERE ... IS NULL
SELECT p.product_id,
       p.product_name
FROM products AS p
LEFT JOIN order_items AS oi
  ON oi.product_id = p.product_id
WHERE oi.order_item_id IS NULL
ORDER BY p.product_id;
-- Result:
-- (235, 'Lite Toys Item')
-- (236, 'Lite Grocery Item')
-- (237, 'Lite Office Item')
-- (238, 'Lite Automotive Item')
-- (239, 'Lite Pet Item')
-- (240, 'Lite Outdoors Item')


-- Task 08: Find categories with more than 1,000 units sold.
-- Hint: HAVING
SELECT c.category_name,
       SUM(oi.quantity) AS total_units_sold
FROM order_items AS oi
JOIN products AS p
  ON p.product_id = oi.product_id
JOIN categories AS c
  ON c.category_id = p.category_id
GROUP BY c.category_name
HAVING SUM(oi.quantity) > 1000
ORDER BY total_units_sold DESC;
-- Result:
-- ('Electronics', 6463)
-- ('Books', 6452)
-- ('Sports', 6336)
-- ('Beauty', 6322)
-- ('Clothing', 6295)
-- ('Home', 6292)
-- ('Automotive', 6246)
-- ('Grocery', 6209)
-- ('Office', 6095)
-- ('Pet', 6023)
-- ('Outdoors', 6013)
-- ('Toys', 5935)
