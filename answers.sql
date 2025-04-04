-- Question 1: Achieving 1NF
-- Assuming you have a table named ProductDetail

-- Create a new table to store the 1NF result
CREATE TABLE OrderProducts1NF (
    OrderID INT,
    CustomerName VARCHAR(255),
    Product VARCHAR(255)
);

-- Insert the transformed data into the new table
INSERT INTO OrderProducts1NF (OrderID, CustomerName, Product)
SELECT OrderID, CustomerName, TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n), ',', 1)) AS Product
FROM ProductDetail
CROSS JOIN (
    SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
) AS numbers
WHERE LENGTH(Products) - LENGTH(REPLACE(Products, ',', '')) >= numbers.n - 1;

-- Explanation:
-- The query uses SUBSTRING_INDEX and a CROSS JOIN to split the comma-separated Products into individual rows.
-- The numbers table is used to generate the necessary number of rows for each comma-separated product.
-- TRIM is used to remove leading/trailing spaces.

-- Question 2: Achieving 2NF
-- Assuming you have a table named OrderDetails

-- Create a table for Orders (OrderID and CustomerName)
CREATE TABLE Orders2NF (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(255)
);

-- Insert unique OrderID and CustomerName combinations
INSERT INTO Orders2NF (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Create a table for OrderItems (OrderID, Product, Quantity)
CREATE TABLE OrderItems2NF (
    OrderID INT,
    Product VARCHAR(255),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders2NF(OrderID)
);

-- Insert OrderID, Product, and Quantity
INSERT INTO OrderItems2NF (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;

-- Explanation:
-- Orders2NF table stores OrderID and CustomerName, eliminating the partial dependency of CustomerName on Product.
-- OrderItems2NF table stores OrderID, Product, and Quantity, ensuring that all non-key attributes depend on the entire primary key (OrderID, Product).
-- Foreign key constraint is added to OrderItems2NF to maintain referential integrity.