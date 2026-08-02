/*
  Phase 6 — Detective controls (SQL Server Audit inventory)
*/
USE master;
GO

SELECT * FROM sys.dm_server_audit_status;
GO

SELECT a.name AS audit_name, s.name AS spec_name,
       d.audit_action_name, s.is_state_enabled
FROM sys.server_audits a
JOIN sys.server_audit_specifications s ON a.audit_guid = s.audit_guid
JOIN sys.server_audit_specification_details d
     ON s.server_specification_id = d.server_specification_id;
GO

SELECT a.name AS audit_name, s.name AS spec_name,
       d.audit_action_name, OBJECT_NAME(d.major_id) AS object_name,
       s.is_state_enabled
FROM sys.server_audits a
JOIN sys.database_audit_specifications s ON a.audit_guid = s.audit_guid
JOIN sys.database_audit_specification_details d
     ON s.database_specification_id = d.database_specification_id;
GO

USE AdventureWorks2022;
GO

SELECT a.name AS audit_name, s.name AS spec_name,
       d.audit_action_name, OBJECT_NAME(d.major_id) AS object_name,
       s.is_state_enabled
FROM sys.server_audits a
JOIN sys.database_audit_specifications s ON a.audit_guid = s.audit_guid
JOIN sys.database_audit_specification_details d
     ON s.database_specification_id = d.database_specification_id;
GO
