Return;

USE UC; -- Comments can be included on lines with syntax

/*************Data Preparation****************/

/*Adding a unique column in the data */

ALTER TABLE CarSales
ADD CarID INT IDENTITY;

/*Change the header name Pct to PercentShare*/
  
EXEC sp_rename 'CarSales.Pct', 'PercentShare';  
  

/* Check for duplicate lines*/

SELECT *
FROM (  SELECT *
				, ROW_NUMBER () OVER (PARTITION BY CarID ORDER BY CarID) AS RowNumber
	FROM CarSales) AS DupRow
WHERE DupRow.RowNumber > 1;


/*************Data Statistics****************/

/* To compute total row count */

SELECT * FROM CarSales
SELECT @@ROWCOUNT AS Row_Count

/* To identify top 3 cars sold */

SELECT TOP 3 Make, Model, Sum(Quantity) as Quantity
FROM CarSales
GROUP BY Make, Model
ORDER BY Sum(Quantity) DESC;

/* To identify month with maximum sales*/

SELECT TOP 1 Month, Sum(Quantity) as Quantity
FROM CarSales
GROUP BY Month
ORDER BY Sum(Quantity) DESC;

/* To identify year and month with maximum, minimum and average sales*/

SELECT TOP 1 year, month, Sum(Quantity) as Quantity
FROM CarSales
GROUP BY year, month
ORDER BY Sum(Quantity) DESC;

/* To identify maximum, minimum and average sales for each make*/

SELECT Top 5 make, max(Quantity) as Maximum_sales, min(Quantity) as Minimum_sales, avg(Quantity) as Average_sales
FROM CarSales
GROUP BY make
ORDER BY avg(Quantity) desc


/* To identify maximum, minimum and average sales for each make*/

SELECT year, model, count(model) as count_car
FROM CarSales
GROUP BY year,model
ORDER BY count(model) desc

/* To identify year, make, model for top 5 make*/

SELECT top 5 year, make, model, count(make) as count_car
FROM CarSales
GROUP BY year,make, model
ORDER BY count(make) desc;

/* To identify top 3 cars having highest PercentShare */

SELECT TOP 3 Make, Model, Sum(PercentShare) as PercentShare
FROM CarSales
GROUP BY Make, Model
ORDER BY Sum(PercentShare) DESC;


/* Average number of cars sold in which model?*/

 SELECT TOP 3 Make, Model, sum(Quantity) as Tot_Quantity
FROM CarSales
GROUP BY Make, Model
ORDER BY sum(Quantity);

/* Brand that has sold more number of cars*/

SELECT TOP 5 Sum(Quantity) as Count, Make
FROM CarSales
Group by Make
Order by Sum(Quantity);

/*****************Data Normalization*************/


IF OBJECT_ID('dbo.Make', 'U') IS NOT NULL DROP TABLE dbo.Make; 


CREATE TABLE dbo.Make (
	MakeID INT IDENTITY Primary Key NOT NULL,
	Make VARCHAR(100)
	);
 
INSERT INTO dbo.Make (Make)
SELECT DISTINCT Make FROM CarSales;


IF OBJECT_ID('dbo.Model', 'U') IS NOT NULL DROP TABLE dbo.Model; 

CREATE TABLE dbo.Model (
	ModelID INT IDENTITY Primary Key NOT NULL,
	Model VARCHAR(100)
	);
 
INSERT INTO dbo.Model (Model)
SELECT DISTINCT Model FROM CarSales;


IF OBJECT_ID('dbo.Manufacture','U') IS NOT NULL DROP TABLE dbo.Manufacture;

SELECT DISTINCT IDENTITY(INT,1,1)  ManufactureID
		, MakeID
		, ModelID
		, CarID
 INTO dbo.Manufacture
FROM dbo.CarSales CS
INNER JOIN dbo.Make K on CS.Make = K.Make
INNER JOIN dbo.Model D on CS.Model = D.Model ;


SELECT  CS.CarID,  CS.Year, CS.Month, K.Make AS  Make, D.Model as Model,CS.Quantity,CS.PercentShare
FROM Manufacture M
INNER JOIN dbo.Make K ON M.MakeID = K.MakeID
INNER JOIN dbo.Model D on M.ModelID = D.ModelID
INNER JOIN dbo.CarSales CS on CS.CarID = M.CarID;
