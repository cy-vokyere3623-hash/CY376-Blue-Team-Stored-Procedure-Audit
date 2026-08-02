/*
  BEFORE remediation evidence — dangerous code patterns
*/
USE AdventureWorks2022;
GO

SELECT
    s.name AS schema_name,
    o.name AS object_name,
    o.type_desc
FROM sys.sql_modules m
JOIN sys.objects o ON m.object_id = o.object_id
JOIN sys.schemas s ON o.schema_id = s.schema_id
WHERE m.definition IS NOT NULL
  AND (
       m.definition LIKE '%EXEC(%'
    OR m.definition LIKE '%EXECUTE(%'
    OR m.definition LIKE '%sp_executesql%'
    OR m.definition LIKE '%xp_cmdshell%'
    OR m.definition LIKE '%sp_OACreate%'
    OR m.definition LIKE '%OPENROWSET%'
    OR m.definition LIKE '%OPENDATASOURCE%'
    OR m.definition LIKE '%OPENQUERY%'
    OR m.definition LIKE '%EXEC @%'
    OR m.definition LIKE '%EXECUTE @%'
  )
ORDER BY s.name, o.name;
GO

SELECT
    s.name AS schema_name,
    o.name AS procedure_name,
    CASE
        WHEN m.execute_as_principal_id = -2 THEN 'EXECUTE AS OWNER'
        ELSE USER_NAME(m.execute_as_principal_id)
    END AS execute_as_principal
FROM sys.sql_modules m
JOIN sys.objects o ON m.object_id = o.object_id
JOIN sys.schemas s ON o.schema_id = s.schema_id
WHERE o.type = 'P'
  AND m.execute_as_principal_id IS NOT NULL;
GO
