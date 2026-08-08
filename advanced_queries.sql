USE employee_analysis;

-- 1. Employees earning more than the company average
SELECT employee_name, salary
FROM Employees
WHERE salary > (
    SELECT AVG(salary)
    FROM Employees
);

-- 2. Employees earning more than their department average
SELECT
    e.employee_name,
    d.department_name,
    e.salary
FROM Employees e
JOIN Departments d
    ON e.department_id = d.department_id
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM Employees e2
    WHERE e2.department_id = e.department_id
);

-- 3. Highest-paid employee in each department
SELECT
    d.department_name,
    e.employee_name,
    e.salary
FROM Employees e
JOIN Departments d
    ON e.department_id = d.department_id
WHERE e.salary = (
    SELECT MAX(e2.salary)
    FROM Employees e2
    WHERE e2.department_id = e.department_id
);

-- 4. Rank employees by salary within each department
SELECT
    e.employee_name,
    d.department_name,
    e.salary,
    RANK() OVER (
        PARTITION BY e.department_id
        ORDER BY e.salary DESC
    ) AS salary_rank
FROM Employees e
JOIN Departments d
    ON e.department_id = d.department_id;

-- 5. Top 2 highest-paid employees from each department
SELECT *
FROM (
    SELECT
        e.employee_name,
        d.department_name,
        e.salary,
        ROW_NUMBER() OVER (
            PARTITION BY e.department_id
            ORDER BY e.salary DESC
        ) AS employee_rank
    FROM Employees e
    JOIN Departments d
        ON e.department_id = d.department_id
) ranked
WHERE employee_rank <= 2;

-- 6. Employees earning more than their manager
SELECT
    e.employee_name,
    e.salary AS employee_salary,
    m.employee_name AS manager_name,
    m.salary AS manager_salary
FROM Employees e
JOIN Employees m
    ON e.manager_id = m.employee_id
WHERE e.salary > m.salary;

-- 7. Department average salary
SELECT
    d.department_name,
    AVG(e.salary) AS average_salary
FROM Departments d
JOIN Employees e
    ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name;

-- 8. Department with the highest average salary
SELECT
    d.department_name,
    AVG(e.salary) AS average_salary
FROM Departments d
JOIN Employees e
    ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
ORDER BY average_salary DESC
LIMIT 1;

-- 9. Employees working on more than one project
SELECT
    e.employee_name,
    COUNT(ep.project_id) AS project_count
FROM Employees e
JOIN Employee_Projects ep
    ON e.employee_id = ep.employee_id
GROUP BY e.employee_id, e.employee_name
HAVING COUNT(ep.project_id) > 1;

-- 10. Total project hours for each employee
SELECT
    e.employee_name,
    COALESCE(SUM(ep.hours), 0) AS total_hours
FROM Employees e
LEFT JOIN Employee_Projects ep
    ON e.employee_id = ep.employee_id
GROUP BY e.employee_id, e.employee_name;

-- 11. Project with the highest total working hours
SELECT
    p.project_name,
    SUM(ep.hours) AS total_hours
FROM Projects p
JOIN Employee_Projects ep
    ON p.project_id = ep.project_id
GROUP BY p.project_id, p.project_name
ORDER BY total_hours DESC
LIMIT 1;

-- 12. Employees with no project assignment
SELECT
    e.employee_id,
    e.employee_name
FROM Employees e
LEFT JOIN Employee_Projects ep
    ON e.employee_id = ep.employee_id
WHERE ep.employee_id IS NULL;

-- 13. Second-highest salary
SELECT MAX(salary) AS second_highest_salary
FROM Employees
WHERE salary < (
    SELECT MAX(salary)
    FROM Employees
);

-- 14. Salary difference from department average
SELECT
    e.employee_name,
    d.department_name,
    e.salary,
    ROUND(
        e.salary - AVG(e.salary) OVER (
            PARTITION BY e.department_id
        ),
        2
    ) AS difference_from_department_average
FROM Employees e
JOIN Departments d
    ON e.department_id = d.department_id;

-- 15. Previous employee salary using LAG
SELECT
    employee_name,
    salary,
    LAG(salary) OVER (
        ORDER BY salary DESC
    ) AS previous_salary
FROM Employees;

-- 16. Earliest hired employee in each department
SELECT *
FROM (
    SELECT
        e.employee_name,
        d.department_name,
        e.hire_date,
        ROW_NUMBER() OVER (
            PARTITION BY e.department_id
            ORDER BY e.hire_date
        ) AS hire_rank
    FROM Employees e
    JOIN Departments d
        ON e.department_id = d.department_id
) ranked
WHERE hire_rank = 1;

-- 17. Departments with more than 2 employees
SELECT
    d.department_name,
    COUNT(e.employee_id) AS employee_count
FROM Departments d
JOIN Employees e
    ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
HAVING COUNT(e.employee_id) > 2;

-- 18. Total salary expenditure by department
SELECT
    d.department_name,
    SUM(e.salary) AS total_salary
FROM Departments d
JOIN Employees e
    ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
ORDER BY total_salary DESC;

-- 19. Employees who work on more than one project
SELECT
    e.employee_name,
    COUNT(DISTINCT ep.project_id) AS project_count
FROM Employees e
JOIN Employee_Projects ep
    ON e.employee_id = ep.employee_id
GROUP BY e.employee_id, e.employee_name
HAVING COUNT(DISTINCT ep.project_id) > 1;

-- 20. Department salary ranking
WITH department_salary AS (
    SELECT
        d.department_name,
        AVG(e.salary) AS average_salary
    FROM Departments d
    JOIN Employees e
        ON d.department_id = e.department_id
    GROUP BY d.department_id, d.department_name
)
SELECT
    department_name,
    average_salary,
    RANK() OVER (
        ORDER BY average_salary DESC
    ) AS department_rank
FROM department_salary;
