SELECT * FROM departments;
SELECT * FROM employees;
SELECT * FROM sales;

-- 🟢 Basic (1–3)

-- Q1. Write a query to display all department names along with all employee names using CROSS JOIN.

-- Q2. List all employees who do not have an email (email IS NULL).

-- Q3. Find all employees who earn a salary greater than 50000.

-- 🟡 Intermediate (4–7)

-- Q4. Using CROSS JOIN, generate all possible combinations of dept_name and product from sales, but only keep rows where dept_id matches between departments and the employee who made that sale (i.e., turn the cross join into an effective INNER JOIN using WHERE).

-- Q5. Write a query using INNER JOIN to show emp_name, dept_name, and location for all employees who belong to a department (exclude employees with dept_id IS NULL).

-- Q6. Write a query using LEFT JOIN to list all departments and their employees — including departments that have no employees (like Marketing).

-- Q7. Find the total amount of sales made by each employee (use GROUP BY with SUM).

-- 🔴 Advanced (8–10)

-- Q8. Write a query to find employees who never made a sale (hint: LEFT JOIN employees with sales, filter sale_id IS NULL).

-- Q9. Using CROSS JOIN, create a report that pairs every employee with every department, then filter using WHERE to show only rows where the employee's actual dept_id does not match — i.e., "which department is this employee NOT in."

-- Q10. Find each employee's manager name (self-join employees table on manager_id = emp_id), along with total sales amount for that employee (combine self-join + LEFT JOIN with sales + GROUP BY).

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Q1. Write a query to display all department names along with all employee names using CROSS JOIN.

SELECT d.dept_name, e.name
FROM employees e
CROSS JOIN departments d ;

-- Q2. List all employees who do not have an email (email IS NULL).
-- 💡 Key lesson
/* CROSS JOIN should only be used when you genuinely need every combination of two tables. If your query 
only needs data from one table, don't join at all — it just creates duplicate/inflated rows. */

SELECT e.name, e.email
FROM employees e
-- CROSS JOIN departments d
WHERE e.email IS NULL;

-- Q3. Find all employees who earn a salary greater than 10000.

SELECT e.name, s.amount
FROM sales s
CROSS JOIN employees e
WHERE s.amount > 10000;

/*  Q4. Using CROSS JOIN, generate all possible combinations of dept_name and product from sales, but only keep 
rows where dept_id matches between departments and the employee who made that sale (i.e., turn the cross join into an effective INNER JOIN using WHERE). */

-- 💡 Key lesson

/* CROSS JOIN + WHERE only becomes "effective INNER JOIN" when your WHERE clause compares the actual matching columns (d.dept_id = e.dept_id). Filtering on unrelated 
   columns (like amount IS NOT NULL) doesn't restrict the combinations — it leaves the full Cartesian product mostly intact. */
   
SELECT d.dept_id, d.dept_name, s.product, e.name
FROM sales s
INNER JOIN employees e
ON e.emp_id = s.emp_id
CROSS JOIN departments d
WHERE d.dept_id = e.dept_id;

-- Q5. Write a query using INNER JOIN to show emp_name, dept_name, and location for all employees who belong to a department (exclude employees with dept_id IS NULL).
/* Once you've written the matching condition in ON, you don't need to repeat it in WHERE. Keep join conditions in ON and use 
   WHERE only for additional filters (like salary > 50000, email IS NULL */

SELECT e.name, d.dept_name, d.location
FROM employees e
INNER JOIN departments d
ON e.dept_id = d.dept_id;

-- Q6. Write a query using LEFT JOIN to list all departments and their employees — including departments that have no employees (like Marketing).

SELECT d.dept_name, e.name
FROM departments d
LEFT JOIN employees e
ON d.dept_id = e.dept_id
WHERE e.name IS NULL;

-- Q7. Find the total amount of sales made by each employee (use GROUP BY with SUM).

SELECT e.name, SUM(s.amount) AS Total_amount
FROM employees e
INNER JOIN sales s
ON e.emp_id = s.emp_id
GROUP BY e.name;

-- Q8. Write a query to find employees who never made a sale (hint: LEFT JOIN employees with sales, filter sale_id IS NULL).

SELECT e.name, s.sale_id
FROM employees e
LEFT JOIN sales s
ON e.emp_id = s.emp_id
WHERE s.sale_id IS NULL;

/* Q9. Using CROSS JOIN, create a report that pairs every employee with every department, then filter using WHERE 
       to show only rows where the employee's actual dept_id does not match — i.e., "which department is this employee NOT in." */

SELECT e.name, d.dept_name AS not_in_department
FROM employees e
CROSS JOIN departments d
WHERE d.dept_id <> e.dept_id;

/* Q10. Find each employee's manager name (self-join employees table on manager_id = emp_id), along with total sales amount for that employee 
        (combine self-join + LEFT JOIN with sales + GROUP BY). */

SELECT e.name, m.name,
COALESCE(SUM (s.amount), 0) AS Total_Sales_Amount
FROM employees e
LEFT JOIN employees m
ON e.manager_id = m.emp_id
LEFT JOIN sales s
ON e.emp_id = s.emp_id
GROUP BY e.name, m.emp_id;

SELECT e.name AS employee_name, 
       m.name AS manager_name, 
       COALESCE(SUM(s.amount), 0) AS Total_sales_amount
FROM employees e
LEFT JOIN employees m 
    ON e.manager_id = m.emp_id      -- self join
LEFT JOIN sales s 
    ON e.emp_id = s.emp_id          -- sales join
GROUP BY e.name, m.name;

