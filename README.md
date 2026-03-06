

# Synthetic Online Bookstore Database

## Project Overview

This project demonstrates the design and generation of a **relational SQL database for an online bookstore system**. The database was created using **Python, Pandas, NumPy, and SQLite** and simulates realistic bookstore operations such as customer registrations, book catalogues, and purchase transactions.

The dataset used in this project was **synthetically generated programmatically**, ensuring full control over the structure and allowing realistic database features such as missing values and varied data distributions.

The project satisfies the requirements of designing a database with multiple tables, relational keys, and diverse data types.

---

# Technologies Used

* Python
* Pandas
* NumPy
* SQLite
* SQL
* Jupyter Notebook

---

# Database Structure

The database consists of **four relational tables**:

### 1. Customers

Stores information about bookstore users.

| Column           | Description                              |
| ---------------- | ---------------------------------------- |
| customer_id      | Unique customer identifier (Primary Key) |
| full_name        | Customer full name                       |
| email            | Masked email address                     |
| gender           | Gender category                          |
| membership_level | Membership tier                          |
| age              | Customer age                             |
| signup_year      | Year customer joined                     |

---

### 2. Books

Contains information about books available in the store.

| Column           | Description                          |
| ---------------- | ------------------------------------ |
| book_id          | Unique book identifier (Primary Key) |
| title            | Title of the book                    |
| genre            | Book category                        |
| publication_year | Year of publication                  |
| price            | Book price                           |

---

### 3. Orders

Stores purchase transactions made by customers.

| Column         | Description                              |
| -------------- | ---------------------------------------- |
| order_id       | Unique order identifier (Primary Key)    |
| customer_id    | Customer placing the order (Foreign Key) |
| order_date     | Date of order                            |
| order_year     | Year of order                            |
| delivery_speed | Shipping option                          |
| payment_method | Payment method                           |
| discount_pct   | Discount applied                         |
| total_amount   | Total order value                        |

---

### 4. Order_Items

Stores the individual books included in each order.

| Column     | Description                    |
| ---------- | ------------------------------ |
| order_id   | Order identifier (Foreign Key) |
| book_id    | Book identifier (Foreign Key)  |
| quantity   | Number of copies purchased     |
| unit_price | Price of book at purchase      |

This table uses a **composite primary key (order_id, book_id)** to prevent duplicate book entries within the same order.

---

# Database Relationships

The database follows a relational structure:

Customers → Orders → Order_Items ← Books

* A customer can place multiple orders.
* Each order can contain multiple books.
* A book can appear in many different orders.

---

# Data Generation

The data was generated using **Python with Pandas and NumPy**.

Key features of the generated data include:

* Randomized customer profiles
* Programmatically generated book titles
* Realistic book prices using log-normal distributions
* Random order dates between 2024 and 2026
* Multiple books per order
* Intentional missing values to simulate real-world database imperfections

---

# Database Realism

To replicate real-world datasets:

* Missing values were deliberately introduced in several attributes.
* Customers may place multiple orders.
* Books may appear in multiple transactions.
* Categories such as genre and payment method contain repeated values reflecting real purchasing patterns.

---

# Ethical and Privacy Considerations

All data in this project is **synthetic** and does not represent real individuals.

To demonstrate privacy-aware practices:

* Email addresses were **partially masked**.
* No real personal data was used.

This approach avoids privacy concerns and aligns with responsible data handling practices.

---

# Repository Structure

```
synthetic-online-bookstore-database
│
├── customers.csv
├── books.csv
├── orders.csv
├── order_items.csv
│
├── bookstore.sql
├── bookstore table creation.sql
│
├── sqldatabase.ipynb
│
├── ER Diagram.png
│
├── sneha_bookstore.sqbpro
│
└── LICENSE
```

---

# SQL Features Implemented

* Primary Keys
* Foreign Keys
* Composite Keys
* Relational Schema Design
* Data Quality Checks
* Aggregation Queries
* Data Understanding Queries

---

# ER Diagram

The repository includes an **Entity Relationship Diagram (ERD)** showing the relationships between the tables.

---

# Author

Sneha
MSc Data Science
University Assignment Project

