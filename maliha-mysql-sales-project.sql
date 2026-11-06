CREATE DATABASE maliha_mm;
USE maliha_mm;

CREATE TABLE Employees 
(
employee_id	INT PRIMARY KEY AUTO_INCREMENT,
employee_name	VARCHAR(100),
department	VARCHAR(50),
salary	DECIMAL(10,2)
);

CREATE TABLE  Customers
(
customer_id	INT PRIMARY KEY AUTO_INCREMENT,
customer_name	VARCHAR(100),
city	VARCHAR(50)
);

CREATE TABLE Products
(
product_id	INT PRIMARY KEY AUTO_INCREMENT,
product_name	VARCHAR(100),
price	DECIMAL(10,2)
);

CREATE TABLE Orders 
(
  order_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT,
  employee_id INT,
  product_id INT,
  quantity INT,
  order_date DATE,

FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Employees

VALUES
(1,'Ali','IT',10000),
(2,'Talha','CS',20000),
(3,'Sara','Fintech',30000),
(4,'Maham','CS',40000),
(5,'Hina','IT',50000);

INSERT INTO Customers
VALUES

(001,'Ali','Lahore'),
(002,'Sara','Karachi'),
(003,'Maham','Lahore'),
(004,'Hina','Islamabad'),
(005,'Talha','Riyadh'
);

INSERT INTO Products
VALUES
(100,'laptop', 3500),
(200,'mouse', 4000),
(300,'pen',5000),
(400,'keyboard',11000),
(500,'mic',400
);

INSERT INTO Orders
(order_id, customer_id, employee_id, product_id, quantity, order_date)
VALUES
(1, 1, 1, 100, 2, '2026-01-10'),
(2, 2, 2, 200, 1, '2026-01-11'),
(3, 3, 3, 300, 5, '2026-01-12'),
(4, 4, 4, 400, 2, '2026-01-13'),
(5, 5, 5, 500, 3, '2026-01-14'),
(6, 2, 1, 200, 4, '2026-01-15'),
(7, 3, 2, 100, 1, '2026-01-16'),
(8, 4, 3, 500, 6, '2026-01-17'),
(9, 5, 4, 300, 2, '2026-01-18'),
(10, 1, 5, 400, 3, '2026-01-19');


SELECT * FROM Employees ;
SELECT * FROM Customers;
SELECT * FROM Products;
SELECT * FROM Orders;


SELECT
    Orders.order_id,
    Products.product_name,
    Products.price,
    Orders.quantity,
    (Products.price * Orders.quantity) AS total_amount
FROM Orders
INNER JOIN Products
ON Orders.product_id = Products.product_id;


SELECT
    Customers.customer_id,
    Customers.customer_name,
    Customers.city
FROM Customers
LEFT JOIN Orders
ON Customers.customer_id = Orders.customer_id
WHERE Orders.order_id IS NULL;

SELECT
    Employees.employee_id,
    Employees.employee_name,
    SUM(Products.price * Orders.quantity) AS total_sales
FROM Employees
INNER JOIN Orders
ON Employees.employee_id = Orders.employee_id
INNER JOIN Products
ON Orders.product_id = Products.product_id
GROUP BY Employees.employee_id, Employees.employee_name;

SELECT
    Employees.employee_name,
    SUM(Products.price * Orders.quantity) AS total_sales
FROM Employees
INNER JOIN Orders
ON Employees.employee_id = Orders.employee_id
INNER JOIN Products
ON Orders.product_id = Products.product_id
GROUP BY Employees.employee_id, Employees.employee_name
ORDER BY total_sales DESC
LIMIT 1;

SELECT
    Products.product_id,
    Products.product_name,
    SUM(Orders.quantity) AS total_quantity_sold
FROM Products
INNER JOIN Orders
ON Products.product_id = Orders.product_id
GROUP BY Products.product_id, Products.product_name
ORDER BY total_quantity_sold DESC
LIMIT 3;

SELECT
    Customers.city,
    SUM(Products.price * Orders.quantity) AS total_revenue
FROM Customers
INNER JOIN Orders
ON Customers.customer_id = Orders.customer_id
INNER JOIN Products
ON Orders.product_id = Products.product_id
GROUP BY Customers.city;

SELECT
    Customers.customer_id,
    Customers.customer_name,
    SUM(Products.price * Orders.quantity) AS total_purchases
FROM Customers
INNER JOIN Orders
ON Customers.customer_id = Orders.customer_id
INNER JOIN Products
ON Orders.product_id = Products.product_id
GROUP BY Customers.customer_id, Customers.customer_name
HAVING total_purchases > 10000;

SELECT
    Employees.employee_id,
    Employees.employee_name,
    SUM(Products.price * Orders.quantity) AS total_sales
FROM Employees
INNER JOIN Orders
ON Employees.employee_id = Orders.employee_id
INNER JOIN Products
ON Orders.product_id = Products.product_id
GROUP BY Employees.employee_id, Employees.employee_name
HAVING total_sales > (
    SELECT AVG(employee_sales)
    FROM (
        SELECT SUM(P.price * O.quantity) AS employee_sales
        FROM Orders O
        INNER JOIN Products P
        ON O.product_id = P.product_id
        GROUP BY O.employee_id
    ) AS sales_table
);

SELECT
    Employees.employee_name,
    SUM(Products.price * Orders.quantity) AS total_sales,
    CASE
        WHEN SUM(Products.price * Orders.quantity) > 50000
            THEN 'Excellent'
        WHEN SUM(Products.price * Orders.quantity) >= 20000
            THEN 'Good'
        ELSE 'Needs Improvement'
    END AS performance
FROM Employees
INNER JOIN Orders
ON Employees.employee_id = Orders.employee_id
INNER JOIN Products
ON Orders.product_id = Products.product_id
GROUP BY Employees.employee_id, Employees.employee_name;

SELECT
    Employees.employee_name,
    SUM(Products.price * Orders.quantity) AS total_revenue
FROM Employees
INNER JOIN Orders
ON Employees.employee_id = Orders.employee_id
INNER JOIN Products
ON Orders.product_id = Products.product_id
GROUP BY Employees.employee_id, Employees.employee_name
ORDER BY total_revenue DESC
LIMIT 1 OFFSET 1;

SELECT
    YEAR(Orders.order_date) AS sales_year,
    MONTH(Orders.order_date) AS sales_month,
    SUM(Products.price * Orders.quantity) AS monthly_revenue
FROM Orders
INNER JOIN Products
ON Orders.product_id = Products.product_id
GROUP BY YEAR(Orders.order_date), MONTH(Orders.order_date)
ORDER BY sales_year, sales_month;

SELECT
    Employees.employee_name,
    Employees.department,

    COUNT(DISTINCT Orders.order_id) AS total_orders,

    SUM(Orders.quantity) AS total_quantity,

    SUM(Products.price * Orders.quantity) AS total_revenue,

    CASE
        WHEN SUM(Products.price * Orders.quantity) > 50000
            THEN 'Excellent'

        WHEN SUM(Products.price * Orders.quantity) >= 20000
            THEN 'Good'

        ELSE 'Needs Improvement'
    END AS performance

FROM Employees

INNER JOIN Orders
ON Employees.employee_id = Orders.employee_id

INNER JOIN Products
ON Orders.product_id = Products.product_id

GROUP BY
    Employees.employee_id,
    Employees.employee_name,
    Employees.department

ORDER BY total_revenue DESC;