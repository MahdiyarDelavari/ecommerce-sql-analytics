-- Task 01: Count all orders.
SELECT COUNT(*) AS total_orders
FROM orders;
-- Result:
-- (10000,)


-- Task 02: Calculate total revenue by order status.
-- Revenue = SUM(order_items.quantity * order_items.unit_price)
SELECT o.order_status,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_revenue
FROM orders AS o
JOIN order_items AS oi
  ON oi.order_id = o.order_id
GROUP BY o.order_status
ORDER BY total_revenue DESC;
-- Result:
-- ('delivered', 16508001.43)
-- ('shipped', 1706214.28)
-- ('pending', 1237778.8)
-- ('canceled', 769665.78)


-- Task 03: Count orders per city (highest first).
SELECT c.city,
       COUNT(o.order_id) AS order_count
FROM customers AS c
JOIN orders AS o
  ON o.customer_id = c.customer_id
GROUP BY c.city
ORDER BY order_count DESC, c.city ASC;
-- Result:
-- ('Shiraz', 1192)
-- ('Qom', 1113)
-- ('Ahvaz', 1066)
-- ('Karaj', 1055)
-- ('Mashhad', 1026)
-- ('Isfahan', 987)
-- ('Yazd', 963)
-- ('Rasht', 957)
-- ('Tehran', 881)
-- ('Tabriz', 760)


-- Task 04: Find revenue per month for delivered orders.
-- Hint: strftime('%Y-%m', order_date) works with ISO dates in SQLite.
SELECT strftime('%Y-%m', o.order_date) AS order_month,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM orders AS o
JOIN order_items AS oi
  ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY strftime('%Y-%m', o.order_date)
ORDER BY order_month ASC;
-- Result:
-- ('2025-01', 775662.66)
-- ('2025-02', 634953.18)
-- ('2025-03', 747352.77)
-- ('2025-04', 873635.28)
-- ('2025-05', 807856.31)
-- ('2025-06', 788148.0)
-- ('2025-07', 807468.36)
-- ('2025-08', 816380.05)
-- ('2025-09', 681941.45)
-- ('2025-10', 788679.91)
-- ('2025-11', 778754.55)
-- ('2025-12', 810246.12)
-- ('2026-01', 832691.91)
-- ('2026-02', 752035.66)
-- ('2026-03', 870552.89)
-- ('2026-04', 728755.81)
-- ('2026-05', 794464.78)
-- ('2026-06', 787514.1)
-- ('2026-07', 864356.59)
-- ('2026-08', 795666.39)
-- ('2026-09', 770884.66)
