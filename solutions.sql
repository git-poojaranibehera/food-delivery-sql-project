/********************************************************************
Project : Food Delivery Management System
File    : solutions.sql
Author  : Pooja Rani Behera
Purpose : SQL solutions for project requirements (Q1 - Q20)
********************************************************************/


-- Q1. Create DeliveryPartner table with appropriate constraints.
CREATE TABLE DeliveryPartner (
    PartnerID INT PRIMARY KEY,
    PartnerName VARCHAR(100) NOT NULL,
    Phone VARCHAR(15) UNIQUE NOT NULL,
    VehicleType VARCHAR(50) NOT NULL,
    JoiningDate DATE NOT NULL
);

-- Q2. Add Email column to Customers table with UNIQUE constraint.
ALTER TABLE Customers
ADD Email VARCHAR(100) UNIQUE;


-- Q3. Modify Phone column to increase storage capacity.
ALTER TABLE Customers
MODIFY COLUMN Phone VARCHAR(20);

-- Q4. Add PaymentMethod column to Orders table.
ALTER TABLE Orders
ADD PaymentMethod VARCHAR(30);

-- Q5. Insert 5 new Customers, Restaurants & Orders records.

-- Insert Customers
INSERT INTO Customers 
VALUES
(106, 'Ananya Das', 'Kolkata', '9876543215', '2024-06-01', 'ananya.das@example.com'),
(107, 'Rohit Verma', 'Hyderabad', '9876543216', '2024-06-05', 'rohit.verma@example.com'),
(108, 'Sneha Roy', 'Chennai', '9876543217', '2024-06-10', 'sneha.roy@example.com'),
(109, 'Arjun Nair', 'Kochi', '9876543218', '2024-06-15', 'arjun.nair@example.com'),
(110, 'Meera Kapoor', 'Jaipur', '9876543219', '2024-06-20', 'meera.kapoor@example.com');

-- Insert Restaurants
INSERT INTO Restaurants 
VALUES
(205, 'Urban Bites', 'Kolkata', 4.3),
(206, 'Royal Kitchen', 'Hyderabad', 4.6),
(207, 'Chennai Express', 'Chennai', 4.4),
(208, 'Malabar Spice', 'Kochi', 4.7),
(209, 'Pink City Cafe', 'Jaipur', 4.5);


-- Insert Orders
INSERT INTO Orders 
VALUES
(307, 106, 205, '2025-01-24', 650, 'Delivered', 'UPI'),
(308, 107, 206, '2025-01-25', 480, 'Pending', 'Credit Card'),
(309, 108, 207, '2025-01-26', 720, 'Delivered', 'Cash'),
(310, 109, 208, '2025-01-27', 550, 'Cancelled', 'Debit Card'),
(311, 110, 209, '2025-01-28', 890, 'Delivered', 'Net Banking');

-- Q6. Update all Pending orders to Delivered.
SET SQL_SAFE_UPDATES = 0;
UPDATE Orders SET Status = 'Delivered' WHERE Status = 'Pending';

-- Q7. Increase OrderAmount by 10% where Amount > 500.
UPDATE Orders SET Amount = Amount * 1.10 WHERE Amount > 500;
                            
-- Q8. Delete customers with no orders.
DELETE FROM Customers WHERE CustomerID NOT IN (SELECT CustomerID FROM Orders);
                            
-- Q9. Display customers from a specific city.
SELECT * FROM Customers WHERE City = 'Mumbai';

-- Q10. Find total orders, total revenue & average order amount.
SELECT COUNT(*) AS total_orders, SUM(Amount) AS revenue, AVG(Amount) AS avg_order FROM Orders;

-- Q11. Restaurant-wise total sales & order count.
SELECT RestaurantID, SUM(Amount) AS total_sales, COUNT(OrderID) AS order_count FROM Orders GROUP BY RestaurantID;

-- Q12. Retrieve Customer, Order & Restaurant details using JOINs.
SELECT 
    o.OrderID,
    c.CustomerName,
    c.City,
    r.RestaurantName,
    o.Amount,
    o.OrderDate,
    o.Status
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
INNER JOIN Restaurants r ON o.RestaurantID = r.RestaurantID;

-- Q13. Find customers whose total spending is above average.
SELECT CustomerID, SUM(Amount) AS total_amount 
FROM Orders 
WHERE Status = 'Delivered' 
GROUP BY CustomerID 
HAVING SUM(Amount) > (SELECT AVG(Amount) FROM Orders);

-- To verify average amount, execute below:
SELECT AVG(Amount) FROM Orders;

-- Q14. Display the restaurant with the highest revenue.
SELECT RestaurantID, SUM(Amount) AS HighestRevenue
FROM Orders 
GROUP BY RestaurantID 
ORDER BY HighestRevenue DESC 
LIMIT 1;

-- Without using limit by using CTE
WITH RevenueRank AS (
    SELECT RestaurantID, SUM(Amount) AS Revenue, DENSE_RANK() OVER(ORDER BY SUM(Amount) DESC) AS HighestRevenue 
    FROM Orders 
    GROUP BY RestaurantID
)
SELECT RestaurantID, Revenue FROM RevenueRank WHERE HighestRevenue = 1;

-- Without using limit by using subquery
SELECT RestaurantID, Revenue 
FROM (
    SELECT RestaurantID, SUM(Amount) AS Revenue, DENSE_RANK() OVER(ORDER BY SUM(Amount) DESC) AS HighestRevenue 
    FROM Orders 
    GROUP BY RestaurantID
) t
WHERE HighestRevenue = 1;

-- Q15. Find customers who ordered only from restaurants in their own city.
SELECT * FROM Customers c
WHERE NOT EXISTS (
    SELECT 1 FROM Orders o 
    INNER JOIN Restaurants r ON o.RestaurantID = r.RestaurantID 
    WHERE o.CustomerID = c.CustomerID AND c.City <> r.City
);

-- Q16. Create trigger to store deleted orders in OrderHistory.
CREATE TABLE IF NOT EXISTS OrderHistory LIKE Orders;

-- Trigger
DELIMITER $$

CREATE TRIGGER DeletedOrderHistory
AFTER DELETE ON Orders 
FOR EACH ROW
BEGIN
    INSERT INTO OrderHistory
    VALUES (
        OLD.OrderID,
        OLD.CustomerID,
        OLD.RestaurantID,
        OLD.OrderDate,
        OLD.Amount,
        OLD.Status,
        OLD.PaymentMethod
    );
END $$
DELIMITER ;

-- COMMANDS to verify
DELETE FROM Orders WHERE OrderID = 303;
SELECT * FROM OrderHistory;

-- Q17. Create trigger to prevent orders below ₹100.
DELIMITER $$

CREATE TRIGGER PreventOrders
BEFORE INSERT ON Orders 
FOR EACH ROW
BEGIN
    IF NEW.Amount < 100 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Order amount must be at least ₹100';
    END IF;
END $$
DELIMITER ;

-- Checking Triggers
SHOW TRIGGERS;

-- Testing with lower value than 100 and then increasing it > 100
INSERT INTO Orders VALUES(312, 101, 201, '2025-02-01', 90, 'Pending', 'UPI');
INSERT INTO Orders VALUES(312, 101, 201, '2025-02-01', 190, 'Pending', 'UPI');
SELECT * FROM Orders;

-- Q18. Create stored procedure to display customer orders & total spending.
DELIMITER $$

CREATE PROCEDURE DisplayCustomerOrders()
BEGIN
    SELECT CustomerID, SUM(Amount) AS TotalSpending 
    FROM Orders 
    WHERE Status = 'Delivered' 
    GROUP BY CustomerID; 
END $$
DELIMITER ;

CALL DisplayCustomerOrders();


-- Q19. Rank restaurants by total sales using window functions.
SELECT 
    RestaurantID, 
    SUM(Amount) AS TotalSales, 
    DENSE_RANK() OVER(ORDER BY SUM(Amount) DESC) AS Ranking 
FROM Orders 
WHERE Status = 'Delivered' 
GROUP BY RestaurantID;

-- Q20. Assign row numbers to customer orders and identify the latest order.
SELECT *, ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY OrderDate DESC) AS Ranking 
FROM Orders 
LIMIT 1;