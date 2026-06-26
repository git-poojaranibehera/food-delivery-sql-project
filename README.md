-- Sample Data of Customers

INSERT INTO Customers VALUES
(101, 'Amit Sharma', 'Mumbai', '9876543210', '2024-01-10'),
(102, 'Neha Patil', 'Pune', '9876543211', '2024-02-15'),
(103, 'Rahul Jain', 'Delhi', '9876543212', '2024-03-20'),
(104, 'Priya Singh', 'Bangalore', '9876543213', '2024-04-12'),
(105, 'Karan Mehta', 'Mumbai', '9876543214', '2024-05-05');

-- Sample Data of Restaurants

INSERT INTO Restaurants VALUES
(201, 'Spice Hub', 'Mumbai', 4.5),
(202, 'Food Palace', 'Pune', 4.2),
(203, 'Tasty Treat', 'Delhi', 4.7),
(204, 'Burger Point', 'Bangalore', 4.0);


-- Sample Data of Orders

INSERT INTO Orders VALUES
(301, 101, 201, '2025-01-10', 550, 'Delivered'),
(302, 102, 202, '2025-01-12', 700, 'Delivered'),
(303, 103, 203, '2025-01-15', 450, 'Cancelled'),
(304, 101, 201, '2025-01-18', 800, 'Delivered'),
(305, 104, 204, '2025-01-20', 350, 'Pending'),
(306, 105, 201, '2025-01-22', 900, 'Delivered');
