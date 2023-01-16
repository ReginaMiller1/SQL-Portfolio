/****** Script for SelectTopNRows command from SSMS  ******/
SELECT*
  FROM PortfolioProject..EmployeeDemographics

  --Inserting information into a preexisting table.
  Insert into PortfolioProject..EmployeeDemographics VALUES
(1001, 'Jim', 'Halpert', 30, 'Male'),
(1002, 'Pam', 'Beasley', 30, 'Female'),
(1003, 'Dwight', 'Schrute', 29, 'Male'),
(1004, 'Angela', 'Martin', 31, 'Female'),
(1005, 'Toby', 'Flenderson', 32, 'Male'),
(1006, 'Michael', 'Scott', 35, 'Male'),
(1007, 'Meredith', 'Palmer', 32, 'Female'),
(1008, 'Stanley', 'Hudson', 38, 'Male'),
(1009, 'Kevin', 'Malone', 31, 'Male')

--Selecting all employees over the age of 30.
SELECT*
  FROM PortfolioProject..EmployeeDemographics
  WHERE Age > 30

  --Finding all employees that are in need of a raise after the company raised the minimum salary.
 SELECT EmployeeDemographics.EmployeeID,FirstName,LastName,JobTitle,Salary
   FROM PortfolioProject..EmployeeSalary
   FULL Outer JOIN  PortfolioProject..EmployeeDemographics
		 ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
	Where Salary < '46000'

--Finding the average salary of salesmen.
SELECT JobTitle, AVG(Salary)
	FROM PortfolioProject..EmployeeSalary 
	WHERE JobTitle = 'Salesman'
	Group By JobTitle

--Claculationg the yearly raises of all employees acording to their contibution to higher than average sales, based on their job titles.
 SELECT FirstName, LastName, JobTitle, Salary,
	CASE
		WHEN JobTitle = 'Salesman' THEN Salary + (Salary * .10)
		WHEN JobTitle = 'Acountant' THEN Salary + (Salary * .05)
		WHEN JobTitle = 'HR' THEN Salary + (Salary * .000001)
		ELSE Salary + (Salary * .03)
	END AS SalaryAfterRaise
   FROM PortfolioProject..EmployeeSalary
   Join  PortfolioProject..EmployeeDemographics
		 ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID

--Finding the positions that have an averaage salary over $45,000.
SELECT JobTitle, AVG (Salary)
   FROM PortfolioProject..EmployeeSalary
   JOIN  PortfolioProject..EmployeeDemographics
	 ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
	GROUP BY JobTitle
	HAVING AVG(Salary) > 45000
	ORDER BY AVG(Salary)

--Adding an employees missing information into the table.
UPDATE PortfolioProject..EmployeeDemographics
SET EmployeeID = 1012, Age = 31, Gender = 'Female'
WHERE FirstName = 'Holly' AND LastName = 'Flax'

--Removing an employee after they resigned.
DELETE FROM PortfolioProject..EmployeeDemographics
WHERE EmployeeID = 1005

--Organizing data from three difrent tables so that it is easy to understand if a person other than the creater were to look at it.
SELECT Demo.EmployeeID, Demo.FirstName, Demo.LastName, Sal.JobTitle, Ware.Gender
  FROM PortfolioProject..EmployeeDemographics AS Demo
  LEFT JOIN PortfolioProject..EmployeeSalary AS Sal
   On Demo.EmployeeID = Sal.EmployeeID
	LEFT JOIN PortfolioProject..WareHouseEmployeeDemographics AS Ware
	ON Demo.EmployeeID = Ware.EmployeeID

--Createing a CTE to pull information from as if it where a pre-existing table.
WITH CTE_Employee as
(SELECT FirstName, LastName, Gender, Salary,
COUNT(Gender) Over (PARTITION BY Gender) as TotalGender,
AVG(Salary) Over (PARTITION BY Gender) as AvgSalary
From PortfolioProject..EmployeeDemographics as Demo
Join PortfolioProject..EmployeeSalary as Sal
	On Demo.EmployeeID = Sal.EmployeeID
WHERE Salary > '45000')
SELECT FirstName, LastName, AvgSalary
FROM CTE_Employee

--Creating a temp table to pull information out of a consitant query without having to continually rewrite the query.
CREATE TABLE #TempEmployee
(JobTitle varchar(50), 
EmployeesPerJob int, 
AvgAge int, 
AvgSalary int)

INSERT INTO #TempEmployee
SELECT JobTitle, COUNT(Jobtitle), AVG(Age), AVG(Salary)
FROM PortfolioProject..EmployeeDemographics AS Demo
JOIN PortfolioProject..EmployeeSalary AS Sal
	ON Demo.EmployeeID = Sal.EmployeeID
GROUP BY JobTitle

SELECT *
FROM #TempEmployee



CREATE TABLE EmployeeErrors (
EmployeeID varchar(50)
,FirstName varchar(50)
,LastName varchar(50)
)

Insert into EmployeeErrors Values 
('1001  ', 'Jimbo', 'Halbert')
,('  1002', 'Pamela', 'Beasely')
,('1005', 'TOby', 'Flenderson - Fired')

Select *
From EmployeeErrors

-- Using Trim, LTRIM, RTRIM
SELECT EmployeeID, TRIM(EmployeeID) as IDTRIM
FROM EmployeeErrors

SELECT EmployeeID, LTRIM(EmployeeID) as IDTRIM
FROM EmployeeErrors

SELECT EmployeeID, RTRIM(EmployeeID) as IDTRIM
FROM EmployeeErrors

--Using Replace
SELECT LastName, REPLACE(LastName, ' - Fired', '') AS LastNameFixed
FROM EmployeeErrors