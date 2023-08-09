DROP DATABASE IF EXISTS northwind;
CREATE DATABASE northwind;

\c northwind

DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS suppliers CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS regions CASCADE;
DROP TABLE IF EXISTS territories CASCADE;
DROP TABLE IF EXISTS employee_territories CASCADE;
DROP TABLE IF EXISTS orders CASCADE;



--ALTER TABLE products DROP CONSTRAINT IF EXISTS products_categories_fkey; -- pr_cat verweist auf cat alternativ dropping
DROP TABLE IF EXISTS categories;
CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR (50),
    description VARCHAR (100),
    picture BYTEA);

\copy categories FROM './northwind_data_clean/data/categories.csv' DELIMITER ',' NULL AS 'NULL' CSV HEADER


DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
    customer_id TEXT PRIMARY KEY,
    company_name VARCHAR (50),
    contact_name TEXT,
    contact_title TEXT,
    address VARCHAR (50),
    city VARCHAR (20),
    region VARCHAR (30),
    postalcode VARCHAR (50),
    country TEXT,
    phone VARCHAR (35),
    fax VARCHAR (35));

\copy customers FROM './northwind_data_clean/data/customers.csv' DELIMITER ',' NULL AS 'NULL' CSV HEADER

DROP TABLE IF EXISTS employee_territories;
CREATE TABLE employee_territories (
    employee_id INT,
    territory_id VARCHAR (20));

\copy employee_territories FROM './northwind_data_clean/data/employee_territories.csv' DELIMITER ',' NULL AS 'NULL' CSV HEADER

DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    last_name TEXT,
    first_name TEXT,
    title VARCHAR (50),
    title_of_courtesy VARCHAR (5),
    birthdate TIMESTAMP,
    hiredate TIMESTAMP,
    address VARCHAR (50),
    city TEXT,
    region VARCHAR (20),
    postalcode VARCHAR (10),
    country TEXT,
    homephone VARCHAR (15),
    extension INT,
    photo BYTEA,
    notes VARCHAR (500),
    reports_to INT,
    photopath VARCHAR (100));

\copy employees FROM './northwind_data_clean/data/employees.csv' DELIMITER ',' NULL AS 'NULL' csv HEADER

DROP TABLE IF EXISTS order_details;
CREATE TABLE order_details (
    order_id INT,
    product_id SMALLINT,
    unit_price VARCHAR (8),
    quantity INT,
    discount VARCHAR (8));

\copy order_details FROM '.\\northwind_data_clean\\data\\order_details.csv' DELIMITER ',' NULL AS 'NULL' csv HEADER

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id TEXT,
    employee_id INT,
    order_date TIMESTAMP,
    required_date TIMESTAMP,
    shipped_date TIMESTAMP,
    ship_via INT,
    freight VARCHAR (50),
    ship_name VARCHAR (100),
    ship_address VARCHAR (100),
    ship_city VARCHAR (20),
    ship_region VARCHAR (55),
    ship_postal_code VARCHAR (100),
    ship_country TEXT);

\copy orders FROM '.\\northwind_data_clean\\data\\orders.csv' DELIMITER ',' NULL AS 'NULL' CSV HEADER

DROP TABLE IF EXISTS products;
CREATE TABLE products (
    product_id SMALLINT PRIMARY KEY,
    product_name VARCHAR (50),
    supplier_id INT,
    category_id INT,
    quantity_per_unit VARCHAR (30),
    unit_price NUMERIC (5, 2),
    units_in_stock INT,
    units_on_order INT,
    reorder_level INT,
    discontinued SMALLINT
);

\copy products FROM './northwind_data_clean/data/products.csv' DELIMITER ',' NULL AS 'NULL' CSV HEADER

DROP TABLE IF EXISTS regions;
CREATE TABLE regions (
    region_id SERIAL PRIMARY KEY,
    region_description TEXT
);

\copy regions FROM './northwind_data_clean/data/regions.csv' DELIMITER ',' NULL AS 'NULL' CSV HEADER

DROP TABLE IF EXISTS shippers;
CREATE TABLE shippers (
    shipper_id SERIAL,
    company_name VARCHAR (50),
    phone VARCHAR (50));

\copy shippers FROM './northwind_data_clean/data/shippers.csv' DELIMITER ',' NULL AS 'NULL' CSV HEADER

DROP TABLE IF EXISTS suppliers;
CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY,
    company_name VARCHAR (100),
    contact_name TEXT,
    contact_title TEXT,
    address VARCHAR (70),
    city TEXT,
    region VARCHAR (20),
    postal_code VARCHAR (30),
    country TEXT,
    phone VARCHAR (30),
    fax VARCHAR (30),
    homepage VARCHAR (100));

\copy suppliers FROM './northwind_data_clean/data/suppliers.csv' DELIMITER ',' NULL AS 'NULL' CSV HEADER

DROP TABLE IF EXISTS territories;
CREATE TABLE territories (
    territory_id VARCHAR (20) PRIMARY KEY,
    territory_description TEXT,
    region_id INT);

\copy territories FROM './northwind_data_clean/data/territories.csv' DELIMITER ',' NULL AS 'NULL' CSV HEADER

/*
alter table foreing table name
add CONSTRAINT name foreing key table_ primary_table fkey
foreign key (<id>)
references primary table (primary_id)
*/

-- 1. Forein key employee_territories -primary key: employees
ALTER TABLE employee_territories
ADD CONSTRAINT emp_territories_employees_employees_fkey
FOREIGN KEY (employee_id)
REFERENCES employees(employee_id);

-- 2. Forein key orders -primary key: employees
ALTER TABLE orders
ADD CONSTRAINT orders_employees_fkey
FOREIGN KEY (employee_id)
REFERENCES employees (employee_id);

-- 3. Forein key products -primary key: suppliers
ALTER TABLE products
ADD CONSTRAINT products_suppliers_fkey
FOREIGN KEY (supplier_id)
REFERENCES suppliers(supplier_id);

-- 4. Forein key orders -primary key: customers
ALTER TABLE orders
ADD CONSTRAINT orders_customers_fkey
FOREIGN KEY (customer_id)
REFERENCES customers (customer_id);

-- 5. Forein key territories -primary key: regions
ALTER TABLE territories
ADD CONSTRAINT territories_regions_fkey
FOREIGN KEY (region_id)
REFERENCES regions (region_id);

-- 6. Forein key employee_territories -primary key: territories
ALTER TABLE employee_territories
ADD CONSTRAINT emp_territories_territories_fkey
FOREIGN KEY (territory_id)
REFERENCES territories (territory_id);

-- 7. Forein key products -primary key: categories
ALTER TABLE products
ADD CONSTRAINT products_categories_fkey
FOREIGN KEY (category_id)
REFERENCES categories (category_id);

-- 8. Forein key order_details -primary key: products
ALTER TABLE order_details
ADD CONSTRAINT order_details_products_fkey
FOREIGN KEY (product_id)
REFERENCES products (product_id);

-- 9. !!! Nochmal Anschauen! Forein key orders -primary key: order_details
ALTER TABLE order_details
ADD CONSTRAINT orders_details_orders_fkey
FOREIGN KEY (order_id)
REFERENCES orders (order_id);