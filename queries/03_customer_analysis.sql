-- Task 09: Find the top 10 customers by lifetime purchase value.
-- Use only delivered orders when measuring completed sales.
SELECT c.customer_id,
       c.full_name,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS lifetime_value
FROM customers AS c
JOIN orders AS o
  ON o.customer_id = c.customer_id
JOIN order_items AS oi
  ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_id, c.full_name
ORDER BY lifetime_value DESC
LIMIT 10;
-- Result (top 10):
-- (132, 'Neda Rezaei', 36442.46)
-- (939, 'Arman Hosseini', 33223.71)
-- (1174, 'Kian Farhadi', 33185.5)
-- (1270, 'Sara Moradi', 31636.45)
-- (320, 'Nima Ebrahimi', 30919.26)
-- (31, 'Nima Hosseini', 30806.96)
-- (1161, 'Roya Karimi', 30000.63)
-- (42, 'Pouya Ebrahimi', 29940.37)
-- (272, 'Roya Farhadi', 29159.34)
-- (573, 'Mina Ebrahimi', 28869.84)


-- Task 10: Find customers with no orders.
-- Hint: LEFT JOIN ... WHERE ... IS NULL
SELECT c.customer_id,
       c.full_name
FROM customers AS c
LEFT JOIN orders AS o
  ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL
ORDER BY c.customer_id;
-- Result: 60 customers have no orders.
-- Sample rows:
-- (1341, 'Sara Kazemi')
-- (1342, 'Roya Jafari')
-- (1343, 'Darya Karimi')
-- (1344, 'Sara Jafari')
-- (1345, 'Mina Karimi')
-- (1346, 'Neda Rahimi')
-- (1347, 'Amir Moradi')
-- (1348, 'Parsa Rahimi')
-- (1349, 'Ava Karimi')
-- (1350, 'Parsa Rezaei')


-- Task 11: Find each customer's order count (include zero-order customers).
SELECT c.customer_id,
       c.full_name,
       COUNT(o.order_id) AS order_count
FROM customers AS c
LEFT JOIN orders AS o
  ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY order_count DESC, c.customer_id ASC;
-- Result: this query returns all 1,400 customers; the highest order counts are:
-- (503, 'Nima Farhadi', 17)
-- (939, 'Arman Hosseini', 17)
-- (1246, 'Sara Kazemi', 17)
-- (1337, 'Kian Farhadi', 17)
-- (73, 'Arman Kazemi', 16)
-- (573, 'Mina Ebrahimi', 16)
-- (683, 'Neda Karimi', 16)
-- (755, 'Pouya Hosseini', 16)
-- (1161, 'Roya Karimi', 16)
-- (197, 'Arman Rahimi', 15)


-- Task 12: Find orders with more than 3 different products.
-- Hint: COUNT(DISTINCT product_id) and HAVING
SELECT o.order_id,
       COUNT(DISTINCT oi.product_id) AS product_count
FROM orders AS o
JOIN order_items AS oi
  ON oi.order_id = o.order_id
GROUP BY o.order_id
HAVING COUNT(DISTINCT oi.product_id) > 3
ORDER BY product_count DESC, o.order_id ASC;
-- Result: 4,018 orders had more than 3 distinct products.
-- Sample rows:
-- (4, 5)
-- (8, 5)
-- (18, 5)
-- (19, 5)
-- (21, 5)
-- (31, 5)
-- (32, 5)
-- (33, 5)
-- (37, 5)
-- (63, 5)
