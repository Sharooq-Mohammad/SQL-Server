
select name, database_id, create_date
from sys.databases;

CREATE DATABASE mydb;

DROP DATABASE IF EXISTS db;

EXEC sp_databases;

use mydb;

CREATE SCHEMA customer_services;

DROP SCHEMA customer_services;
GO

select * from 
sys.schemas

CREATE TABLE customer_services.jobs(
    job_id INT PRIMARY KEY IDENTITY,
    customer_id INT NOT NULL,
    description VARCHAR(200),
    created_at DATETIME NOT NULL
);

CREATE TABLE dbo.offices
(
    office_id      INT
    PRIMARY KEY IDENTITY, 
    office_name    NVARCHAR(40) NOT NULL, 
    office_address NVARCHAR(255) NOT NULL, 
    phone          VARCHAR(20),
);

INSERT INTO 
    dbo.offices(office_name, office_address)
VALUES
    ('Silicon Valley','400 North 1st Street, San Jose, CA 95130'),
    ('Sacramento','1070 River Dr., Sacramento, CA 95820');

CREATE PROC usp_get_office_by_id(
    @id INT
) AS
BEGIN
    SELECT 
        * 
    FROM 
        dbo.offices
    WHERE 
        office_id = @id;
END;

EXEC usp_get_office_by_id 2; -- press ctrl + k and ctrl + c  | ctrl + k and ctrl + u

DROP SCHEMA sales;
drop table sales.offices;

CREATE SCHEMA sales;

ALTER SCHEMA sales TRANSFER OBJECT::dbo.offices; 

EXEC usp_get_office_by_id 2;

ALTER PROC usp_get_office_by_id(
    @id INT
) AS
BEGIN
    SELECT 
        * 
    FROM 
        sales.offices
    WHERE 
        office_id = @id;
END;

EXEC usp_get_office_by_id 2;

USE data;

SELECT * FROM production.brands;

SELECT
  * 
FROM
  OPENJSON(
    '{"name": "John", "age": 25, "skills" : ["SQL Server","C#", ".NET"], "address":null, "active": true, "phone": {"work": "(408)-123-4567", "home": "(408)-789-1234"}}'
  ) 
ORDER BY
  type;

SELECT
value
FROM
OPENJSON(
'["SQL Server","C#", ".NET"]'
) 
ORDER BY
type;

USE mydb;

SELECT
    1 customer_id,
    'John' first_name,
    'Smith' last_name
WHERE
    EXISTS(SELECT 2);


use data;

select name from sys.databases;

select * from production.brands;

SELECT 
  JSON_QUERY(
    '{"name": "Tablet", "spec": {"weight": "1.07 pounds", "display": "10.2-inch", "bands": [1, 2, 3, 4, 5, 7, 8, 11, 12, 13, 14, 17, 18, 19, 20, 21, 25, 26, 29, 30, 34, 38, 39, 40, 41, 66, 71]}}', 
    '$.spec'
  ) AS spec;

SELECT
	JSON_VALUE(
	'{"name": "Tablet", "spec": {"weight": "1.07 pounds", "display": "10.2-inch", "bands": [1, 2, 3, 4, 5, 7, 8, 11, 12, 13, 14, 17, 18, 19, 20, 21, 25, 26, 29, 30, 34, 38, 39, 40, 41, 66, 71]}}', 
    '$.name'
  ) AS spec;

SELECT
  * 
FROM
  OPENJSON(
    '{"name": "John", "age": 25, "skills" : ["SQL Server","C#", ".NET"], "address":null, "active": true, "phone": {"work": "(408)-123-4567", "home": "(408)-789-1234"}}',
	'$.skills'
  ) 


select CURRENT_TIMESTAMP, GETDATE(), SYSDATETIME(), GETUTCDATE(), SYSUTCDATETIME(), SYSDATETIMEOFFSET();

DECLARE @dt DATETIME2= '2020-10-02 10:20:30.1234567 +08:10';

SELECT 'year,yyy,yy' date_part, 
    DATENAME(year, @dt) result
UNION
SELECT 'quarter, qq, q', 
    DATENAME(quarter, @dt)
UNION
SELECT 'month, mm, m', 
    DATENAME(month, @dt)
UNION
SELECT 'dayofyear, dy, y', 
    DATENAME(dayofyear, @dt)
UNION
SELECT 'day, dd, d', 
    DATENAME(day, @dt)
UNION
SELECT 'week, wk, ww', 
    DATENAME(week, @dt)
UNION
SELECT 'weekday, dw, w', 
    DATENAME(weekday, @dt)
UNION
SELECT 'hour, hh' date_part, 
    DATENAME(hour, @dt)
UNION
SELECT 'minute, mi,n', 
    DATENAME(minute, @dt)
UNION
SELECT 'second, ss, s', 
    DATENAME(second, @dt)
UNION
SELECT 'millisecond, ms', 
    DATENAME(millisecond, @dt)
UNION
SELECT 'microsecond, mcs', 
    DATENAME(microsecond, @dt)
UNION
SELECT 'nanosecond, ns', 
    DATENAME(nanosecond, @dt)
UNION
SELECT 'TZoffset, tz', 
    DATENAME(tz, @dt)
UNION
SELECT 'ISO_WEEK, ISOWK, ISOWW', 
    DATENAME(ISO_WEEK, @dt);

DECLARE 
    @start_dt DATETIME2= '2019-12-31 23:59:59.9999999', 
    @end_dt DATETIME2= '2020-01-01 00:00:00.0000000';

SELECT 
    DATEDIFF(year, @start_dt, @end_dt) diff_in_year, 
    DATEDIFF(quarter, @start_dt, @end_dt) diff_in_quarter, 
    DATEDIFF(month, @start_dt, @end_dt) diff_in_month, 
    DATEDIFF(dayofyear, @start_dt, @end_dt) diff_in_dayofyear, 
    DATEDIFF(day, @start_dt, @end_dt) diff_in_day, 
    DATEDIFF(week, @start_dt, @end_dt) diff_in_week, 
    DATEDIFF(hour, @start_dt, @end_dt) diff_in_hour, 
    DATEDIFF(minute, @start_dt, @end_dt) diff_in_minute, 
    DATEDIFF(second, @start_dt, @end_dt) diff_in_second, 
    DATEDIFF(millisecond, @start_dt, @end_dt) diff_in_millisecond;

use [mydb];

select * from [dbo].[entries];

exec sp_rename '[dbo].[dbo.entries2]', 'entries';

CREATE PROC usp_list_views(
	@schema_name AS VARCHAR(MAX)  = NULL,
	@view_name AS VARCHAR(MAX) = NULL
)
AS
SELECT 
	OBJECT_SCHEMA_NAME(v.object_id) schema_name,
	v.name view_name
FROM 
	sys.views as v
WHERE 
	(@schema_name IS NULL OR 
	OBJECT_SCHEMA_NAME(v.object_id) LIKE '%' + @schema_name + '%') AND
	(@view_name IS NULL OR
	v.name LIKE '%' + @view_name + '%');

create view entries_view
as
select * from dbo.entries;

exec sp_helptext 'entries_view';

select OBJECT_DEFINITION(object_id('entries_view'));

CREATE TABLE production.parts(
    part_id   INT NOT NULL, 
    part_name VARCHAR(100)
);
INSERT INTO 
    production.parts(part_id, part_name)
VALUES
    (1,'Frame'),
    (2,'Head Tube'),
    (3,'Handlebar Grip'),
    (4,'Shock Absorber'),
    (5,'Fork');

SELECT 
    part_id, 
    part_name
FROM 
    production.parts
WHERE 
    part_id = 5;

CREATE CLUSTERED INDEX ix_parts_id
ON production.parts (part_id);  

SELECT 
    part_id, 
    part_name
FROM 
    production.parts
WHERE 
    part_id in (4,5);

exec sp_rename 'production.parts.ix_pri_parts_id', 'ix_parts_id', 'index';

alter index ix_parts_id on production.parts
disable;

select * from production.parts;

alter index all on production.parts
rebuild;

drop index if exists ix_parts_id
on production.parts;

SET NOCOUNT ON;
SET NOCOUNT off;

set statistics io on;
set statistics io off;

select * from production.parts;

--using data database

use data;
GO 

DECLARE 
    @product_name VARCHAR(MAX), 
    @list_price   DECIMAL;

DECLARE cursor_product CURSOR
FOR SELECT 
        product_name, 
        list_price
    FROM 
        production.products;

OPEN cursor_product;

FETCH NEXT FROM cursor_product INTO 
    @product_name, 
    @list_price;

WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT @product_name + CAST(@list_price AS varchar);
        FETCH NEXT FROM cursor_product INTO 
            @product_name, 
            @list_price;
    END;

CLOSE cursor_product;

DEALLOCATE cursor_product;
GO

CREATE TABLE sales.persons
(
    person_id  INT
    PRIMARY KEY IDENTITY, 
    first_name NVARCHAR(100) NOT NULL, 
    last_name  NVARCHAR(100) NOT NULL
);

CREATE TABLE sales.deals
(
    deal_id   INT
    PRIMARY KEY IDENTITY, 
    person_id INT NOT NULL, 
    deal_note NVARCHAR(100), 
    FOREIGN KEY(person_id) REFERENCES sales.persons(person_id)
);

insert into 
    sales.persons(first_name, last_name)
values
    ('John','Doe'),
    ('Jane','Doe');

insert into 
    sales.deals(person_id, deal_note)
values
    (1,'Deal for John Doe');
GO

CREATE PROC usp_report_error
AS
    SELECT   
        ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_SEVERITY() AS ErrorSeverity  
        ,ERROR_STATE() AS ErrorState  
        ,ERROR_LINE () AS ErrorLine  
        ,ERROR_PROCEDURE() AS ErrorProcedure  
        ,ERROR_MESSAGE() AS ErrorMessage;  

CREATE PROC usp_delete_person(
    @person_id INT
) AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        -- delete the person
        DELETE FROM sales.persons 
        WHERE person_id = @person_id;
        -- if DELETE succeeds, commit the transaction
        COMMIT TRANSACTION;  
    END TRY
    BEGIN CATCH
        -- report exception
        EXEC usp_report_error;
        
        -- Test if the transaction is uncommittable.  
        IF (XACT_STATE()) = -1  
        BEGIN  
            PRINT  N'The transaction is in an uncommittable state.' +  
                    'Rolling back transaction.'  
            ROLLBACK TRANSACTION;  
        END;  
        
        -- Test if the transaction is committable.  
        IF (XACT_STATE()) = 1  
        BEGIN  
            PRINT N'The transaction is committable.' +  
                'Committing transaction.'  
            COMMIT TRANSACTION;     
        END;  
    END CATCH
END;

EXEC usp_delete_person 2;
EXEC usp_delete_person 1;
GO

DECLARE 
    @ErrorMessage  NVARCHAR(4000), 
    @ErrorSeverity INT, 
    @ErrorState    INT;

BEGIN TRY
    RAISERROR('Error occurred in the TRY block.', 17, 1);
END TRY
BEGIN CATCH
    SELECT 
        @ErrorMessage = ERROR_MESSAGE(), 
        @ErrorSeverity = ERROR_SEVERITY(), 
        @ErrorState = ERROR_STATE();

    -- return the error inside the CATCH block
    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH;
GO

--THROW 55000, 'THIS IS A DANGEROUS ERROR', 1;

CREATE TABLE t1(
    id int primary key
);

BEGIN TRY
    INSERT INTO t1(id) VALUES(1);
    --  cause error
    INSERT INTO t1(id) VALUES(1);
END TRY
BEGIN CATCH
    PRINT('Raise the caught error again');
    THROW;
END CATCH
GO


EXEC sp_executesql N'SELECT * FROM production.products';

EXEC sp_executesql
N'SELECT *
    FROM 
        production.products 
    WHERE 
        list_price> @listPrice AND
        category_id = @categoryId
    ORDER BY
        list_price DESC', 
N'@listPrice DECIMAL(10,2),
@categoryId INT'
,@listPrice = 100
,@categoryId = 1;


CREATE PROC usp_query (
    @table NVARCHAR(128)
)
AS
BEGIN

    DECLARE @sql NVARCHAR(MAX);
    -- construct SQL
    SET @sql = N'SELECT * FROM ' + @table;
    -- execute the SQL
    EXEC sp_executesql @sql;
    
END;

EXEC usp_query 'production.brands';
GO

CREATE TABLE sales.tests(id INT); 

EXEC usp_query 'production.brands;DROP TABLE sales.tests'; --passing another statement (hacking) called SQL injection

CREATE OR ALTER PROC usp_query
(
    @schema NVARCHAR(128), 
    @table  NVARCHAR(128)
)
AS
    BEGIN
        DECLARE 
            @sql NVARCHAR(MAX);
        -- construct SQL
        SET @sql = N'SELECT * FROM ' 
            + QUOTENAME(@schema) 
            + '.' 
            + QUOTENAME(@table);
        -- execute the SQL
        EXEC sp_executesql @sql;
    END;

EXEC usp_query 'production','brands';

EXEC usp_query 
        'production',
        'brands;DROP TABLE sales.tests';
GO

DECLARE @product_table TABLE (
    product_name VARCHAR(MAX) NOT NULL,
    brand_id INT NOT NULL,
    list_price DEC(11,2) NOT NULL
);

INSERT INTO @product_table
SELECT
    product_name,
    brand_id,
    list_price
FROM
    production.products
WHERE
    category_id = 1;

SELECT
    *
FROM
    @product_table;

CREATE OR ALTER FUNCTION udfSplit(
    @string VARCHAR(MAX), 
    @delimiter VARCHAR(50) = ' ')
RETURNS @parts TABLE
(    
idx INT IDENTITY PRIMARY KEY,
val VARCHAR(MAX)   
)
AS
BEGIN

DECLARE @index INT = -1;

WHILE (LEN(@string) > 0) 
BEGIN 
    SET @index = CHARINDEX(@delimiter , @string)  ;
    
    IF (@index = 0) AND (LEN(@string) > 0)  
    BEGIN  
        INSERT INTO @parts 
        VALUES (@string);
        BREAK  
    END 

    IF (@index > 1)  
    BEGIN  
        INSERT INTO @parts 
        VALUES (LEFT(@string, @index - 1));
        
        SET @string = RIGHT(@string, (LEN(@string) - @index));  
    END 
    ELSE
    SET @string = RIGHT(@string, (LEN(@string) - @index)); 
    END
RETURN
END

SELECT 
    * 
FROM 
    udfSplit('foo,bar,baz',',');

CREATE FUNCTION udfProductInYear (
    @model_year INT
)
RETURNS TABLE
AS
RETURN
    SELECT 
        product_name,
        model_year,
        list_price
    FROM
        production.products
    WHERE
        model_year = @model_year;

SELECT 
    * 
FROM 
    udfProductInYear(2017);
GO

CREATE FUNCTION sales.udf_get_discount_amount (
    @quantity INT,
    @list_price DEC(10,2),
    @discount DEC(4,2) 
)
RETURNS DEC(10,2) 
WITH SCHEMABINDING
AS 
BEGIN
    RETURN @quantity * @list_price * @discount
END

CREATE VIEW sales.discounts
WITH SCHEMABINDING
AS
SELECT
    order_id,
    SUM(sales.udf_get_discount_amount(
        quantity,
        list_price,
        discount
    )) AS discount_amount
FROM
    sales.order_items i
GROUP BY
    order_id;

DROP FUNCTION sales.udf_get_discount_amount;

--DROP VIEW sales.discounts;
GO

CREATE TABLE production.product_audits(
    change_id INT IDENTITY PRIMARY KEY,
    product_id INT NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    brand_id INT NOT NULL,
    category_id INT NOT NULL,
    model_year SMALLINT NOT NULL,
    list_price DEC(10,2) NOT NULL,
    updated_at DATETIME NOT NULL,
    operation CHAR(3) NOT NULL,
    CHECK(operation = 'INS' or operation='DEL')
);

CREATE TRIGGER production.trg_product_audit
ON production.products
AFTER INSERT, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO production.product_audits(
        product_id, 
        product_name,
        brand_id,
        category_id,
        model_year,
        list_price, 
        updated_at, 
        operation
    )
    SELECT
        i.product_id,
        product_name,
        brand_id,
        category_id,
        model_year,
        i.list_price,
        GETDATE(),
        'INS'
    FROM
        inserted i
    UNION ALL
    SELECT
        d.product_id,
        product_name,
        brand_id,
        category_id,
        model_year,
        d.list_price,
        GETDATE(),
        'DEL'
    FROM
        deleted d;
END

INSERT INTO production.products(
    product_name, 
    brand_id, 
    category_id, 
    model_year, 
    list_price
)
VALUES (
    'Test product',
    1,
    1,
    2018,
    599
);

SELECT 
    * 
FROM 
    production.product_audits;

DELETE FROM 
    production.products
WHERE 
    product_id = 322;

SELECT 
    * 
FROM 
    production.product_audits;
GO

CREATE TABLE production.brand_approvals(
    brand_id INT IDENTITY PRIMARY KEY,
    brand_name VARCHAR(255) NOT NULL
);

CREATE VIEW production.vw_brands 
AS
SELECT
    brand_name,
    'Approved' approval_status
FROM
    production.brands
UNION
SELECT
    brand_name,
    'Pending Approval' approval_status
FROM
    production.brand_approvals;

CREATE TRIGGER production.trg_vw_brands 
ON production.vw_brands
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO production.brand_approvals ( 
        brand_name
    )
    SELECT
        i.brand_name
    FROM
        inserted i
    WHERE
        i.brand_name NOT IN (
            SELECT 
                brand_name
            FROM
                production.brands
        );
END

INSERT INTO production.vw_brands(brand_name)
VALUES('Eddy Merckx');

SELECT
	brand_name,
	approval_status
FROM
	production.vw_brands;
GO

CREATE TABLE sales.members (
    member_id INT IDENTITY PRIMARY KEY,
    customer_id INT NOT NULL,
    member_level CHAR(10) NOT NULL
);

CREATE TRIGGER sales.trg_members_insert
ON sales.members
AFTER INSERT
AS
BEGIN
    PRINT 'A new member has been inserted';
END;

INSERT INTO sales.members(customer_id, member_level)
VALUES(1,'Silver');

DISABLE TRIGGER sales.trg_members_insert 
ON sales.members;

INSERT INTO sales.members(customer_id, member_level)
VALUES(2,'Gold');

CREATE TRIGGER sales.trg_members_delete
ON sales.members
AFTER DELETE
AS
BEGIN
    PRINT 'A new member has been deleted';
END;

DISABLE TRIGGER ALL ON sales.members;
--DISABLE TRIGGER ALL ON DATABASE;

ENABLE TRIGGER sales.trg_members_insert
ON sales.members;

ENABLE TRIGGER ALL ON DATABASE; 
GO

SELECT 
    definition   
FROM 
    sys.sql_modules  
WHERE 
    object_id = OBJECT_ID('sales.trg_members_delete'); 

SELECT 
    OBJECT_DEFINITION (
        OBJECT_ID(
            'sales.trg_members_delete'
        )
    ) AS trigger_definition;

EXEC sp_helptext 'sales.trg_members_delete' ;
GO

SELECT  
    name,
    is_instead_of_trigger
FROM 
    sys.triggers  
WHERE 
    type = 'TR';

DROP TRIGGER IF EXISTS sales.trg_member_insert;
GO


Create table employees (
id int primary key identity,
name varchar(30),
age tinyint,
place varchar(30)
);

alter table employees
add DOJ date;

alter table employees
drop column DOJ;

alter table employees
add DOJ date default getdate();

alter table employees
drop constraint DF__employees__DOJ__7C4F7684;

alter table employees
add constraint DF_employees default getdate() for DOJ;

insert into employees (name, age, place)
values ('Rock', 35, 'USA');

delete from employees;

