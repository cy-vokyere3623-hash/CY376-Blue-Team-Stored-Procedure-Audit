/*
  LAB ONLY — intentionally weak procedures for blue-team practice.
  Target: AdventureWorks2022 on localhost\SQLEXPRESS
  Do NOT deploy to production.
*/
USE AdventureWorks2022;
GO

IF OBJECT_ID('dbo.usp_LabSearchProducts_Unsafe', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_LabSearchProducts_Unsafe;
GO

-- F-001 / Critical: SQL injection via dynamic SQL concatenation
CREATE PROCEDURE dbo.usp_LabSearchProducts_Unsafe
    @ProductName NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @sql NVARCHAR(MAX);
    SET @sql = N'SELECT ProductID, Name, ProductNumber
                 FROM Production.Product
                 WHERE Name LIKE ''%' + @ProductName + N'%''';
    EXEC(@sql);  -- UNSAFE: never concatenate user input into SQL
END;
GO

IF OBJECT_ID('dbo.usp_LabGetEmployee_Elevate', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_LabGetEmployee_Elevate;
GO

-- F-002 / High: privilege escalation via EXECUTE AS OWNER
CREATE PROCEDURE dbo.usp_LabGetEmployee_Elevate
    @BusinessEntityID INT
WITH EXECUTE AS OWNER
AS
BEGIN
    SET NOCOUNT ON;
    SELECT BusinessEntityID, NationalIDNumber, JobTitle, HireDate
    FROM HumanResources.Employee
    WHERE BusinessEntityID = @BusinessEntityID;
END;
GO

IF OBJECT_ID('dbo.usp_LabRunCommand_Dangerous', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_LabRunCommand_Dangerous;
GO

-- F-003 / Critical: wraps xp_cmdshell (only works if xp_cmdshell is enabled)
CREATE PROCEDURE dbo.usp_LabRunCommand_Dangerous
    @Cmd NVARCHAR(4000)
AS
BEGIN
    SET NOCOUNT ON;
    -- Dangerous pattern — auditors should flag this
    EXEC master.dbo.xp_cmdshell @Cmd;
END;
GO

-- Grant EXECUTE to public (bad practice — CIS finding)
GRANT EXECUTE ON dbo.usp_LabSearchProducts_Unsafe TO public;
GRANT EXECUTE ON dbo.usp_LabGetEmployee_Elevate TO public;
GRANT EXECUTE ON dbo.usp_LabRunCommand_Dangerous TO public;
GO

PRINT 'Lab vulnerable procedures created in AdventureWorks2022.';
PRINT 'Run scripts\01-inventory.sql next to begin auditing.';
GO
