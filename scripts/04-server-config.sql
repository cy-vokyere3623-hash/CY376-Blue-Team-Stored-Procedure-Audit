/*
  Phase 5 — Server-level surface area (CIS §2)
*/
USE master;
GO

SELECT name, value, value_in_use
FROM sys.configurations
WHERE name IN (
    'xp_cmdshell',
    'Ole Automation Procedures',
    'clr enabled',
    'clr strict security',
    'Ad Hoc Distributed Queries',
    'external scripts enabled',
    'remote access',
    'scan for startup procs'
)
ORDER BY name;
GO

-- Who is sysadmin?
SELECT p.name AS login_name, p.type_desc, p.is_disabled
FROM sys.server_role_members rm
JOIN sys.server_principals p ON rm.member_principal_id = p.principal_id
JOIN sys.server_principals r ON rm.role_principal_id = r.principal_id
WHERE r.name = 'sysadmin'
ORDER BY p.name;
GO
