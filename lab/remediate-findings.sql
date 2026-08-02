/*
  Remediation for Blue Team lab findings.
  Target: AdventureWorks2022 on localhost\SQLEXPRESS

  Fixes:
  - F-001: Replace unsafe dynamic SQL with parameterized static SQL.
  - F-002: Remove EXECUTE AS OWNER.
  - F-003: Remove xp_cmdshell wrapper.
  - F-004: Revoke EXECUTE from public on lab procedures.
  - F-005: Create a basic SQL Server Audit if supported by edition/config.
  - F-006: Disable remote access.
*/

USE AdventureWorks2022;
GO

IF OBJECT_ID('dbo.usp_LabSearchProducts_Unsafe', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_LabSearchProducts_Unsafe;
GO

CREATE PROCEDURE dbo.usp_LabSearchProducts_Safe
    @ProductName NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT ProductID, Name, ProductNumber
    FROM Production.Product
    WHERE Name LIKE N'%' + @ProductName + N'%';
END;
GO

IF OBJECT_ID('dbo.usp_LabGetEmployee_Elevate', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_LabGetEmployee_Elevate;
GO

CREATE PROCEDURE dbo.usp_LabGetEmployee_Safe
    @BusinessEntityID INT
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

-- No replacement is created for the command-execution wrapper.
-- It intentionally has no safe equivalent in this beginner lab.

REVOKE EXECUTE ON OBJECT::dbo.usp_LabSearchProducts_Safe FROM public;
REVOKE EXECUTE ON OBJECT::dbo.usp_LabGetEmployee_Safe FROM public;
GO

USE master;
GO

EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'remote access', 0;
RECONFIGURE;
GO

IF NOT EXISTS (SELECT 1 FROM sys.server_audits WHERE name = N'BlueTeamLabAudit')
BEGIN
    CREATE SERVER AUDIT BlueTeamLabAudit
    TO APPLICATION_LOG
    WITH (QUEUE_DELAY = 1000, ON_FAILURE = CONTINUE);
END;
GO

ALTER SERVER AUDIT BlueTeamLabAudit WITH (STATE = ON);
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.server_audit_specifications
    WHERE name = N'BlueTeamLab_ServerAuditSpec'
)
BEGIN
    CREATE SERVER AUDIT SPECIFICATION BlueTeamLab_ServerAuditSpec
    FOR SERVER AUDIT BlueTeamLabAudit
    ADD (AUDIT_CHANGE_GROUP),
    ADD (SERVER_OPERATION_GROUP)
    WITH (STATE = ON);
END;
GO

USE AdventureWorks2022;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.database_audit_specifications
    WHERE name = N'BlueTeamLab_DatabaseAuditSpec'
)
BEGIN
    CREATE DATABASE AUDIT SPECIFICATION BlueTeamLab_DatabaseAuditSpec
    FOR SERVER AUDIT BlueTeamLabAudit
    ADD (EXECUTE ON OBJECT::dbo.usp_LabSearchProducts_Safe BY public),
    ADD (EXECUTE ON OBJECT::dbo.usp_LabGetEmployee_Safe BY public)
    WITH (STATE = ON);
END;
GO

PRINT 'Remediation completed. Re-run scripts 02, 03, 04, and 05 to verify.';
GO
