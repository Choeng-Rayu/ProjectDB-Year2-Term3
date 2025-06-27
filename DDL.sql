CREATE DATABASE coffee_management_db;
USE coffee_management_db;

-- Customers table with improved data validation
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    loyalty_points INT DEFAULT 0 CHECK (loyalty_points >= 0),
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_customer_email (email)
);

-- Employees table with enhanced constraints
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    position VARCHAR(50) NOT NULL,
    hire_date DATE NOT NULL,
    salary DECIMAL(10, 2) CHECK (salary > 0),
    phone_number VARCHAR(20) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    address VARCHAR(255) NOT NULL,
    INDEX idx_employee_position (position)
);

-- Suppliers table with required fields
CREATE TABLE Suppliers (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_name VARCHAR(100) NOT NULL UNIQUE,
    contact_person VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL
);

-- Products table with inventory constraints
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
    stock_quantity INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    supplier_id INT NOT NULL,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id),
    INDEX idx_product_price (price)
);

-- Categories table for menu organization
CREATE TABLE Categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL UNIQUE
);

-- Menu table with category relationship
CREATE TABLE Menu (
    menu_item_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    category_id INT NOT NULL,
    is_available BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id),
    INDEX idx_menu_availability (is_available)
);

-- Sales table (renamed from Sales_History)
CREATE TABLE Sales (
    sale_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    employee_id INT NOT NULL,
    sale_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL CHECK (total_amount > 0),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
    INDEX idx_sale_date (sale_date)
);

-- Order Items table with proper structure
CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    sale_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) NOT NULL CHECK (unit_price > 0),
    FOREIGN KEY (sale_id) REFERENCES Sales(sale_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Payments table with improved structure
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    sale_id INT NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10, 2) NOT NULL CHECK (amount > 0),
    payment_type VARCHAR(50) NOT NULL,
    transaction_id VARCHAR(100) UNIQUE,
    FOREIGN KEY (sale_id) REFERENCES Sales(sale_id),
    INDEX idx_payment_type (payment_type)
);  

-- Inventory Log with enhanced tracking
CREATE TABLE Inventory_Log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    change_type ENUM('IN', 'OUT', 'ADJUSTMENT') NOT NULL,
    quantity_changed INT NOT NULL CHECK (quantity_changed != 0),
    new_quantity_on_hand INT NOT NULL CHECK (new_quantity_on_hand >= 0),
    log_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    employee_id INT,
    notes TEXT,
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
    INDEX idx_inventory_change (change_type)
);

-- Customer Visits table with optimized structure
CREATE TABLE Customer_Visits (
    visit_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    visit_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    INDEX idx_visit_date (visit_date)
);