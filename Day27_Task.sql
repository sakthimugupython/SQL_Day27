CREATE DATABASE OLTP;
USE OLTP;
-- Task 3: Create OLTP order management table
CREATE TABLE orders_oltp (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT,
    order_date DATETIME,
    unit_price DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    status VARCHAR(20),
    payment_method VARCHAR(20)
);

-- Task 4: Create OLAP monthly sales summary table
CREATE TABLE monthly_sales_olap (
    year INT,
    month INT,
    total_orders INT,
    total_revenue DECIMAL(12,2),
    avg_order_value DECIMAL(10,2),
    max_order_value DECIMAL(10,2)
);

-- Task 5: Simulate OLTP insert
INSERT INTO orders_oltp VALUES
(1, 101, 201, 2, '2023-01-15 10:30:00', 500.00, 1000.00, 'Completed', 'Credit Card'),
(2, 102, 202, 1, '2023-01-16 14:45:00', 1200.00, 1200.00, 'Completed', 'PayPal');

-- Task 6: Star Schema Design
CREATE TABLE Dim_Product (
    product_key INT PRIMARY KEY,
    product_id INT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    brand VARCHAR(50)
);

CREATE TABLE Dim_Customer (
    customer_key INT PRIMARY KEY,
    customer_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50),
    status VARCHAR(20) DEFAULT 'Active'
);

CREATE TABLE Dim_Time (
    time_key INT PRIMARY KEY,
    date DATE,
    day INT,
    month INT,
    quarter INT,
    year INT,
    day_of_week VARCHAR(10),
    is_weekend BOOLEAN
);

CREATE TABLE Dim_Location (
    location_key INT PRIMARY KEY,
    store_id INT,
    store_name VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50),
    region VARCHAR(50)
);

CREATE TABLE Fact_Sales (
    sales_key INT PRIMARY KEY,
    time_key INT,
    product_key INT,
    customer_key INT,
    location_key INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    FOREIGN KEY (time_key) REFERENCES Dim_Time(time_key),
    FOREIGN KEY (product_key) REFERENCES Dim_Product(product_key),
    FOREIGN KEY (customer_key) REFERENCES Dim_Customer(customer_key),
    FOREIGN KEY (location_key) REFERENCES Dim_Location(location_key)
);

-- Task 7: Insert sample data
INSERT INTO Dim_Product VALUES
(1, 201, 'Wireless Headphones', 'Electronics', 500.00, 'Sony'),
(2, 202, 'Smart Watch', 'Electronics', 1200.00, 'Samsung'),
(3, 203, 'Running Shoes', 'Sports', 300.00, 'Nike'),
(4, 204, 'Coffee Maker', 'Home Appliances', 750.00, 'Philips'),
(5, 205, 'Backpack', 'Accessories', 450.00, 'American Tourister');

INSERT INTO Dim_Customer VALUES
(1, 101, 'John', 'Smith', 'john.smith@email.com', 'New York', 'NY', 'USA', 'Active'),
(2, 102, 'Sarah', 'Johnson', 'sarah.j@email.com', 'Los Angeles', 'CA', 'USA', 'Active'),
(3, 103, 'Michael', 'Brown', NULL, 'Chicago', 'IL', 'USA', 'Inactive'),
(4, 104, 'Emily', 'Davis', 'emily.d@email.com', 'Houston', 'TX', 'USA', 'Active'),
(5, 105, 'David', 'Wilson', 'david.w@email.com', 'Phoenix', 'AZ', 'USA', 'Active');

INSERT INTO Dim_Time VALUES
(1, '2023-01-15', 15, 1, 1, 2023, 'Sunday', TRUE),
(2, '2023-01-16', 16, 1, 1, 2023, 'Monday', FALSE),
(3, '2023-01-17', 17, 1, 1, 2023, 'Tuesday', FALSE),
(4, '2023-02-18', 18, 2, 1, 2023, 'Saturday', TRUE),
(5, '2023-02-19', 19, 2, 1, 2023, 'Sunday', TRUE),
(6, '2023-03-20', 20, 3, 1, 2023, 'Monday', FALSE);

INSERT INTO Dim_Location VALUES
(1, 1, 'Main Store', 'New York', 'NY', 'USA', 'Northeast'),
(2, 2, 'Downtown Store', 'Los Angeles', 'CA', 'USA', 'West'),
(3, 3, 'Central Store', 'Chicago', 'IL', 'USA', 'Midwest'),
(4, 4, 'South Store', 'Houston', 'TX', 'USA', 'South'),
(5, 5, 'Desert Store', 'Phoenix', 'AZ', 'USA', 'West');

INSERT INTO Fact_Sales VALUES
(1, 1, 1, 1, 1, 2, 500.00, 1000.00),
(2, 2, 2, 2, 2, 1, 1200.00, 1200.00),
(3, 3, 3, 3, 3, 3, 300.00, 900.00),
(4, 4, 4, 1, 1, 1, 750.00, 750.00),
(5, 5, 1, 4, 4, 2, 500.00, 1000.00),
(6, 6, 5, 5, 5, 2, 450.00, 900.00),
(7, 3, 2, 2, 2, 1, 1200.00, 1200.00),
(8, 4, 3, 1, 1, 2, 300.00, 600.00),
(9, 5, 1, 4, 4, 3, 500.00, 1500.00),
(10, 6, 4, 5, 5, 1, 750.00, 750.00);

-- Task 8: Total revenue by product category
SELECT 
    p.category,
    SUM(f.total_amount) AS total_revenue
FROM 
    Fact_Sales f
JOIN 
    Dim_Product p ON f.product_key = p.product_key
GROUP BY 
    p.category
ORDER BY 
    total_revenue DESC;

-- Task 9: Sales by region
SELECT 
    l.region,
    SUM(f.total_amount) AS total_sales,
    COUNT(*) AS number_of_orders
FROM 
    Fact_Sales f
JOIN 
    Dim_Location l ON f.location_key = l.location_key
GROUP BY 
    l.region
ORDER BY 
    total_sales DESC;

-- Task 10: Join all dimensions with fact table
SELECT 
    f.sales_key,
    t.date,
    p.product_name,
    p.category,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    l.store_name,
    l.region,
    f.quantity,
    f.unit_price,
    f.total_amount
FROM 
    Fact_Sales f
JOIN 
    Dim_Time t ON f.time_key = t.time_key
JOIN 
    Dim_Product p ON f.product_key = p.product_key
JOIN 
    Dim_Customer c ON f.customer_key = c.customer_key
JOIN 
    Dim_Location l ON f.location_key = l.location_key;

-- Task 11: Snowflake schema - Category_Details
CREATE TABLE Category_Details (
    category_key INT PRIMARY KEY,
    category_name VARCHAR(50),
    department VARCHAR(50),
    profit_margin DECIMAL(5,2)
);

-- Task 12: Insert snowflake data
INSERT INTO Category_Details VALUES
(1, 'Electronics', 'Technology', 25.00),
(2, 'Sports', 'Outdoor', 30.00),
(3, 'Home Appliances', 'Home', 20.00),
(4, 'Accessories', 'Fashion', 35.00);

ALTER TABLE Dim_Product
ADD COLUMN category_key INT,
ADD FOREIGN KEY (category_key) REFERENCES Category_Details(category_key);

UPDATE Dim_Product SET category_key = 1 WHERE category = 'Electronics';
UPDATE Dim_Product SET category_key = 2 WHERE category = 'Sports';
UPDATE Dim_Product SET category_key = 3 WHERE category = 'Home Appliances';
UPDATE Dim_Product SET category_key = 4 WHERE category = 'Accessories';

-- Task 13: Revenue by category (snowflake)
SELECT 
    cd.category_name,
    SUM(f.total_amount) AS total_revenue
FROM 
    Fact_Sales f
JOIN 
    Dim_Product p ON f.product_key = p.product_key
JOIN 
    Category_Details cd ON p.category_key = cd.category_key
GROUP BY 
    cd.category_name
ORDER BY 
    total_revenue DESC;

-- Task 14: Performance comparison
EXPLAIN ANALYZE SELECT p.category, SUM(f.total_amount) FROM Fact_Sales f JOIN Dim_Product p ON f.product_key = p.product_key GROUP BY p.category;
EXPLAIN ANALYZE SELECT cd.category_name, SUM(f.total_amount) FROM Fact_Sales f JOIN Dim_Product p ON f.product_key = p.product_key JOIN Category_Details cd ON p.category_key = cd.category_key GROUP BY cd.category_name;

-- Task 15: Sales per customer location
SELECT 
    c.city,
    c.state,
    COUNT(*) AS number_of_sales
FROM 
    Fact_Sales f
JOIN 
    Dim_Customer c ON f.customer_key = c.customer_key
GROUP BY 
    c.city, c.state
ORDER BY 
    number_of_sales DESC;

-- Task 16: Group sales by month and year
SELECT 
    t.year,
    t.month,
    SUM(f.total_amount) AS total_sales,
    COUNT(*) AS number_of_orders
FROM 
    Fact_Sales f
JOIN 
    Dim_Time t ON f.time_key = t.time_key
GROUP BY 
    t.year, t.month
ORDER BY 
    t.year, t.month;

-- Task 17: Filter monthly sales > 10000
SELECT 
    t.year,
    t.month,
    SUM(f.total_amount) AS total_sales
FROM 
    Fact_Sales f
JOIN 
    Dim_Time t ON f.time_key = t.time_key
GROUP BY 
    t.year, t.month
HAVING 
    SUM(f.total_amount) > 1000.00
ORDER BY 
    t.year, t.month;

-- Task 18: Orders per product
SELECT 
    p.product_name,
    COUNT(*) AS number_of_orders,
    SUM(f.quantity) AS total_quantity_sold
FROM 
    Fact_Sales f
JOIN 
    Dim_Product p ON f.product_key = p.product_key
GROUP BY 
    p.product_name
ORDER BY 
    number_of_orders DESC;

-- Task 19: Average sale per customer
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    AVG(f.total_amount) AS avg_order_value,
    COUNT(*) AS number_of_orders
FROM 
    Fact_Sales f
JOIN 
    Dim_Customer c ON f.customer_key = c.customer_key
GROUP BY 
    customer_name
ORDER BY 
    avg_order_value DESC;

-- Task 20: Stats by product category
SELECT 
    p.category,
    MAX(f.total_amount) AS max_order,
    MIN(f.total_amount) AS min_order,
    AVG(f.total_amount) AS avg_order,
    COUNT(*) AS number_of_orders
FROM 
    Fact_Sales f
JOIN 
    Dim_Product p ON f.product_key = p.product_key
GROUP BY 
    p.category
ORDER BY 
    number_of_orders DESC;

-- Task 21: Monthly performance report
SELECT 
    t.year,
    t.month,
    COUNT(*) AS total_orders,
    SUM(f.total_amount) AS total_revenue,
    SUM(f.quantity) AS total_items_sold,
    AVG(f.total_amount) AS avg_order_value
FROM 
    Fact_Sales f
JOIN 
    Dim_Time t ON f.time_key = t.time_key
GROUP BY 
    t.year, t.month
ORDER BY 
    t.year, t.month;

-- Task 22: Top 5 customers by spend
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    SUM(f.total_amount) AS total_spend,
    COUNT(*) AS number_of_orders
FROM 
    Fact_Sales f
JOIN 
    Dim_Customer c ON f.customer_key = c.customer_key
GROUP BY 
    customer_name
ORDER BY 
    total_spend DESC
LIMIT 5;

-- Task 23: Identify revenue declines
WITH monthly_revenue AS (
    SELECT 
        t.year,
        t.month,
        SUM(f.total_amount) AS revenue
    FROM 
        Fact_Sales f
    JOIN 
        Dim_Time t ON f.time_key = t.time_key
    GROUP BY 
        t.year, t.month
)
SELECT 
    year,
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY year, month) AS previous_month_revenue,
    revenue - LAG(revenue) OVER (ORDER BY year, month) AS revenue_change,
    CASE 
        WHEN revenue < LAG(revenue) OVER (ORDER BY year, month) THEN 'Decline'
        WHEN revenue > LAG(revenue) OVER (ORDER BY year, month) THEN 'Growth'
        ELSE 'No Change'
    END AS trend
FROM 
    monthly_revenue
ORDER BY 
    year, month;

-- Task 24: Customer retention trend
SELECT 
    t.year,
    t.month,
    COUNT(DISTINCT f.customer_key) AS unique_customers
FROM 
    Fact_Sales f
JOIN 
    Dim_Time t ON f.time_key = t.time_key
GROUP BY 
    t.year, t.month
ORDER BY 
    t.year, t.month;

-- Task 25: Seasonal trends by category
SELECT 
    t.month,
    p.category,
    SUM(f.total_amount) AS total_sales,
    COUNT(*) AS number_of_orders
FROM 
    Fact_Sales f
JOIN 
    Dim_Time t ON f.time_key = t.time_key
JOIN 
    Dim_Product p ON f.product_key = p.product_key
GROUP BY 
    t.month, p.category
ORDER BY 
    t.month, total_sales DESC;

-- Task 26: Extract active customers
CREATE TABLE extracted_active_customers AS
SELECT * FROM Dim_Customer WHERE status = 'Active';

-- Task 27: Extract last 6 months orders
CREATE TABLE recent_orders AS
SELECT f.*, t.date
FROM Fact_Sales f
JOIN Dim_Time t ON f.time_key = t.time_key
WHERE t.date >= DATE_SUB(CURRENT_DATE(), INTERVAL 6 MONTH);

-- Task 29: Extract high-value customers
CREATE TABLE high_value_customers AS
SELECT 
    c.customer_key,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    SUM(f.total_amount) AS total_spend
FROM 
    Fact_Sales f
JOIN 
    Dim_Customer c ON f.customer_key = c.customer_key
GROUP BY 
    c.customer_key, customer_name
HAVING 
    SUM(f.total_amount) > 2000.00
ORDER BY 
    total_spend DESC;

-- Task 30: Transform names to uppercase
UPDATE Dim_Customer
SET first_name = UPPER(first_name),
    last_name = UPPER(last_name);

-- Task 31: Replace null emails
UPDATE Dim_Customer
SET email = 'no-email@retail.com'
WHERE email IS NULL;

-- Task 32: Add derived full_name column
ALTER TABLE Dim_Customer
ADD COLUMN full_name VARCHAR(101);

UPDATE Dim_Customer
SET full_name = CONCAT(first_name, ' ', last_name);

-- Task 33: Standardize category names
UPDATE Dim_Product
SET category = LOWER(category);

-- Task 34: Calculate tax column
ALTER TABLE Fact_Sales
ADD COLUMN tax_amount DECIMAL(10,2);

UPDATE Fact_Sales
SET tax_amount = total_amount * 0.18;

-- Task 35: Create DW summary table
CREATE TABLE dw_sales_summary (
    summary_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(101),
    total_purchases DECIMAL(12,2),
    avg_order_value DECIMAL(10,2),
    number_of_orders INT,
    last_order_date DATE,
    etl_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Task 36: Load purchases per customer
INSERT INTO dw_sales_summary (customer_id, customer_name, total_purchases, avg_order_value, number_of_orders, last_order_date)
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    SUM(f.total_amount) AS total_purchases,
    AVG(f.total_amount) AS avg_order_value,
    COUNT(*) AS number_of_orders,
    MAX(t.date) AS last_order_date
FROM 
    Fact_Sales f
JOIN 
    Dim_Customer c ON f.customer_key = c.customer_key
JOIN 
    Dim_Time t ON f.time_key = t.time_key
GROUP BY 
    c.customer_id, customer_name;

-- Task 37: Load monthly product summary
CREATE TABLE dw_monthly_product_sales (
    year INT,
    month INT,
    product_id INT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    total_sales DECIMAL(12,2),
    total_quantity INT,
    etl_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (year, month, product_id)
);

INSERT INTO dw_monthly_product_sales (year, month, product_id, product_name, category, total_sales, total_quantity)
SELECT 
    t.year,
    t.month,
    p.product_id,
    p.product_name,
    p.category,
    SUM(f.total_amount) AS total_sales,
    SUM(f.quantity) AS total_quantity
FROM 
    Fact_Sales f
JOIN 
    Dim_Product p ON f.product_key = p.product_key
JOIN 
    Dim_Time t ON f.time_key = t.time_key
GROUP BY 
    t.year, t.month, p.product_id, p.product_name, p.category;

-- Task 39: ETL log table
CREATE TABLE etl_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    process_name VARCHAR(100),
    status VARCHAR(20),
    records_processed INT,
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    error_message TEXT
);

INSERT INTO etl_log (process_name, status, records_processed, start_time, end_time)
VALUES 
('Customer Extraction', 'Success', (SELECT COUNT(*) FROM extracted_active_customers), NOW(), NOW()),
('Recent Orders Extraction', 'Success', (SELECT COUNT(*) FROM recent_orders), NOW(), NOW()),
('Customer Transformation', 'Success', (SELECT COUNT(*) FROM Dim_Customer), NOW(), NOW()),
('Sales Summary Load', 'Success', (SELECT COUNT(*) FROM dw_sales_summary), NOW(), NOW()),
('Monthly Product Sales Load', 'Success', (SELECT COUNT(*) FROM dw_monthly_product_sales), NOW(), NOW());

-- Task 40: Group by month using EXTRACT
SELECT 
    EXTRACT(YEAR FROM t.date) AS year,
    EXTRACT(MONTH FROM t.date) AS month,
    SUM(f.total_amount) AS total_revenue
FROM 
    Fact_Sales f
JOIN 
    Dim_Time t ON f.time_key = t.time_key
GROUP BY 
    EXTRACT(YEAR FROM t.date), EXTRACT(MONTH FROM t.date)
ORDER BY 
    year, month;

-- Task 41: Quarterly revenue
SELECT 
    t.year,
    t.quarter,
    SUM(f.total_amount) AS quarterly_revenue,
    COUNT(*) AS number_of_orders
FROM 
    Fact_Sales f
JOIN 
    Dim_Time t ON f.time_key = t.time_key
GROUP BY 
    t.year, t.quarter
ORDER BY 
    t.year, t.quarter;

-- Task 42: Average order size by product
SELECT 
    p.product_name,
    AVG(f.quantity) AS avg_order_quantity,
    AVG(f.total_amount) AS avg_order_value
FROM 
    Fact_Sales f
JOIN 
    Dim_Product p ON f.product_key = p.product_key
GROUP BY 
    p.product_name
ORDER BY 
    avg_order_value DESC;

-- Task 43: Time series report
SELECT 
    EXTRACT(YEAR FROM t.date) AS year,
    EXTRACT(MONTH FROM t.date) AS month,
    SUM(f.total_amount) AS total_revenue,
    SUM(SUM(f.total_amount)) OVER (PARTITION BY EXTRACT(YEAR FROM t.date) ORDER BY EXTRACT(MONTH FROM t.date)) AS running_yearly_total
FROM 
    Fact_Sales f
JOIN 
    Dim_Time t ON f.time_key = t.time_key
GROUP BY 
    EXTRACT(YEAR FROM t.date), EXTRACT(MONTH FROM t.date)
ORDER BY 
    year, month;

-- Task 44: Month-over-month comparison
WITH monthly_revenue AS (
    SELECT 
        EXTRACT(YEAR FROM t.date) AS year,
        EXTRACT(MONTH FROM t.date) AS month,
        SUM(f.total_amount) AS revenue
    FROM 
        Fact_Sales f
    JOIN 
        Dim_Time t ON f.time_key = t.time_key
    GROUP BY 
        EXTRACT(YEAR FROM t.date), EXTRACT(MONTH FROM t.date)
)
SELECT 
    year,
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY year, month) AS previous_month_revenue,
    revenue - LAG(revenue) OVER (ORDER BY year, month) AS month_over_month_change,
    (revenue - LAG(revenue) OVER (ORDER BY year, month)) / LAG(revenue) OVER (ORDER BY year, month) * 100 AS percentage_change
FROM 
    monthly_revenue
ORDER BY 
    year, month;

-- Task 45: Dashboard view
CREATE VIEW sales_dashboard AS
WITH monthly_sales AS (
    SELECT 
        EXTRACT(YEAR FROM t.date) AS year,
        EXTRACT(MONTH FROM t.date) AS month,
        SUM(f.total_amount) AS total_revenue
    FROM 
        Fact_Sales f
    JOIN 
        Dim_Time t ON f.time_key = t.time_key
    GROUP BY 
        EXTRACT(YEAR FROM t.date), EXTRACT(MONTH FROM t.date)
),
top_products AS (
    SELECT 
        p.product_name,
        SUM(f.total_amount) AS product_revenue
    FROM 
        Fact_Sales f
    JOIN 
        Dim_Product p ON f.product_key = p.product_key
    GROUP BY 
        p.product_name
    ORDER BY 
        product_revenue DESC
    LIMIT 3
),
top_regions AS (
    SELECT 
        l.region,
        SUM(f.total_amount) AS region_revenue
    FROM 
        Fact_Sales f
    JOIN 
        Dim_Location l ON f.location_key = l.location_key
    GROUP BY 
        l.region
    ORDER BY 
        region_revenue DESC
    LIMIT 1
)
SELECT 
    (SELECT MAX(total_revenue) FROM monthly_sales) AS current_month_revenue,
    (SELECT product_name FROM top_products LIMIT 1) AS top_product,
    (SELECT region FROM top_regions) AS top_region,
    (SELECT COUNT(DISTINCT customer_key) FROM Fact_Sales) AS total_customers,
    (SELECT SUM(total_amount) FROM Fact_Sales) AS total_revenue;

-- Task 46: Materialized view
CREATE TABLE mv_high_cost_aggregation AS
SELECT 
    p.category,
    t.quarter,
    t.year,
    SUM(f.total_amount) AS total_revenue,
    SUM(f.quantity) AS total_quantity,
    COUNT(*) AS number_of_orders
FROM 
    Fact_Sales f
JOIN 
    Dim_Product p ON f.product_key = p.product_key
JOIN 
    Dim_Time t ON f.time_key = t.time_key
GROUP BY 
    p.category, t.quarter, t.year;

-- Task 47: Rolling 3-month average
SELECT 
    t.year,
    t.month,
    SUM(f.total_amount) AS monthly_revenue,
    AVG(SUM(f.total_amount)) OVER (ORDER BY t.year, t.month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS rolling_3month_avg
FROM 
    Fact_Sales f
JOIN 
    Dim_Time t ON f.time_key = t.time_key
GROUP BY 
    t.year, t.month
ORDER BY 
    t.year, t.month;

-- Task 48: Customer churn analysis
SELECT 
    c.customer_key,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    MAX(t.date) AS last_purchase_date,
    DATEDIFF(CURRENT_DATE(), MAX(t.date)) AS days_since_last_purchase,
    CASE 
        WHEN DATEDIFF(CURRENT_DATE(), MAX(t.date)) > 90 THEN 'Churned'
        ELSE 'Active'
    END AS customer_status
FROM 
    Fact_Sales f
JOIN 
    Dim_Customer c ON f.customer_key = c.customer_key
JOIN 
    Dim_Time t ON f.time_key = t.time_key
GROUP BY 
    c.customer_key, customer_name
ORDER BY 
    days_since_last_purchase DESC;

-- Task 49: Top 5 consistent categories
WITH monthly_category_rank AS (
    SELECT 
        t.year,
        t.month,
        p.category,
        SUM(f.total_amount) AS category_revenue,
        RANK() OVER (PARTITION BY t.year, t.month ORDER BY SUM(f.total_amount) DESC) AS revenue_rank
    FROM 
        Fact_Sales f
    JOIN 
        Dim_Product p ON f.product_key = p.product_key
    JOIN 
        Dim_Time t ON f.time_key = t.time_key
    GROUP BY 
        t.year, t.month, p.category
)
SELECT 
    category,
    COUNT(*) AS months_in_top_5,
    SUM(CASE WHEN revenue_rank <= 5 THEN 1 ELSE 0 END) AS months_in_top_5
FROM 
    monthly_category_rank
GROUP BY 
    category
ORDER BY 
    months_in_top_5 DESC
LIMIT 5;

-- Task 50: Optimize with indexing
CREATE INDEX idx_fact_sales_product ON Fact_Sales(product_key);
CREATE INDEX idx_fact_sales_time ON Fact_Sales(time_key);
CREATE INDEX idx_dim_product_category ON Dim_Product(category);

EXPLAIN 
SELECT 
    p.category,
    t.quarter,
    SUM(f.total_amount) AS total_revenue
FROM 
    Fact_Sales f
JOIN 
    Dim_Product p ON f.product_key = p.product_key
JOIN 
    Dim_Time t ON f.time_key = t.time_key
WHERE 
    p.category = 'Electronics'
GROUP BY 
    p.category, t.quarter
ORDER BY 
    t.quarter;