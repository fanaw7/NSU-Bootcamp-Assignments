/* Write a query that selects all the employees who were born between January 1, 1952
and December 31, 1955 (the employees that are about to retire) and their titles and 
title date ranges. Order the results by `emp_no`.*/
SELECT 
	employees.emp_no, 
	employees.first_name,
	employees.last_name,
	titles.title,
	titles.from_date,
	titles.to_date
	FROM employees 
	JOIN titles ON employees.emp_no = titles.emp_no
	WHERE birth_date BETWEEN '1952/01/01' AND '1955/12/31'
	ORDER BY emp_no
	
/*  Write another query that builds off of the previous query, but selects only the current title for each employee.*/

SELECT DISTINCT emp_no, first_name, last_name, last_value(title) OVER (PARTITION BY emp_no ORDER BY from_date
                           RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM (
SELECT 
	employees.emp_no, 
	employees.first_name,
	employees.last_name,
	titles.title,
	titles.from_date,
	titles.to_date
	FROM employees 
	JOIN titles ON employees.emp_no = titles.emp_no
	WHERE birth_date BETWEEN '1952/01/01' AND '1955/12/31'
	ORDER BY emp_no
	) emp_titles

		
/*   Write a query that counts the total number of employees about to retire by their current job title. */	


SELECT DISTINCT 
	title, COUNT(*)
	FROM employees 
	JOIN titles ON employees.emp_no = titles.emp_no
	WHERE birth_date BETWEEN '1952/01/01' AND '1955/12/31'
	GROUP BY title
	
	
/* Write a query to count the total number of employees per department.*/

With latest_dept AS  (SELECT DISTINCT emp_no, last_value(dept_no) OVER (PARTITION BY emp_no ORDER BY from_date
                           RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as dept_no
	FROM dept_emp)
Select dept_name, count(distinct emp_no) as emp_count from latest_dept LEFT JOIN departments on latest_dept.dept_no = departments.dept_no
GROUP BY dept_name
