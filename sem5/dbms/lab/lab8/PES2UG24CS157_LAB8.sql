-- Task 1.1
SELECT @@SESSION.transaction_isolation AS Session_Level, @@GLOBAL.transaction_isolation AS Global_Level;

-- Task 2.1
CREATE DATABASE ecommerce_db;
-- Task 2.1
USE ecommerce_db;
-- Task 2.1
CREATE TABLE Customer (customer_id INT PRIMARY KEY AUTO_INCREMENT, full_name VARCHAR(100) NOT NULL, email VARCHAR(150) UNIQUE NOT NULL, city VARCHAR(50) NOT NULL);
-- Task 2.1
CREATE TABLE Product (product_id INT PRIMARY KEY AUTO_INCREMENT, product_name VARCHAR(100) NOT NULL, category VARCHAR(50) NOT NULL, price DECIMAL(10,2) NOT NULL, stock_quantity INT NOT NULL, status ENUM('Active','Inactive') DEFAULT 'Active', INDEX idx_category (category));
-- Task 2.1
CREATE TABLE Orders (order_id INT PRIMARY KEY AUTO_INCREMENT, customer_id INT NOT NULL, product_id INT NOT NULL, quantity INT NOT NULL, total_amount DECIMAL(12,2) NOT NULL, order_status ENUM('Pending','Confirmed','Cancelled') DEFAULT 'Pending', FOREIGN KEY (customer_id) REFERENCES Customer(customer_id), FOREIGN KEY (product_id) REFERENCES Product(product_id));

-- Task 2.2
INSERT INTO Customer (full_name, email, city) VALUES ('Ananya Rao','ananya.rao@example.com','Bengaluru'),('Karan Mehta','karan.mehta@example.com','Mumbai'),('Sofia Khan','sofia.khan@example.com','Delhi');
-- Task 2.2
INSERT INTO Product (product_name, category, price, stock_quantity, status) VALUES ('Laptop Pro 14','Electronics',85000.00,20,'Active'),('Wireless Headphones','Electronics',6500.00,35,'Active'),('Office Chair','Furniture',12000.00,12,'Active'),('Mechanical Keyboard','Electronics',4500.00,25,'Active');
-- Task 2.2
INSERT INTO Orders (customer_id, product_id, quantity, total_amount, order_status) VALUES (1,1,1,85000.00,'Pending'),(2,2,2,13000.00,'Confirmed'),(3,3,1,12000.00,'Confirmed');

-- Task 2.3
SELECT * FROM Customer;
-- Task 2.3
SELECT * FROM Product;
-- Task 2.3
SELECT * FROM Orders;

-- Task 3.1 (Session 1)
USE ecommerce_db;
-- Task 3.1 (Session 1)
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
-- Task 3.1 (Session 1)
START TRANSACTION;
-- Task 3.1 (Session 1)
UPDATE Product SET stock_quantity = 5 WHERE product_id = 1;

-- Task 3.2 (Session 2)
USE ecommerce_db;
-- Task 3.2 (Session 2)
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
-- Task 3.2 (Session 2)
START TRANSACTION;
-- Task 3.2 (Session 2)
SELECT product_id, product_name, stock_quantity FROM Product WHERE product_id = 1;
-- Task 3.2 (Session 2)
ROLLBACK;
-- Task 3.2 (Session 1)
ROLLBACK;
-- Task 3.2 (Session 1)
SELECT stock_quantity FROM Product WHERE product_id = 1;

-- Task 4.1 (Session 1)
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- Task 4.1 (Session 1)
START TRANSACTION;
-- Task 4.1 (Session 1)
SELECT stock_quantity FROM Product WHERE product_id = 1;

-- Task 4.2 (Session 2)
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- Task 4.2 (Session 2)
START TRANSACTION;
-- Task 4.2 (Session 2)
UPDATE Product SET stock_quantity = 18 WHERE product_id = 1;
-- Task 4.2 (Session 2)
COMMIT;

-- Task 4.3 (Session 1)
SELECT stock_quantity FROM Product WHERE product_id = 1;
-- Task 4.3 (Session 1)
COMMIT;

-- Task 5.1 (Session 1)
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
-- Task 5.1 (Session 1)
START TRANSACTION;
-- Task 5.1 (Session 1)
SELECT product_id, product_name, price, stock_quantity FROM Product WHERE category = 'Electronics' AND status = 'Active';

-- Task 5.2 (Session 2)
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
-- Task 5.2 (Session 2)
START TRANSACTION;
-- Task 5.2 (Session 2)
UPDATE Product SET price = 7000.00 WHERE product_id = 2;
-- Task 5.2 (Session 2)
COMMIT;

-- Task 5.3 (Session 1)
SELECT product_id, product_name, price, stock_quantity FROM Product WHERE category = 'Electronics' AND status = 'Active';
-- Task 5.3 (Session 1)
COMMIT;

-- Task 6.1 (Session 1)
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- Task 6.1 (Session 1)
START TRANSACTION;
-- Task 6.1 (Session 1)
SELECT product_id, product_name, category, status FROM Product WHERE category = 'Electronics' AND status = 'Active';

-- Task 6.2 (Session 2)
USE ecommerce_db;
-- Task 6.2 (Session 2)
SET SESSION innodb_lock_wait_timeout = 120;
-- Task 6.2 (Session 2)
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- Task 6.2 (Session 2)
START TRANSACTION;
-- Task 6.2 (Session 2)
INSERT INTO Product (product_name, category, price, stock_quantity, status) VALUES ('USB-C Dock','Electronics',8000.00,15,'Active');

-- Task 6.3 (Session 1)
COMMIT;

-- Task 6.4 (Session 2)
COMMIT;

-- Task 7.1
SELECT * FROM Product;
-- Task 7.1
SELECT o.order_id, c.full_name, p.product_name, o.quantity, o.total_amount, o.order_status FROM Orders o JOIN Customer c ON o.customer_id = c.customer_id JOIN Product p ON o.product_id = p.product_id;