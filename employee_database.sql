CREATE DATABASE employee_analysis;

USE employee_analysis;

-- Departments table
CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50)
);

-- Employees table
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    department_id INT,
    manager_id INT,
    salary DECIMAL(10,2),
    hire_date DATE,
    FOREIGN KEY (department_id)
        REFERENCES Departments(department_id)
);

-- Projects table
CREATE TABLE Projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100),
    department_id INT,
    FOREIGN KEY (department_id)
        REFERENCES Departments(department_id)
);

-- Employee Projects table
CREATE TABLE Employee_Projects (
    employee_id INT,
    project_id INT,
    hours INT,
    PRIMARY KEY (employee_id, project_id),
    FOREIGN KEY (employee_id)
        REFERENCES Employees(employee_id),
    FOREIGN KEY (project_id)
        REFERENCES Projects(project_id)
);

-- Insert Departments
INSERT INTO Departments
VALUES
(10, 'IT'),
(20, 'HR'),
(30, 'Finance');

-- Insert Employees
INSERT INTO Employees
VALUES
(1, 'Amit', 10, NULL, 75000, '2020-01-15'),
(2, 'Rahul', 20, 1, 55000, '2021-03-10'),
(3, 'Priya', 10, 1, 85000, '2019-07-20'),
(4, 'Sneha', 30, 2, 45000, '2022-05-15'),
(5, 'Arjun', 20, 1, 65000, '2020-11-01'),
(6, 'Neha', 30, 2, 50000, '2021-09-12'),
(7, 'Kiran', 10, 3, 90000, '2018-06-18'),
(8, 'Anjali', 20, 5, 60000, '2023-01-10');

-- Insert Projects
INSERT INTO Projects
VALUES
(101, 'Website', 10),
(102, 'Payroll', 20),
(103, 'Audit', 30),
(104, 'Mobile App', 10);

-- Insert Employee Projects
INSERT INTO Employee_Projects
VALUES
(1, 101, 120),
(2, 102, 100),
(3, 101, 150),
(3, 104, 80),
(4, 103, 90),
(5, 102, 130),
(6, 103, 110),
(7, 104, 160),
(8, 102, 70);
