CREATE DATABASE online_shopping;
use online_shopping;


CREATE TABLE Customers (
    Customer_ID INT AUTO_INCREMENT,
    Name VARCHAR(50),
    Email VARCHAR(100),
    Phone VARCHAR(20),
    Address VARCHAR(200),
    PRIMARY KEY (Customer_ID)
);

CREATE TABLE Products (
  Product_ID INT AUTO_INCREMENT,
  Name VARCHAR(100),
  Description VARCHAR(500),
  Price DECIMAL(10, 2),
  Stock INT,
  PRIMARY KEY (Product_ID)
);

CREATE TABLE Orders (
  Order_ID INT AUTO_INCREMENT,
  Customer_ID INT,
  Order_Date DATETIME,
  Total DECIMAL(10, 2),
  PRIMARY KEY (Order_ID),
  FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID)
);

CREATE TABLE Order_Items (
  Order_Item_ID INT AUTO_INCREMENT,
  Order_ID INT,
  Product_ID INT,
  Quantity INT,
  PRIMARY KEY (Order_Item_ID),
  FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID),
  FOREIGN KEY (Product_ID) REFERENCES Products(Product_ID)
);

CREATE TABLE Payments (
  Payment_ID INT AUTO_INCREMENT,
  Order_ID INT,
  Payment_Date DATETIME,
  Amount DECIMAL(10, 2),
  PRIMARY KEY (Payment_ID),
  FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID)
);


INSERT INTO Customers (Name, Email, Phone, Address)
VALUES
  ('John Doe', 'john.doe@example.com', '123-456-7890', '123 Main St'),
  ('Jane Smith', 'jane.smith@example.com', '987-654-3210', '456 Elm St'),
  ('Bob Johnson', 'bob.johnson@example.com', '555-123-4567', '789 Oak St');
  
  
  INSERT INTO Products (Name, Description, Price, Stock)
VALUES
  ('Apple iPhone', 'Latest iPhone model', 999.99, 10),
  ('Samsung TV', '4K Ultra HD TV', 1299.99, 5),
  ('Sony Headphones', 'Wireless noise-cancelling headphones', 299.99, 15);
  
  INSERT INTO Orders (Customer_ID, Order_Date, Total)
VALUES
  (1, '2022-01-01 12:00:00', 999.99),
  (2, '2022-01-15 14:00:00', 1299.99),
  (3, '2022-02-01 10:00:00', 299.99);
  
  
  INSERT INTO Order_Items (Order_ID, Product_ID, Quantity)
VALUES
  (1, 1, 1),
  (2, 2, 1),
  (3, 3, 1);
  
  INSERT INTO Payments (Order_ID, Payment_Date, Amount)
VALUES
  (1, '2022-01-01 12:00:00', 999.99),
  (2, '2022-01-15 14:00:00', 1299.99),
  (3, '2022-02-01 10:00:00', 299.99);
  
  SELECT * FROM Customers;
  
  SELECT * FROM Products;
  

/*Query 1: Retrieve all customers with their order totals*/

SELECT C.Name, SUM(O.Total) AS Order_Total
FROM Customers C
JOIN Orders O ON C.Customer_ID = O.Customer_ID
GROUP BY C.Name;

/*Query 2: Retrieve all products with their order quantities*/

SELECT P.Name, SUM(OI.Quantity) AS Order_Quantity
FROM Products P
JOIN Order_Items OI ON P.Product_ID = OI.Product_ID
GROUP BY P.Name;

/*Query 3: Retrieve the top 3 customers by order total*/

SELECT C.Name, SUM(O.Total) AS Order_Total
FROM Customers C
JOIN Orders O ON C.Customer_ID = O.Customer_ID
GROUP BY C.Name
ORDER BY Order_Total DESC
LIMIT 3;


/*Query 1: Calculate the total order value*/


SELECT SUM(Total) AS Total_Order_Value
FROM Orders;

/*Query 2: Calculate the average order value*/


SELECT AVG(Total) AS Average_Order_Value
FROM Orders;


/*Query 3: Find the maximum and minimum order values*/


SELECT MAX(Total) AS Max_Order_Value, MIN(Total) AS Min_Order_Value
FROM Orders;


/*Query 4: Count the number of customers*/


SELECT COUNT(Customer_ID) AS Number_of_Customers
FROM Customers;

/*USING ALTER OPTION*/

ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_Customers
FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID);


/*Query 1: Retrieve customer information with their order totals*/


SELECT C.Name, SUM(O.Total) AS Order_Total
FROM Customers C
INNER JOIN Orders O ON C.Customer_ID = O.Customer_ID
GROUP BY C.Name;


/*Query 2: Retrieve product information with their order quantities*/


SELECT P.Name, SUM(OI.Quantity) AS Order_Quantity
FROM Products P
INNER JOIN Order_Items OI ON P.Product_ID = OI.Product_ID
GROUP BY P.Name;



/*Query 1: Retrieve customer information with their order totals, including customers with no orders*/


SELECT C.Name, SUM(O.Total) AS Order_Total
FROM Customers C
LEFT OUTER JOIN Orders O ON C.Customer_ID = O.Customer_ID
GROUP BY C.Name;



/*Query 1: Retrieve customers who have placed orders with a total value greater than $1000*/


SELECT *
FROM Customers
WHERE Customer_ID IN (
  SELECT Customer_ID
  FROM Orders
  GROUP BY Customer_ID
  HAVING SUM(Total) > 1000
);



/*Query 1: Retrieve the total order value for customers who have placed orders with a total value greater than $1000*/


SELECT SUM(Total) AS Total_Order_Value
FROM Orders
WHERE Customer_ID IN (
  SELECT Customer_ID
  FROM Orders
  GROUP BY Customer_ID
  HAVING SUM(Total) > 1000
);


/*Query 2: Retrieve the average order value for products that have been ordered more than 5 times*/


SELECT AVG(Total) AS Average_Order_Value
FROM Orders
WHERE Order_ID IN (
  SELECT Order_ID
  FROM Order_Items
  GROUP BY Order_ID
  HAVING SUM(Quantity) > 5
);

/*Query 3: Retrieve the maximum order value for customers who have placed orders with a total value greater than $500*/


SELECT MAX(Total) AS Max_Order_Value
FROM Orders
WHERE Customer_ID IN (
  SELECT Customer_ID
  FROM Orders
  GROUP BY Customer_ID
  HAVING SUM(Total) > 500
);


/*Query 1: Retrieve customer information with their order totals, including customers who have placed orders with a total value greater than $1000*/


SELECT C.Name, SUM(O.Total) AS Order_Total
FROM Customers C
JOIN Orders O ON C.Customer_ID = O.Customer_ID
WHERE C.Customer_ID IN (
  SELECT Customer_ID
  FROM Orders
  GROUP BY Customer_ID HAVING SUM(Total) > 1000
)
GROUP BY C.Name;



/*Query 2: Retrieve product information with their order quantities, including products that have been ordered more than 5 times*/


SELECT P.Name, SUM(OI.Quantity) AS Order_Quantity
FROM Products P
JOIN Order_Items OI ON P.Product_ID = OI.Product_ID
WHERE P.Product_ID IN (
  SELECT Product_ID
  FROM Order_Items
  GROUP BY Product_ID
  HAVING SUM(Quantity) > 5
)
GROUP BY P.Name;

/*Query 1: Optimize the query to retrieve customer information with their order totals*/

SELECT C.Name, SUM(O.Total) AS Order_Total
FROM Customers C
JOIN Orders O ON C.Customer_ID = O.Customer_ID
WHERE C.Customer_ID IN (
  SELECT Customer_ID
  FROM Orders
  GROUP BY Customer_ID
  HAVING SUM(Total) > 1000
)
GROUP BY C.Name;






