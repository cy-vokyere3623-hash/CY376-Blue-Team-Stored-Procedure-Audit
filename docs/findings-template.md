# Findings report — Stored procedure & database object security audit

| ID | Severity | Status | Category | Object | Finding | Verification | Reference |
|----|----------|--------|----------|--------|---------|--------------|-----------|
| F-001 | Critical | Fixed | SQL Injection | `dbo.usp_LabSearchProducts_Unsafe` | Dynamic SQL built with string concatenation of user input, then executed with `EXEC(@sql)` | Unsafe proc dropped; safe replacement `dbo.usp_LabSearchProducts_Safe` created; `02-code-patterns.sql` now returns 0 risky code rows | OWASP SQL Injection Prevention |
| F-002 | High | Fixed | Privilege Escalation | `dbo.usp_LabGetEmployee_Elevate` | Procedure runs as `EXECUTE AS OWNER`, so callers inherit owner privileges | Elevated proc dropped; safe replacement `dbo.usp_LabGetEmployee_Safe` created without `EXECUTE AS`; `02-code-patterns.sql` now returns 0 elevated procedures | CIS SQL Server §3 |
| F-003 | Critical | Fixed | Dangerous Feature | `dbo.usp_LabRunCommand_Dangerous` | Procedure wraps `xp_cmdshell`, enabling OS command execution if that feature is ever enabled | Dangerous proc dropped; no replacement created; `02-code-patterns.sql` no longer flags `xp_cmdshell` usage | CIS SQL Server §2 / NetSPI |
| F-004 | High | Fixed | Excessive Permissions | `usp_Lab*` procedures | `EXECUTE` granted to `public`, so every database user can run them | `03-permissions.sql` now returns 0 rows for risky lab procedure `public` execute grants | CIS SQL Server §3.8 |
| F-005 | Medium | Fixed | Missing Detective Controls | SQL Server Audit | No server audits or audit specifications configured | `BlueTeamLabAudit` is started; server audit spec enabled; AdventureWorks database audit spec enabled for the safe lab procedures | Microsoft SQL Audit / NetSPI Detective Controls |
| F-006 | Low | Fixed | Surface Area | `remote access` | Server config `remote access` was enabled (`value_in_use = 1`) | After SQL Express restart, `04-server-config.sql` confirms `remote access | 0 | 0` | CIS SQL Server §2 |

## Positive controls observed
- `xp_cmdshell` = **0** (disabled) - good
- `Ole Automation Procedures` = **0** - good
- `clr enabled` = **0** - good
- `Ad Hoc Distributed Queries` = **0** - good
- `sa` login is **disabled** - good

## Severity guide
- **Critical:** OS command path, cleartext secrets, clear SQL injection
- **High:** EXECUTE AS OWNER abuse, excessive public grants
- **Medium:** Missing SQL Audit, weak linked-server config
- **Low:** Documentation / hygiene

## Session notes
- Instance: `localhost\SQLEXPRESS` (SQL Server 2022 Express)
- Auditor: Blue team lab
- Date: 2026-07-16
- Database: `AdventureWorks2022`
- Scripts run: `01`–`05`
- Remediation script: `lab\remediate-findings.sql`
- Verification: `02-code-patterns.sql`, `03-permissions.sql`, `04-server-config.sql`, `05-audit-check.sql`
- Safe procs created: `usp_LabSearchProducts_Safe`, `usp_LabGetEmployee_Safe`
