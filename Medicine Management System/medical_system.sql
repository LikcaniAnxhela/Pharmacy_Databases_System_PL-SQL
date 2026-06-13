--USERS TABLE--
CREATE TABLE users (
user_id NUMBER PRIMARY KEY, 
username VARCHAR2(50) UNIQUE NOT NULL,
password VARCHAR2(100) NOT NULL,
name VARCHAR2(100),
email VARCHAR2(100),
role VARCHAR2(20) CHECK (role IN ('MANAGER', 'STAFF'))
);

--CUSTOMERS TABLE--
CREATE TABLE customers (
customer_id NUMBER PRIMARY KEY, 
name VARCHAR2(100),
age NUMBER CHECK (age>0),
sex CHAR(1)CHECK (sex IN ('M','F')),
problem VARCHAR2(200)
);
SELECT * FROM CUSTOMERS;

--MEDICINES TABLE--
CREATE TABLE medicines (
product_code NUMBER PRIMARY KEY, 
product_name VARCHAR2(100) NOT NULL,
mrp NUMBER(8,2) CHECK (mrp>0),
quantity NUMBER CHECK (quantity>=0),
expiry_date DATE NOT NULL
);
SELECT *FROM USERS;

--SALES TABLE--
CREATE TABLE sales (
sale_id NUMBER PRIMARY KEY, 
customer_id NUMBER REFERENCES customers(customer_id),
product_code NUMBER REFERENCES medicines(product_code),
quantity_sold NUMBER CHECK (quantity_sold>0),
sale_date DATE DEFAULT SYSDATE
);

--REPORTS TABLE--
CREATE TABLE reports (
reports_id NUMBER PRIMARY KEY, 
report_type VARCHAR2(50),
generated_date DATE DEFAULT SYSDATE,
viewed_by NUMBER REFERENCES users(user_id)
);

--INDEXES--
CREATE INDEX idx_medicine_code ON medicines(product_code);
CREATE INDEX idx_medicine_code ON medicines(product_name);

--SAMPLE DATA INSERTION--
--USERS
INSERT INTO users VALUES (1, 'admin', 'admin123', 'Main Manager', 'mng123@medical.al', 'MANAGER');
INSERT INTO users VALUES (2, 'satff', 'satff123', 'Staff One', 'staff1@medical.al', 'STAFF');

--Customers
INSERT INTO customers VALUES (1, 'Emma', 23, 'F', 'Fever');
INSERT INTO customers VALUES (2, 'Sara', 34, 'F', 'Cold');
INSERT INTO customers VALUES (3, 'Michael', 65, 'M', 'Diabetes');

--MEDICINES
INSERT INTO medicines VALUES (101, 'Paracetamol', 50,200,DATE '2026-06-30');
INSERT INTO medicines VALUES (102, 'Ibuprofen', 80,150,DATE '2026-03-15');
INSERT INTO medicines VALUES (103, 'Amoxicillin', 120,50,DATE '2026-01-30');
INSERT INTO medicines VALUES (104, 'Vitamin C', 40,0,DATE '2026-07-27');


--SALES 
INSERT INTO sales VALUES (1,1,101,5, ADD_MONTHS(SYSDATE,-1));
INSERT INTO sales VALUES (2,2,102,3, SYSDATE);
INSERT INTO sales VALUES (3,3,103,10, ADD_MONTHS(SYSDATE,-2));
INSERT INTO sales VALUES (4,1,102,2, SYSDATE);

--REPORTS
INSERT INTO reports VALUES (1, 'Sales Report', SYSDATE,1);
INSERT INTO reports VALUES (2, 'Stock Report', SYSDATE,1);

COMMIT;