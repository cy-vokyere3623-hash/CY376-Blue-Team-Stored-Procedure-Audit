/*
  Phase 4 — Permission audit (public role + object grants)
*/
USE AdventureWorks2022;
GO

-- Permissions on public role
SELECT
    DB_NAME() AS database_name,
    dp.class_desc,
    OBJECT_NAME(dp.major_id) AS object_name,
    dp.permission_name,
    dp.state_desc
FROM sys.database_permissions dp
WHERE dp.grantee_principal_id = DATABASE_PRINCIPAL_ID('public')
ORDER BY object_name, permission_name;
GO

-- EXECUTE grants on lab / risky procedures
SELECT
    OBJECT_SCHEMA_NAME(major_id) AS schema_name,
    OBJECT_NAME(major_id) AS object_name,
    USER_NAME(grantee_principal_id) AS grantee,
    permission_name,
    state_desc
FROM sys.database_permissions
WHERE permission_name = 'EXECUTE'
  AND (
       OBJECT_NAME(major_id) LIKE 'usp_Lab%'
    OR OBJECT_NAME(major_id) LIKE 'xp_%'
    OR OBJECT_NAME(major_id) LIKE 'sp_OA%'
  )
ORDER BY object_name, grantee;
GO
