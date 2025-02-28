-- Create the database --
CREATE DATABASE OnlineShoppingSystem;
GO

-- Use the database --
USE OnlineShoppingSystem;
GO
/*
    ===========================
   | Create the Customers Table|
    ===========================
*/
CREATE TABLE Customers (
   CustomerID INT IDENTITY PRIMARY KEY,   
   Name NVARCHAR(50) NOT NULL,                            
   Email VARCHAR(100) NOT NULL UNIQUE ,
   PhoneNumber NVARCHAR(20) NOT NULL,
   Address NVARCHAR(100) NOT NULL
);
GO

-- Insert 2 Customers 
INSERT INTO Customers (Name, Email, PhoneNumber, Address) VALUES
('Diana White', 'diana@mail.com', '123-456-7890', '123 Main St'),
('Ethan Brown', 'ethan@mail.com', '987-654-3210', '456 Elm St');
GO

/*
    ===========================
   | Create the Orders Table|
    ===========================
*/
CREATE TABLE Orders (
   OrderID INT IDENTITY PRIMARY KEY,      
   OrderDate DATETIME DEFAULT GETUTCDATE() NOT NULL, 
   TotalAmount DECIMAL(10,2) NOT NULL CHECK (TotalAmount > 0), 
   Status VARCHAR(10) NOT NULL CHECK (Status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled'))
   DEFAULT 'Pending', 
   CustomerID INT NOT NULL, --FK
   FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
GO

-- Insert 2 Orders 
INSERT INTO Orders (TotalAmount, Status, CustomerID) VALUES
(900.00, 'Pending', 1),
(149.50, 'Shipped', 2);
GO

/*
    ==============================
   | Create the OrderDetails Table|
    ==============================
*/
CREATE TABLE OrderDetails (
   OrderDetailsID INT IDENTITY PRIMARY KEY,    
   Quantity INT NOT NULL CHECK (Quantity > 0),            
   Price DECIMAL(10,2) NOT NULL CHECK (Price >= 0)
);
GO

-- Insert 2 OrderDetails --
INSERT INTO OrderDetails (Quantity, Price) VALUES
(2, 49.99),
(3, 19.99);
GO


/*
    ==========================
   | Create the Products Table|
    ==========================
*/
CREATE TABLE Products (
   ProductID INT IDENTITY PRIMARY KEY,  
   Category NVARCHAR(50) NOT NULL,
   Name NVARCHAR(50) NOT NULL UNIQUE,
   Description NVARCHAR(100) NULL,
   Price DECIMAL(10,2) NOT NULL CHECK (Price > 0)
);
GO

-- Insert 2 Products --
INSERT INTO Products (Category, Name, Description, Price) VALUES
('Electronics', 'Smartphone', 'Latest model with high-end specs', 10000.00),
('Clothing', 'T-Shirt', 'Comfortable cotton T-shirt', 144.99);
GO

/*
    ===========================
   | Create the Suppliers Table|
    ===========================
*/
CREATE TABLE Suppliers (
   SupplierID INT IDENTITY PRIMARY KEY, 
   Name NVARCHAR(100) NOT NULL,
   ContactInfo NVARCHAR(200) NOT NULL
);
GO

-- Insert 2 Suppliers --
INSERT INTO Suppliers (Name, ContactInfo) VALUES
('Tech Distributors', 'tech@example.com'),
('Book Suppliers', 'books@example.com');
GO

/*
    =======================================================
   | Create the Product_Supplier(Many-To-Many RelationShip)|
    =======================================================
*/
CREATE TABLE Product_Supplier (
   SupplierID INT NOT NULL,   -- FK
   ProductID INT NOT NULL,    -- FK
   PRIMARY KEY (SupplierID, ProductID), --Composite PK
   FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
   FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO

-- Insert 2 ROWS in Product_Supplier --
INSERT INTO Product_Supplier (SupplierID, ProductID) VALUES
(1, 1), 
(2, 2); 

GO

/*
    ===================================================================================
   |  Create the OrderAssociation Table (Linking Orders with Products And OrderDetails)|
    ===================================================================================
*/

CREATE TABLE OrderAssociation (
   OrderID INT NOT NULL,             -- Fk 
   ProductID INT NOT NULL,           -- Fk 
   OrderDetailsID INT NOT NULL,      -- Fk 
   PRIMARY KEY (OrderID, ProductID, OrderDetailsID), -- Composite Primary Key
   FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
   FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
   FOREIGN KEY (OrderDetailsID) REFERENCES OrderDetails(OrderDetailsID)
);
GO

-- Insert 2 Tuples in  OrderAssociation --
INSERT INTO OrderAssociation (OrderID, ProductID, OrderDetailsID) VALUES
(1, 1, 1),
(2, 2, 2);
GO


/*------------------------------------------- DDL Operations ----------------------------------------------*/
-- 1) Add a new column 'rating' to Products table with a default value
ALTER TABLE Products
ADD rating DECIMAL(2, 1) DEFAULT 0.0;

-- 2) Alter the Category column to have a default value of 'new'
ALTER TABLE Products
ADD CONSTRAINT DF_Category DEFAULT 'new' FOR Category;


-- 3) Drop the 'rating' column from the Products table
ALTER TABLE Products
DROP COLUMN rating;

/*------------------------------------------- DML Operations ----------------------------------------------*/
-- 1) Update the OrderDate for all orders where OrderID > 0
UPDATE Orders
SET OrderDate = GETUTCDATE()
WHERE OrderID > 0;

-- 2) Delete all rows from the Products table where the Product Name is not NULL and not equal to 'NULL'
DELETE FROM Products
WHERE Name IS NOT NULL
AND Name!='NULL';



