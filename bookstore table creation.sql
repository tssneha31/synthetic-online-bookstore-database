PRAGMA foreign_keys = ON;

-- 1) Customers
DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
  customer_id       INTEGER PRIMARY KEY,
  full_name         TEXT NOT NULL,
  email             TEXT,  -- can be NULL
  gender            TEXT NOT NULL CHECK (gender IN ('Male','Female','Other')),
  membership_level  TEXT NOT NULL CHECK (membership_level IN ('Basic','Silver','Gold')),
  age               INTEGER CHECK (age BETWEEN 16 AND 100), -- can be NULL
  signup_year       INTEGER CHECK (signup_year BETWEEN 2016 AND 2027) -- can be NULL
);

-- 2) Books
DROP TABLE IF EXISTS books;
CREATE TABLE books (
  book_id           TEXT PRIMARY KEY,
  title             TEXT NOT NULL,
  genre             TEXT, -- can be NULL
  publication_year  INTEGER CHECK (publication_year BETWEEN 1800 AND 2027), -- can be NULL
  price             REAL CHECK (price >= 0) -- can be NULL
);

-- 3) Orders
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  order_id         INTEGER PRIMARY KEY,
  customer_id      INTEGER NOT NULL,
  order_date       TEXT NOT NULL, -- store as ISO date 'YYYY-MM-DD'
  order_year       INTEGER CHECK (order_year BETWEEN 2000 AND 2030),
  delivery_speed   TEXT CHECK (delivery_speed IN ('Standard','Express','Next-day')), -- can be NULL
  payment_method   TEXT CHECK (payment_method IN ('Card','PayPal','BankTransfer')),  -- can be NULL
  discount_pct     INTEGER CHECK (discount_pct IN (0,5,10,15,20)), -- can be NULL
  total_amount     REAL NOT NULL DEFAULT 0 CHECK (total_amount >= 0),

  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

-- 4) Order Items (Composite Key)
DROP TABLE IF EXISTS order_items;
CREATE TABLE order_items (
  order_id     INTEGER NOT NULL,
  book_id      TEXT NOT NULL,
  quantity     INTEGER CHECK (quantity >= 1), -- can be NULL
  unit_price   REAL CHECK (unit_price >= 0),  -- can be NULL

  PRIMARY KEY (order_id, book_id),

  FOREIGN KEY (order_id) REFERENCES orders(order_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,

  FOREIGN KEY (book_id) REFERENCES books(book_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

-- Helpful indexes (optional but realistic)
CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_order_items_book_id ON order_items(book_id);