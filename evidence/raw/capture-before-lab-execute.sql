/*
  BEFORE remediation evidence — public EXECUTE on lab procedures
*/
USE AdventureWorks2022;
GO

SELECT
    OBJECT_SCHEMA_NAME(major_id) AS schema_name,
    OBJECT_NAME(major_id) AS object_name,
    USER_NAME(grantee_principal_id) AS grantee,
    permission_name,
    state_desc
FROM sys.database_permissions
WHERE permission_name = 'EXECUTE'
  AND OBJECT_NAME(major_id) LIKE 'usp_Lab%'
ORDER BY object_name, grantee;
GO
