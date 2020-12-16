-- Q1

SELECT *
FROM pay_details
WHERE iban IS NULL AND local_account_no IS NULL;

-- Q2

SELECT
	first_name,
	last_name,
	country
FROM employees
ORDER BY
	country NULLS LAST,
	last_name NULLS LAST; 

-- Q3

SELECT
	CONCAT(first_name, ' ', last_name) AS full_name,
	salary
FROM employees
ORDER BY salary DESC NULLS LAST
LIMIT 10;

-- Q4

SELECT
	first_name,
	last_name,
	salary
FROM employees
WHERE country = 'Hungary'
ORDER BY salary ASC NULLS LAST
LIMIT 1;


-- Q5

SELECT *
FROM employees
WHERE email LIKE '%yahoo%';

-- Q6

SELECT
	CAST(pension_enrol AS VARCHAR),
	COUNT(id)
FROM employees
GROUP BY pension_enrol

-- Q7

SELECT *
FROM employees
WHERE department ='Engineering' AND fte_hours ='1.0'
ORDER BY salary DESC NULLS LAST
LIMIT 1;

-- Q8

	
WITH country_avgs(country, n_employees, avg_salary) AS (
 	SELECT
		country,
		count(id) AS n_employees,
		AVG(salary) AS avg_salary
	FROM employees
	GROUP BY country
)
SELECT
	c_avgs.country,
	c_avgs.n_employees,
	c_avgs.avg_salary
FROM employees AS e
	LEFT JOIN country_avgs AS c_avgs
ON e.country = c_avgs.country
WHERE n_employees > 30
GROUP BY
	c_avgs.country,
	c_avgs.n_employees,
	c_avgs.avg_salary
ORDER BY c_avgs.avg_salary DESC NULLS LAST;

-- Q9

SELECT 
	id,
	first_name,
	last_name,
	fte_hours,
	salary,
	salary*fte_hours AS effective_salary
FROM employees; 

-- Q10

SELECT
	e.first_name,
	e.last_name,
	CONCAT(e.first_name,' ',e.last_name) AS full_name,
	p_d.local_tax_code 
FROM employees AS e
	INNER JOIN pay_details AS p_d
ON e.pay_detail_id = p_d.id 
WHERE local_tax_code IS NULL;

-- Q11

SELECT
	e.id,
	e.first_name,
	e.last_name,
	e.salary,
	e.fte_hours, 
	t."name",
	t.charge_cost,
	(48 * 35 * CAST(t.charge_cost AS INT) -  e.salary) * e.fte_hours AS expected_profit
FROM employees AS e
	LEFT JOIN teams AS t
ON e.team_id = t.id

-- Q12

WITH biggest_department(n_employees, department) AS (
SELECT 
	COUNT(id) AS n_employees,
	department
FROM employees
GROUP BY department
ORDER BY COUNT(id) DESC NULLS LAST 
LIMIT 1),
department_avg_salary(department, avg_salary_in_dept, avg_fte_hrs_in_dept) AS (
SELECT
	department,
	AVG(salary),
	AVG(fte_hours)
FROM employees
GROUP BY department)
SELECT
	e.id,
	e.first_name,
	e.last_name,
	e.salary,
	e.fte_hours,
	e.department,
	d_avg_s.avg_salary_in_dept,
	d_avg_s.avg_fte_hrs_in_dept,
	e.salary / d_avg_s.avg_salary_in_dept AS salary_vs_dept_avg,
	e.fte_hours /d_avg_s.avg_fte_hrs_in_dept AS fte_hrs_vs_salary_avg
FROM employees AS e
	INNER JOIN biggest_department AS b_d
ON e.department = b_d.department
	INNER JOIN department_avg_salary AS d_avg_s
ON e.department = d_avg_s.department;

-- Aileen's way

SELECT
	id,
	first_name,
	last_name,
	salary,
	fte_hours,
	department,
	salary/ AVG(salary) OVER () AS ratio_avg_salary,
	fte_hours/AVG(fte_hours) OVER () AS ratio_fte_hours
FROM employees
WHERE department = (
	SELECT 
	department 
FROM employees 
GROUP BY department
ORDER BY COUNT(id) DESC 
LIMIT 1);


-- Extension
-- Q1

WITH first_name_freq (first_name, names_occurence) AS(
SELECT
	first_name,
	COUNT(first_name) AS names_occurence
FROM employees
GROUP BY first_name)
SELECT
	e.first_name, 
	fnf.names_occurence
FROM employees AS e
	INNER JOIN first_name_freq AS fnf
ON e.first_name = fnf.first_name
WHERE fnf.names_occurence >= 2
GROUP BY
	e.first_name,
	fnf.names_occurence
ORDER BY
	fnf.names_occurence DESC,
	e.first_name;

-- Q2

SELECT
	COALESCE(CAST(pension_enrol AS VARCHAR),'unknown'),
	COUNT(id)
FROM employees
GROUP BY pension_enrol

-- Q3
	
WITH equality_peeps(name, employee_id) AS (
SELECT
	c."name", 
	e_c.employee_id
FROM committees AS c
	INNER JOIN employees_committees AS e_c
ON c.id = e_c.committee_id
WHERE name = 'Equality and Diversity')
SELECT 
	e.id,
	e.first_name,
	e.last_name,
	e.email, 
	e.start_date
FROM employees AS e
	INNER JOIN equality_peeps AS ep
ON e.id = ep.employee_id
ORDER BY start_date ASC NULLS LAST

-- Q4

SELECT  
	CASE
		WHEN e.salary IS NULL THEN 'none'
		WHEN e.salary < 40000 THEN 'low'
		WHEN e.salary >= 40000 THEN 'high'
	END AS salary_class,
	COUNT(e.id) AS n_committee_members
FROM employees AS e
	INNER JOIN employees_committees AS ec
ON e.id = ec.employee_id
GROUP BY salary_class;













