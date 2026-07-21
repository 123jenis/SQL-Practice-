SELECT * FROM departments;
SELECT * FROM employees;
SELECT * FROM sales;

-- Full Outer Join 
/* An OUTER JOIN returns matching rows from both tables plus the unmatched rows from one or both tables (filling in NULL for missing values). 
   This is different from an INNER JOIN, which only returns rows that match in both tables. */

-- 🟢 BASIC (Q1–Q3)

-- Q1. Write a FULL OUTER JOIN query between employees and departments to list every employee with their department name, and every department even if it has no employees.

-- Q2. Explain the difference between what FULL OUTER JOIN returns vs LEFT JOIN for the employees and departments tables above.

-- Q3. Since MySQL doesn't support FULL OUTER JOIN, write the equivalent using UNION of a LEFT JOIN and RIGHT JOIN between employees and departments.

-- 🟡 INTERMEDIATE (Q4–Q7)

-- Q4. Write a FULL OUTER JOIN query between employees and sales that shows every employee along with their total sales, including employees who made no sales, and any sales records with a missing/invalid emp_id.

-- Q5. Using FULL OUTER JOIN between employees and departments, write a query that returns only the mismatched rows — i.e., employees with no valid department, and departments with zero employees.

-- Q6. Write a FULL OUTER JOIN query between employees and sales that replaces NULL total sales with 0 using COALESCE, and also flags each row as 'No Sales' or 'Has Sales'.

-- Q7. Count how many departments have zero employees, and how many employees have no department assigned, both in a single FULL OUTER JOIN query using COUNT() and GROUP BY.

-- 🔴 ADVANCED (Q8–Q10)

-- Q8. Write a query that does a FULL OUTER JOIN across all three tables — departments, employees, and sales — to produce one master report: department name, employee name, and total sales (handling NULLs at every level).

-- Q9. For the 3-table query above, explain what problems can occur (e.g., duplicate rows, NULL cascading, incorrect aggregation) when chaining multiple FULL OUTER JOINs together, and how you'd fix them.

-- Q10. A manager wants a report showing: every department, its total employee count, and its total sales amount — even for departments with no employees or no sales. Write the full query using FULL OUTER JOIN + aggregate functions (COUNT, SUM) + GROUP BY.

-- Basic

/* Q1. Write a FULL OUTER JOIN query between employees and departments to list every employee with their department name, and 
every department even if it has no employees. */
SELECT *
FROM departments d
FULL OUTER JOIN employees e
ON d.dept_id = e.dept_id;

-- Q2. Explain the difference between what FULL OUTER JOIN returns vs LEFT JOIN for the employees and departments tables above.
-- Join Type	Returns
-- LEFT JOIN	All rows from the left table (employees) + matching rows from departments. Unmatched departments rows are NOT included.
-- FULL OUTER JOIN	All rows from both tables — matched + unmatched from employees AND unmatched from departments.

-- Q3. Since MySQL doesn't support FULL OUTER JOIN, write the equivalent using UNION of a LEFT JOIN and RIGHT JOIN between employees and departments.
SELECT e.name, d.dept_name
FROM employees e
LEFT JOIN departments d
ON d.dept_id = e.dept_id

UNION 

SELECT e.name, d.dept_name
FROM employees e
RIGHT JOIN departments d
ON d.dept_id = e.dept_id;

-- 🟡 INTERMEDIATE (Q4–Q7)

/* Q4. Write a FULL OUTER JOIN query between employees and sales that shows every employee along with their total sales, 
   including employees who made no sales, and any sales records with a missing/invalid emp_id. */

SELECT e.name, SUM(s.amount) AS Total_Salary
FROM sales s
FULL OUTER JOIN employees e
ON e.emp_id = s.emp_id
GROUP BY e.emp_id,e.name;

/* Q5. Using FULL OUTER JOIN between employees and departments, write a query that returns only the mismatched rows — i.e., 
	   employees with no valid department, and departments with zero employees. */

SELECT e.name, d.dept_name,e.emp_id, d.dept_id
FROM employees e
FULL OUTER JOIN departments d
ON e.dept_id = d.dept_id
WHERE d.dept_id IS NULL OR e.emp_id IS NULL;

/* Q6. Write a FULL OUTER JOIN query between employees and sales that replaces NULL total sales with 0 using COALESCE, 
and also flags each row as 'No Sales' or 'Has Sales'.*/

SELECT e.name,e.emp_id,
	COALESCE(SUM (s.amount), 0) AS Total_Sales,
	CASE 
		WHEN SUM(s.amount) IS NULL THEN 'No Sales'
		ELSE 'Has Sales'
		END AS Sales_Status
FROM sales s
FULL OUTER JOIN employees e
ON e.emp_id = s.emp_id
GROUP BY e.emp_id , e.name;

/* 7. Count how many departments have zero employees, and how many employees have no department assigned, 
	  both in a single FULL OUTER JOIN query using COUNT() and GROUP BY. */
-- Without Group By

SELECT 
COUNT(CASE WHEN e.emp_id IS NULL THEN 1 END) AS departments_with_zero_employee,
COUNT(CASE WHEN d.dept_id IS NULL THEN 1 END) AS Employee_have_no_department
FROM employees e
FULL OUTER JOIN departments d
ON e.dept_id = d.dept_id;

-- With Group By
SELECT 
    CASE 
        WHEN e.emp_id IS NULL THEN 'Department with zero employees'
        WHEN d.dept_id IS NULL THEN 'Employee with no department'
    END AS mismatch_type,
    COUNT(*) AS total_count
FROM employees e
FULL OUTER JOIN departments d
ON e.dept_id = d.dept_id
WHERE e.emp_id IS NULL OR d.dept_id IS NULL
GROUP BY 
    CASE 
        WHEN e.emp_id IS NULL THEN 'Department with zero employees'
        WHEN d.dept_id IS NULL THEN 'Employee with no department'
    END;

-- 🔴 ADVANCED (Q8–Q10)

/* Q8. Write a query that does a FULL OUTER JOIN across all three tables — departments, employees, and sales — 
to produce one master report: department name, employee name, and total sales (handling NULLs at every level). */

SELECT d.dept_name, e.name,
	COALESCE (SUM(s.amount), 0) AS TOtal_Sales
FROM employees e
FULL OUTER JOIN departments d
ON d.dept_id = e.dept_id
FULL OUTER JOIN sales s
ON e.emp_id = s.emp_id
GROUP BY d.dept_name , e.name;

/* Q9. For the 3-table query above, explain what problems can occur (e.g., duplicate rows, NULL cascading, incorrect aggregation) 
when chaining multiple FULL OUTER JOINs together, and how you'd fix them. */

-- Problem 1
SELECT d.dept_name, e.name, s.amount
FROM departments d
FULL OUTER JOIN employees e
ON d.dept_id = e.dept_id
FULL OUTER JOIN sales s
ON s.emp_id = e.emp_id;   

-- Problem 2
SELECT d.dept_name, e.name, COALESCE(sub.total_sales, 0) AS Total_Sales
FROM departments d
FULL OUTER JOIN employees e 
    ON d.dept_id = e.dept_id
FULL OUTER JOIN (
    SELECT emp_id, SUM(amount) AS total_sales
    FROM sales
    GROUP BY emp_id
) sub 
    ON e.emp_id = sub.emp_id;

/* Q10. A manager wants a report showing: every department, its total employee count, and its total sales amount — 
even for departments with no employees or no sales. Write the full query using FULL OUTER JOIN + aggregate functions (COUNT, SUM) + GROUP BY. */

SELECT d.dept_name,
COUNT(DISTINCT e.emp_id) AS Total_employee,
COALESCE(SUM(s.amount), 0) AS Total_Sales
FROM departments d
FULL OUTER JOIN employees e
ON d.dept_id = e.dept_id
FULL OUTER JOIN sales s
ON e.emp_id = s.emp_id
GROUP BY d.dept_name;





	
	







