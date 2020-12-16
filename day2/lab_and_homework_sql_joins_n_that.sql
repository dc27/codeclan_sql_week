-- MVP

-- Q1

SELECT
	e.*,
	pd.local_account_no,
	pd.local_sort_code
FROM employees AS e
	LEFT JOIN pay_details AS pd
ON e.pay_detail_id = pd.id; 

-- Q2

SELECT
	e.*,
	pd.local_account_no,
	pd.local_sort_code,
	t.name AS team_name
FROM employees AS e
	LEFT JOIN pay_details AS pd
ON e.pay_detail_id = pd.id
	LEFT JOIN teams AS t
ON e.team_id = t.id;

-- Q3

SELECT 
	e.first_name,
	e.last_name,
	t.name AS team_name,
	t.charge_cost 
FROM employees AS e
	LEFT JOIN teams AS t
ON e.team_id = t.id 
WHERE CAST(t.charge_cost AS INT) > 80
ORDER BY e.last_name NULLS LAST;

-- Q4

SELECT 
	COUNT(e.id) AS no_employees,
	t.name AS team_name
FROM employees AS e
	RIGHT JOIN teams AS t
ON e.team_id = t.id
GROUP BY team_name 
ORDER BY no_employees NULLS LAST;

-- Q5

SELECT 
	id,
	first_name,
	last_name,
	fte_hours,
	salary,
	salary*fte_hours AS effective_salary,
	SUM(salary*fte_hours) OVER (ORDER BY salary*fte_hours ASC NULLS LAST) AS running_total
FROM employees; 

-- Q6

SELECT 
	COUNT(e.id)*CAST(t.charge_cost AS INT) AS total_day_charge,
	t.name AS team_name
FROM employees AS e
	RIGHT JOIN teams AS t
ON e.team_id = t.id
GROUP BY t.id;

-- Q7

SELECT 
	COUNT(e.id)*CAST(t.charge_cost AS INT) AS total_day_charge,
	t.name AS team_name
FROM employees AS e
	RIGHT JOIN teams AS t
ON e.team_id = t.id
GROUP BY t.id
HAVING COUNT(e.id)*CAST(t.charge_cost AS INT) > 5000;

-- orr could do it with a with I suppose

WITH total_day_charges (total_day_charge, team_name) AS(
SELECT 
	COUNT(e.id)*CAST(t.charge_cost AS INT) AS total_day_charge,
	t.name AS team_name
FROM employees AS e
	RIGHT JOIN teams AS t
ON e.team_id = t.id
GROUP BY t.id
)
SELECT 
	total_day_charge,
	team_name
FROM total_day_charges
WHERE total_day_charge > 5000;

-- Extension -- 

-- Q1

WITH no_of_committees (full_name, n_of_committees) AS(
SELECT
	DISTINCT(concat(first_name, ' ', last_name)) AS full_name,
	COUNT(ec.employee_id) AS n_of_committees
FROM employees AS e
	LEFT JOIN employees_committees AS ec
ON e.id = ec.employee_id
GROUP BY full_name
)
SELECT *
FROM no_of_committees
WHERE n_of_committees >= 1
ORDER BY
	n_of_committees DESC NULLS LAST,
	full_name ASC NULLS LAST;
	
-- if it was just the number that was required:
SELECT 
	COUNT(DISTINCT(employee_id)) AS no_of_keen_beans
FROM employees_committees; 

-- Q2

WITH no_of_committees (full_name, n_of_committees) AS(
SELECT
	DISTINCT(concat(first_name, ' ', last_name)) AS full_name,
	COUNT(ec.employee_id) AS n_of_committees
FROM employees AS e
	LEFT JOIN employees_committees AS ec
ON e.id = ec.employee_id
GROUP BY full_name
)
SELECT *
FROM no_of_committees
WHERE n_of_committees = 0
ORDER BY
	n_of_committees DESC NULLS LAST,
	full_name ASC NULLS LAST;

-- if it was just the number that was required:

WITH no_of_committees (full_name, n_of_committees) AS(
SELECT
	DISTINCT(concat(first_name, ' ', last_name)) AS full_name,
	COUNT(ec.employee_id) AS n_of_committees
FROM employees AS e
	LEFT JOIN employees_committees AS ec
ON e.id = ec.employee_id
GROUP BY full_name
)
SELECT
	COUNT(*) AS no_of_unkeen_beans
FROM no_of_committees
WHERE n_of_committees = 0;


-- Q3

WITH no_of_committees (full_name, n_of_committees) AS(
SELECT
	DISTINCT(concat(first_name, ' ', last_name)) AS full_name,
	COUNT(ec.employee_id) AS n_of_committees,
	ec.employee_id,
	e.*
FROM employees AS e
	LEFT JOIN employees_committees AS ec
ON e.id = ec.employee_id
GROUP BY
	full_name,
	e.id,
	ec.employee_id 
), ec_and_names (id, employee_id, committee_name) AS (
SELECT
	ec.*,
	c.name AS commitee_name
FROM employees_committees AS ec
	LEFT JOIN committees AS c
ON ec.committee_id = c.id
)
SELECT *
FROM no_of_committees AS no_o_c
	LEFT JOIN ec_and_names AS ecn
ON no_o_c.employee_id = ecn.employee_id
WHERE n_of_committees >= 1 AND country ='China'
ORDER BY
	n_of_committees DESC NULLS LAST,
	full_name ASC NULLS LAST;

-- Q4

-- I don't think I got the right answer here, but called it a day anyway.

WITH no_of_committees (full_name, committee_member, team_id, id) AS(
SELECT
	DISTINCT(concat(first_name, ' ', last_name)) AS full_name,
	COUNT(ec.employee_id)>=1 AS committee_member,
	e.team_id,
	e.id
FROM employees AS e
	INNER JOIN employees_committees AS ec
ON e.id = ec.employee_id
GROUP BY
	full_name,
	e.team_id,
	e.id
), employee_teams (team_id, id, team_name) AS(
SELECT 
	e.team_id,
	e.id,
	t.name AS team_name
FROM employees AS e
	LEFT JOIN teams as t
ON e.team_id = t.id
)
SELECT
	COUNT(DISTINCT(no_c.id)) AS no_of_committee_members,
 	e_t.team_name
FROM no_of_committees AS no_c
	RIGHT JOIN employee_teams AS e_t
ON no_c.team_id = e_t.id
GROUP BY e_t.team_name
ORDER BY no_of_committee_members DESC;

-- The actual answer

SELECT 
	t.name AS team_name,
	COUNT(DISTINCT(e.id)) AS no_of_committee_members
FROM employees AS e
	INNER JOIN employees_committees AS ec
ON e.id = ec.employee_id
	RIGHT JOIN committees AS c
ON ec.committee_id = c.id
	RIGHT JOIN teams AS t
ON e.team_id = t.id
GROUP BY team_name
ORDER BY no_of_committee_members DESC  NULLS LAST;







