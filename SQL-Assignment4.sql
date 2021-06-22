/*

-What is View? What are the benefits of using views?
 Views in SQL are kind of virtual tables. A view also has rows and columns as they are in a real table in the database.
 We can create a view by selecting fields from one or more tables present in the database. 
 A View can either have all the rows of a table or specific rows based on certain condition. It acts like a table,
 so most things you'd do with a table will work with a view. if you're doing user level access control, you can give 
 a user access to a view without giving them access to the tables behind it. It allows you to keep the logic centralized,
 rather than repeating it in your code. It can allow for massive performance improvements

-Can data be modified through views?
 You can insert, update, and delete rows in a view. If the view contains joins between multiple tables, you can only insert
 and update one table in the view, and you can't delete rows. You can't directly modify data in views based on union queries.
 You can't modify data in views that use GROUP BY or DISTINCT statements. All columns being modified are subject to the same
 restrictions as if the statements were being executed directly against the base table. Text and image columns can't be modified
 through views. There is no checking of view criteria. 

-What is stored procedure and what are the benefits of using it?
	A stored procedure is a prepared SQL code that you can save, so the code can be reused over and over again.

-What is the difference between view and stored procedure?
 View is simple showcasing data stored in the database tables whereas a stored procedure is a group of statements that can be executed.

-What is the difference between stored procedure and functions?
 The function must return a value but in Stored Procedure it is optional. Even a procedure can return zero or n values. Functions can
 have only input parameters for it whereas Procedures can have input or output parameters. Functions can be called from Procedure whereas
 Procedures cannot be called from a Function.

-Can stored procedure return multiple result sets?
 Yes. Most stored procedures return multiple result sets. 

-Can stored procedure be executed as part of SELECT Statement? Why?
 you can execute a stored procedure implicitly from within a SELECT statement, provided that the stored procedure returns a result set

-What is Trigger? What types of Triggers are there?
 A trigger is a stored procedure in database which automatically invokes whenever a special event in the database occurs. There are four
 types of triggers. Ex. Data Definition Language (DDL) triggers, Data Manipulation Language (DML) triggers, CLR triggers, and Logon triggers.

-What are the scenarios to use Triggers?
 We use before triggers when we want to update any field or validate any record before they are saved to the database.After triggers are used
 when we wish to access any field values after they are saved to the database.

-What is the difference between Trigger and Stored Procedure?
 TRIGGER:Trigger executes implicitly. Whenever an event INSERT, UPDATE, and DELETE occurs it executed automatically. We cannot define a trigger
 inside another trigger.Transaction statements are not allowed in the trigger. We cannot return value in a trigger.
 STORED PROCEDURE:A Procedure executed explicitly when the user using statements such as exec, EXECUTE, etc.We can define procedures inside another
 procedure. Also, we can use functions inside the stored procedure.Transaction statements such as COMMIT, ROLLBACK, and SAVEPOINT are allowed in
 the procedure.Stored procedures return a zero or N value. However, we can pass values as parameters. Return keyword used to exitthe procedure

*/

USE Northwind

/*
-A new region called “Middle Earth”;

insert into dbo.Region values(5, 'Middle Earth');

-A new territory called “Gondor”, belongs to region “Middle Earth”;

insert into dbo.Territories values(2, 'Gondor', 5);

-A new employee “Aragorn King” who's territory is “Gondor”.

insert into dbo.Employees values(10, 'Aragorn', 'King', 'Sales', 'Mr.', '1993-02-28','2019-10-27','Santa Clara,'CA','CA',95051,'USA','(202)6022029');
insert into dbo.EmployeeTerritories values(10, 2);

-Change territory “Gondor” to “Arnor”.

UPDATE dbo.Territories
SET TerritoryDescription = Arnor
WHERE TerritoryDescription = Gondor

-Delete Region “Middle Earth”. (tip: remove referenced data first)
 (Caution: do not forget WHERE or you will delete everything.) In case of an error,
 no changes should be made to DB. Unlock the tables mentioned in question 1.

DELETE FROM dbo.Region WHERE RegionDescription = 'Middle Earth'

-Create a view named “view_product_order_[your_last_name]”, list all products
 and total ordered quantity for that product.

CREATE VIEW view_product_order_Chen AS
SELECT ProductID, SUM(Quantity) AS theSum
FROM dbo.[Order Details]
GROUP BY ProductID
WHERE SUM(Quantity) > 0

-Create a stored procedure “sp_product_order_quantity_[your_last_name]”
 that accept product id as an input and total quantities of order as output parameter

 CREATE PROCEDURE sp_product_order_quantity_Ling (
 @ProductID INT,
 @Quantity INT OUTPUT
 )AS
 BEGIN
	SELECT
		@Quantity = SUM(Quantity) 
	FROM
		dbo.[Order Details]
	WHERE ProductID = @ProductID
	GROUP BY ProductID
  END


-Create a stored procedure “sp_product_order_city_[your_last_name]” 
 that accept product name as an input and top 5 cities that ordered most
 that product combined with the total quantity of that product ordered from that city as output.

 CREATE PROCEDURE sp_product_order_city_Ling (
 @ProductName varchar(50)
 
 )AS
 BEGIN
	SELECT  O.ShipCity,  @ProductName = P.ProductName, SUM(OD.Quantity) FROM dbo.Products P
		JOIN dbo.[Order Details] OD ON P.ProductID = OD.ProductID
		JOIN dbo.Orders O ON O.OrderID = OD.OrderID
	WHERE P.ProductName = @theProductName 
	GROUP BY O.ShipCity
  END


-Lock tables Region, Territories, EmployeeTerritories and Employees. Create a stored procedure 
 “sp_move_employees_[your_last_name]” that automatically find all employees in territory “Tory”;
 if more than 0 found, insert a new territory “Stevens Point” of region “North” to the database,
 and then move those employees to “Stevens Point”.

 CREATE PROCEDURE sp_move_employees_Ling() 
 AS
 BEGIN

	UPDATE dbo.Territories
	SET TerritoryDescription = 'Stevens Point'
	WHERE TerritoryID IN
	(
		SELECT TerritoryID FROM dbo.Employees E
		JOIN dbo.EmployeeTerritories ET ON E.EmployeesID = ET.EmployeesID
		WHERE EmployeeTerritories = 'Tory' 
	)
  END


-Create a trigger that when there are more than 100 employees in territory “Stevens Point”,
 move them back to Troy. (After test your code,) remove the trigger. Move those employees
 back to “Troy”, if any. Unlock the tables.


 -Create 2 new tables “people_your_last_name” “city_your_last_name”. City table has two records:
 {Id:1, City: Seattle}, {Id:2, City: Green Bay}. People has three records: 
 {id:1, Name: Aaron Rodgers, City: 2}, {id:2, Name: Russell Wilson, City:1}, {Id: 3, Name: Jody Nelson, City:2}.
 Remove city of Seattle. If there was anyone from Seattle, put them into a new city “Madison”. 
 Create a view “Packers_your_name” lists all people from Green Bay. If any error occurred, 
 no changes should be made to DB. (after test) Drop both tables and view.

 CREATE TABLE city_Ling (ID int, City varchar(255));
 CREATE TABLE people_Ling (ID int, Name varchar(255), CityID int);

 INSERT INTO city_Ling VALUES (1, Seattle);
 INSERT INTO city_Ling VALUES (2, Green Bay);

 INSERT INTO people_Ling VALUES (1, Aaron Rodgers Bay, 2);
 INSERT INTO people_Ling VALUES (2, Russell Wilson, 1);
 INSERT INTO people_Ling VALUES (3, Jody Nelson, 2);

 DELETE FROM city_Ling WHERE City = 'Seattle'

 INSERT INTO city_Ling VALUES(3, 'Madison')

 UPDATE people_Ling
 SET CityID = 3;
 WHERE CityID = 1;


-Create a stored procedure “sp_birthday_employees_[you_last_name]” that creates a new table 
 “birthday_employees_your_last_name” and fill it with all employees that have a birthday on Feb.
 (Make a screen shot) drop the table. Employee table should not be affected.

 CREATE PROCEDURE sp_birthday_employees_Chen ()
   BEGIN

      CREATE TABLE birthday_employees_Chen AS
      SELECT * FROM dbo.Employees
	  WHERE Month(BirthDate) = 2
	  
   END;

 
-Create a stored procedure named “sp_your_last_name_1” that returns all cites that have at least 2 customers
 who have bought no or only one kind of product. Create a stored procedure named “sp_your_last_name_2”
 that returns the same but using a different approach.(sub-query and no-sub-query).

 CREATE PROCEDURE sp_Chen_1() 
 AS
 BEGIN

  SELECT O.ShipCity FROM dbo.Orders O
	WHERE O.OrderID IN
	(
		SELECT OrderID FROM dbo.[Order Details] OD
		GROUP BY OrderID
		HAVING COUNT(*) < 2
	)
	GROUP BY O.ShipCity
	HAVING COUNT(O.CustomerID) > 2

  END



-Create a stored procedure named “sp_your_last_name_2” that returns the same but using a different
 approach. (sub-query and no-sub-query).


-14.

SELECT Concat(Ifnull(FirstName,' ') ,' ', Ifnull(Lastname,' '),' ', Ifnull(MiddleName + '.',' ')) AS 'Full Name' FROM TableName;

-15.

SELECT Student, MAX(Marks) FROM Student
WHERE Sex = 'F'
LIMIT 1

-16.

SELECT * FROM Student
ORDER BY Marks, Sex


*/




