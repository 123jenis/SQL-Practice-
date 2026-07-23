SELECT * FROM employees_2;

-- 1. For each department, show every employee's salary along with the salary of the employee hired just before them (ordered by hire_date). Use LAG.
-- 2. For each employee, show their salary and the salary of the next person hired in the same department. If there's no next person, show 0 instead of NULL. Use LEAD with a default.
-- 3. For each department, calculate the difference between an employee's salary and the previous hire's salary (salary growth/drop over hiring sequence).
-- 4. For each region, show each employee's salary next to the lowest salary in that region (using FIRST_VALUE ordered by salary ascending).
-- 5. For each department, show each employee's salary next to the highest salary in that department (using FIRST_VALUE ordered by salary descending).
-- 6. For each region, find the 2nd highest salary using NTH_VALUE (remember to handle the frame clause — ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING).
-- 7. For each department, show each employee alongside the most recently hired employee's salary in that department, using LAST_VALUE with the correct frame clause.
-- 8. Write a query that shows, for each employee, whether their salary is higher, lower, or same as the previous hire in their department (use LAG + CASE).
-- 9. For each region, find the employee with the 3rd highest salary using NTH_VALUE, and only return that one row per region (hint: wrap in a subquery/CTE and filter).
-- 10. Combine LAG and LEAD in one query to show each employee's salary along with the previous and next hire's salary in the same department — then flag rows where the current salary is a "local peak" (higher than both neighbors).

-- Solve Questuions

-- 1. For each department, show every employee's salary along with the salary of the employee hired just before them (ordered by hire_date). Use LAG.

SELECT emp_name, department, salary, join_date,
	LAG(salary,1) OVER (PARTITION BY department ORDER BY join_date) AS Prev_salary
FROM employees_2
ORDER BY department, join_date;

-- 2. For each employee, show their salary and the salary of the next person hired in the same department. If there's no next person, show 0 instead of NULL. Use LEAD with a default.

SELECT emp_name, department, salary, join_date,
	LEAD(salary, 1, 0) OVER (PARTITION BY department ORDER BY join_date) AS Show_next_person_salary
FROM employees_2
ORDER BY department, join_date;

-- 3. For each department, calculate the difference between an employee's salary and the previous hire's salary (salary growth/drop over hiring sequence).

SELECT emp_name, department, salary, join_date,
    salary - LAG(salary, 1, salary) OVER (PARTITION BY department ORDER BY join_date) AS salary_diff
FROM employees_2
ORDER BY department, join_date;

-- 4. For each region, show each employee's salary next to the lowest salary in that region (using FIRST_VALUE ordered by salary ascending).

SELECT emp_name, department, salary, join_date, 
	FIRST_VALUE (salary) OVER (PARTITION BY department ORDER BY salary ASC) AS Lowest_in_department
FROM employees_2
ORDER BY join_date, department;

-- 5. For each department, show each employee's salary next to the highest salary in that department (using FIRST_VALUE ordered by salary descending).

SELECT * ,
	FIRST_VALUE(salary) OVER (PARTITION BY department ORDER BY salary DESC ) AS Highest_Salary_in_dept
FROM employees_2
ORDER BY department, join_date;

-- 6. For each region, find the 2nd highest salary using NTH_VALUE (remember to handle the frame clause — ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING).

SELECT * ,
	NTH_VALUE(salary, 2) OVER (PARTITION BY department ORDER BY salary 
	ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS highest_2_salary
FROM employees_2
ORDER BY salary, department;

-- 7. For each department, show each employee alongside the most recently hired employee's salary in that department, using LAST_VALUE with the correct frame clause.

SELECT * ,
	LAST_VALUE(salary) OVER (PARTITION BY department ORDER BY join_date ASC
	ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS most_recent_hire_salary
FROM employees_2
ORDER BY department , join_date;


SELECT emp_name, department, salary, join_date,
    FIRST_VALUE(salary) OVER (
        PARTITION BY department 
        ORDER BY join_date ASC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS most_recent_hire_salary
FROM employees_2
ORDER BY department, join_date;

-- 8. Write a query that shows, for each employee, whether their salary is higher, lower, or same as the previous hire in their department (use LAG + CASE).

SELECT emp_name, department, salary, join_date,
    LAG(salary, 1) OVER (PARTITION BY department ORDER BY join_date) AS prev_salary,
    CASE 
        WHEN LAG(salary, 1) OVER (PARTITION BY department ORDER BY join_date) IS NULL THEN 'First Hire'
        WHEN salary > LAG(salary, 1) OVER (PARTITION BY department ORDER BY join_date) THEN 'Higher'
        WHEN salary < LAG(salary, 1) OVER (PARTITION BY department ORDER BY join_date) THEN 'Lower'
        ELSE 'Same'
    END AS salary_comparison
FROM employees_2
ORDER BY department, join_date;

-- 9. For each region, find the employee with the 3rd highest salary using NTH_VALUE, and only return that one row per region (hint: wrap in a subquery/CTE and filter).

WITH ranked_employees AS (
    SELECT emp_name, department, salary, join_date,
        NTH_VALUE(salary, 3) OVER (
            PARTITION BY department
            ORDER BY salary DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS third_highest_salary,
        ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS rn
    FROM employees_2
)
SELECT emp_name, department, salary, join_date, third_highest_salary
FROM ranked_employees
WHERE rn = 3;

-- 10. Combine LAG and LEAD in one query to show each employee's salary along with the previous and next hire's salary in the same department — then flag rows where the current salary is a "local peak" (higher than both neighbors).

SELECT emp_name, department, salary,join_date,
	LAG(salary, 1, 0) OVER (PARTITION BY department ORDER BY join_date) AS Prev_salary,
	LEAD(salary, 1, 0) OVER (PARTITION BY department ORDER BY join_date) AS Next_salary,
	CASE
		WHEN salary > LAG(salary, 1, 0) OVER (PARTITION BY department ORDER BY join_date) 
		AND salary > LEAD(salary, 1, 0) OVER (PARTITION BY department ORDER BY join_date)
		THEN 'Yes'
		ELSE 'No'
	END AS Peak_flag
FROM employees_2
ORDER BY department,join_date;
