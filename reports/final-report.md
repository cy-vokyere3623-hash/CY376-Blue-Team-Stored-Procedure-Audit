# Blue Team Database Security Audit Report

**Project:** Auditing Stored Procedures and Database Objects for Security Weaknesses  
**Instance:** `localhost\SQLEXPRESS` (SQL Server 2022 Express)  
**Database:** `AdventureWorks2022`  
**Date:** 2026-07-16  
**Auditor:** Blue team lab

---

## 1. Scope

This project audited stored procedures and related database objects in a SQL Server lab environment. The goal was to identify security weaknesses commonly found in stored procedures, permissions, and database configuration, then remediate and verify the fixes.

## 2. What Was Audited

- Stored procedures, functions, triggers, and views
- Dynamic SQL and SQL injection risks
- `EXECUTE AS OWNER` privilege escalation
- Dangerous features such as `xp_cmdshell`
- `public` role execute permissions
- SQL Server Audit configuration
- Server configuration options such as `remote access`

Audit scripts used:

- `scripts\01-inventory.sql`
- `scripts\02-code-patterns.sql`
- `scripts\03-permissions.sql`
- `scripts\04-server-config.sql`
- `scripts\05-audit-check.sql`

## 3. Findings by Severity

### Critical

| ID | Finding | Object |
|----|---------|--------|
| F-001 | SQL injection via dynamic SQL string concatenation | `dbo.usp_LabSearchProducts_Unsafe` |
| F-003 | Dangerous `xp_cmdshell` wrapper procedure | `dbo.usp_LabRunCommand_Dangerous` |

### High

| ID | Finding | Object |
|----|---------|--------|
| F-002 | Privilege escalation via `EXECUTE AS OWNER` | `dbo.usp_LabGetEmployee_Elevate` |
| F-004 | `EXECUTE` granted to `public` on lab procedures | `usp_Lab*` |

### Medium

| ID | Finding | Object |
|----|---------|--------|
| F-005 | No SQL Server Audit configured | SQL Server Audit |

### Low

| ID | Finding | Object |
|----|---------|--------|
| F-006 | `remote access` was enabled | Server configuration |

## 4. What Was Fixed

Remediation was applied using `lab\remediate-findings.sql`.

| ID | Action Taken | Verification |
|----|--------------|--------------|
| F-001 | Dropped unsafe procedure; created `dbo.usp_LabSearchProducts_Safe` | `02-code-patterns.sql` returned 0 risky code rows |
| F-002 | Dropped elevated procedure; created `dbo.usp_LabGetEmployee_Safe` without `EXECUTE AS` | No elevated procedures found |
| F-003 | Dropped `xp_cmdshell` wrapper; no replacement created | No `xp_cmdshell` usage found |
| F-004 | Removed `public` execute grants on lab procedures | `03-permissions.sql` returned 0 risky execute grants |
| F-005 | Created and started `BlueTeamLabAudit` with server and database audit specs | Audit status = STARTED |
| F-006 | Disabled `remote access` and confirmed runtime value after service restart | `remote access \| 0 \| 0` |

## 5. Positive Controls Observed

- `xp_cmdshell` disabled
- OLE Automation Procedures disabled
- CLR disabled
- Ad Hoc Distributed Queries disabled
- `sa` login disabled

## 6. Remaining Open Items

No open findings remain.

## 7. Conclusion

The audit identified six security weaknesses related to stored procedures, permissions, auditing, and server configuration. All findings were remediated and re-verified with the original audit scripts. This completed the beginner blue-team workflow: inventory, detect, document, remediate, and verify.

## References

- [CIS Microsoft SQL Server Benchmarks](https://www.cisecurity.org/benchmark/microsoft_sql_server)
- [OWASP SQL Injection Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html)
- [Microsoft SQL Server Audit](https://learn.microsoft.com/en-us/sql/relational-databases/security/auditing/sql-server-audit-action-groups-and-actions)
- [NetSPI SQL Server Detective Control Cheat Sheet](https://github.com/NetSPI/PowerUpSQL/wiki/SQL-Server-Detective-Control-Cheat-Sheet)
