/*
  Phase 2 — Inventory all modules (procedures, functions, triggers, views)
  Instance: localhost\SQLEXPRESS
*/
USE AdventureWorks2022;
GO

SELECT
    s.name AS schema_name,
    o.name AS object_name,
    o.type_desc,
    o.create_date,
    o.modify_date,
    CASE
        WHEN m.execute_as_principal_id = -2 THEN 'EXECUTE AS OWNER'
        WHEN m.execute_as_principal_id IS NULL THEN 'EXECUTE AS CALLER'
        ELSE USER_NAME(m.execute_as_principal_id)
    END AS execute_as_mode,
    CASE WHEN m.definition IS NULL THEN 'ENCRYPTED' ELSE 'VISIBLE' END AS code_visibility
FROM sys.sql_modules m
JOIN sys.objects o ON m.object_id = o.object_id
JOIN sys.schemas s ON o.schema_id = s.schema_id
WHERE o.type IN ('P','FN','IF','TF','TR','V')
ORDER BY o.type_desc, s.name, o.name;
GO
