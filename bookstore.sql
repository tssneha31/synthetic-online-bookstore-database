
SELECT * FROM customers LIMIT 10;
SELECT * FROM books LIMIT 10;
SELECT * FROM orders LIMIT 10;
SELECT * FROM order_items LIMIT 10;

-- 1. Check Row Counts
SELECT COUNT(*) AS customer_count FROM customers;
SELECT COUNT(*) AS book_count FROM books;
SELECT COUNT(*) AS order_count FROM orders;
SELECT COUNT(*) AS order_item_count FROM order_items;

-- 2. Preview Data in Each Table (first 5)
SELECT * FROM customers LIMIT 5;
SELECT * FROM books LIMIT 5;
SELECT * FROM orders LIMIT 5;
SELECT * FROM order_items LIMIT 5;


-- -------------------------
-- Data understanding
-- -------------------------

-- 3. Customers: membership distribution
SELECT membership_level, COUNT(*) AS total_customers
FROM customers
GROUP BY membership_level
ORDER BY total_customers DESC;

-- 4. Orders: which delivery speed is used most?
SELECT delivery_speed, COUNT(*) AS total_orders
FROM orders
GROUP BY delivery_speed
ORDER BY total_orders DESC;

-- 5. Orders: payment method usage (most used)
SELECT payment_method, COUNT(*) AS total_orders
FROM orders
GROUP BY payment_method
ORDER BY total_orders DESC;

-- 6. Books: most common genre in catalogue
SELECT genre, COUNT(*) AS total_books
FROM books
GROUP BY genre
ORDER BY total_books DESC;

-- 7. Items: distribution of quantity (how many copies per line item)
SELECT quantity, COUNT(*) AS count_lines
FROM order_items
GROUP BY quantity
ORDER BY quantity;


-- -------------------------
-- Data preprocessing / initial data understanding
-- -------------------------

-- 8. Missing values per column (Customers)
SELECT
  SUM(CASE WHEN full_name IS NULL THEN 1 ELSE 0 END) AS missing_full_name,
  SUM(CASE WHEN email IS NULL THEN 1 ELSE 0 END) AS missing_email,
  SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS missing_gender,
  SUM(CASE WHEN membership_level IS NULL THEN 1 ELSE 0 END) AS missing_membership_level,
  SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS missing_age,
  SUM(CASE WHEN signup_year IS NULL THEN 1 ELSE 0 END) AS missing_signup_year
FROM customers;

-- 9. Missing values per column (Books)
SELECT
  SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS missing_title,
  SUM(CASE WHEN genre IS NULL THEN 1 ELSE 0 END) AS missing_genre,
  SUM(CASE WHEN publication_year IS NULL THEN 1 ELSE 0 END) AS missing_publication_year,
  SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS missing_price
FROM books;

-- 10. Missing values per column (Orders)
SELECT
  SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS missing_customer_id,
  SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) AS missing_order_date,
  SUM(CASE WHEN order_year IS NULL THEN 1 ELSE 0 END) AS missing_order_year,
  SUM(CASE WHEN delivery_speed IS NULL THEN 1 ELSE 0 END) AS missing_delivery_speed,
  SUM(CASE WHEN payment_method IS NULL THEN 1 ELSE 0 END) AS missing_payment_method,
  SUM(CASE WHEN discount_pct IS NULL THEN 1 ELSE 0 END) AS missing_discount_pct,
  SUM(CASE WHEN total_amount IS NULL THEN 1 ELSE 0 END) AS missing_total_amount
FROM orders;

-- 11. Missing values per column (Order Items)
SELECT
  SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS missing_quantity,
  SUM(CASE WHEN unit_price IS NULL THEN 1 ELSE 0 END) AS missing_unit_price
FROM order_items;

-- 12. Show rows with missing values (before treating them)
SELECT * FROM customers
WHERE full_name IS NULL OR email IS NULL OR gender IS NULL
   OR membership_level IS NULL OR age IS NULL OR signup_year IS NULL;

SELECT * FROM books
WHERE title IS NULL OR genre IS NULL OR publication_year IS NULL OR price IS NULL;

SELECT * FROM orders
WHERE customer_id IS NULL OR order_date IS NULL OR order_year IS NULL
   OR delivery_speed IS NULL OR payment_method IS NULL OR discount_pct IS NULL OR total_amount IS NULL;

SELECT * FROM order_items
WHERE quantity IS NULL OR unit_price IS NULL;


-- -------------------------
-- Data understanding with joins (possible only between orders and customers)
-- because orders has customer_id and customers has rowid or a customer_id in schema.
-- If your customers table has an actual customer_id column in SQLite, use it.
-- If not, see note below.
-- -------------------------

-- 13. Join: Orders with customer details (first 10)
-- If your customers table DOES have customer_id column, use:
-- JOIN customers c ON o.customer_id = c.customer_id
-- If customers table does NOT have customer_id, you cannot reliably join.
SELECT
  o.customer_id,
  c.full_name,
  c.membership_level,
  o.order_date,
  o.delivery_speed,
  o.payment_method,
  o.discount_pct,
  o.total_amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
LIMIT 10;

-- 14. Top customers by total spending (orders.total_amount)
SELECT
  c.full_name,
  SUM(o.total_amount) AS total_spend,
  COUNT(*) AS orders_placed
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.full_name
ORDER BY total_spend DESC
LIMIT 10;

-- 15. Spending by membership level (which tier buys more)
SELECT
  c.membership_level,
  SUM(o.total_amount) AS total_spend,
  COUNT(*) AS total_orders
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.membership_level
ORDER BY total_spend DESC;


-- -------------------------
-- Optional: Treat missing values (only if you choose to)
-- -------------------------

-- 16. Replace NULLs in numeric columns with 0 (example)
UPDATE customers SET age = 0 WHERE age IS NULL;
UPDATE customers SET signup_year = 0 WHERE signup_year IS NULL;

UPDATE books SET publication_year = 0 WHERE publication_year IS NULL;
UPDATE books SET price = 0 WHERE price IS NULL;

UPDATE orders SET discount_pct = 0 WHERE discount_pct IS NULL;
UPDATE orders SET total_amount = 0 WHERE total_amount IS NULL;

UPDATE order_items SET quantity = 0 WHERE quantity IS NULL;
UPDATE order_items SET unit_price = 0 WHERE unit_price IS NULL;

-- 17. Replace NULLs in text columns with 'unknown'
UPDATE customers SET email = 'unknown' WHERE email IS NULL;
UPDATE customers SET gender = 'unknown' WHERE gender IS NULL;
UPDATE customers SET membership_level = 'unknown' WHERE membership_level IS NULL;

UPDATE books SET genre = 'unknown' WHERE genre IS NULL;

UPDATE orders SET delivery_speed = 'unknown' WHERE delivery_speed IS NULL;
UPDATE orders SET payment_method = 'unknown' WHERE payment_method IS NULL;

-- 18. Check if any NULL values remain after treating
SELECT * FROM customers
WHERE full_name IS NULL OR email IS NULL OR gender IS NULL
   OR membership_level IS NULL OR age IS NULL OR signup_year IS NULL;

SELECT * FROM books
WHERE title IS NULL OR genre IS NULL OR publication_year IS NULL OR price IS NULL;

SELECT * FROM orders
WHERE customer_id IS NULL OR order_date IS NULL OR order_year IS NULL
   OR delivery_speed IS NULL OR payment_method IS NULL OR discount_pct IS NULL OR total_amount IS NULL;

SELECT * FROM order_items
WHERE quantity IS NULL OR unit_price IS NULL;

-- 19. Check replacements worked ('unknown' and 0)
SELECT * FROM customers
WHERE email = 'unknown' OR gender = 'unknown' OR membership_level = 'unknown'
   OR age = 0 OR signup_year = 0;

SELECT * FROM books
WHERE genre = 'unknown' OR publication_year = 0 OR price = 0;

SELECT * FROM orders
WHERE delivery_speed = 'unknown' OR payment_method = 'unknown'
   OR discount_pct = 0 OR total_amount = 0;

SELECT * FROM order_items
WHERE quantity = 0 OR unit_price = 0;