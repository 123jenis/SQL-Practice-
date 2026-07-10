CREATE DATABASE company;

USE company;

CREATE TABLE employee(
	employee_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    position VARCHAR(50),
    department VARCHAR(50),
    hire_date DATE,
    salary NUMERIC(10,2)
);

INSERT INTO employee(name, position, department, hire_date, salary) 
VALUES('Jenish Malaviya', 'Data Analyst', 'Data Science', '2026-07-06', 25000.00),
	  ('Rahul Verma', 'Data Engineer', 'Data Science', '2025-11-20', 45000.00),
	  ('Ananya Iyer', 'Data Scientist', 'Analytics', '2025-08-10', 60000.00),
	  ('Karan Mehta', 'SQL Developer', 'IT', '2026-03-01', 38000.00),
	  ('Sneha Reddy', 'Power BI Developer', 'Analytics', '2025-12-05', 42000.00);
      
SELECT * FROM employee;

# Remove The all the data in table
TRUNCATE TABLE employee;

# Delete Row and Column Perticular data 
DELETE FROM employee
WHERE department = 'IT';

# Drop Delete Fully Table and Column 
ALTER TABLE employee
DROP COLUMN salary;

# Remove all the data in table 
TRUNCATE TABLE employee;

# Rename the Column 
ALTER TABLE employee
RENAME COLUMN hire_date TO Hire_date;

# Update data
UPDATE employee
SET salary = 100000
WHERE name = 'Jenish Malaviya';

UPDATE employee
SET name = 'Kriya Patel', position = 'Ai Engineer'
WHERE employee_id = 1;

# ASC or DESC 
SELECT * FROM employee
ORDER BY hire_date 
DESC;




