CREATE DATABASE IF NOT EXISTS `p_online_food_delivery`;
Use p_online_food_delivery;

-- Schema: Customers Table

CREATE TABLE Customers (
 CustomerID INT PRIMARY KEY,
 CustomerName VARCHAR(50),
 City VARCHAR(30),
 Phone VARCHAR(15),
 JoinDate DATE
);

-- Schema: Restaurants Table

CREATE TABLE Restaurants (
 RestaurantID INT PRIMARY KEY,
 RestaurantName VARCHAR(50),
 City VARCHAR(30),
 Rating DECIMAL(2,1)
);


-- Schema: Orders Table

CREATE TABLE Orders (
 OrderID INT PRIMARY KEY,
 CustomerID INT,
 RestaurantID INT,
 OrderDate DATE,
 Amount DECIMAL(10,2),
 Status VARCHAR(20),
 FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
 FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID)
);


