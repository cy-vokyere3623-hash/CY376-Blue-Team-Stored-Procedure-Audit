# Blue Team: Auditing Stored Procedures and Database Objects for Security Weaknesses

**Course:** CY376 â€” Network Monitoring, Security and Auditing  
**Student:** Veronica Okyere  
**Index Number:** FCM.41.018.206.23  
**Team:** Blue Team  
**Date:** August 2026

## Summary

This project is a blue-team security audit of stored procedures and database objects on Microsoft SQL Server 2022 Express. It covers inventory, detection of dangerous code and permission patterns, documentation of findings, remediation, and verification in an isolated lab using AdventureWorks2022.

## Tools used

- Microsoft SQL Server 2022 Express (`localhost\SQLEXPRESS`)
- SQL Server Management Studio (SSMS) 21
- AdventureWorks2022 sample database
- Custom T-SQL audit and remediation scripts
- Windows PowerShell / sqlcmd

## Repository layout

```text
scripts/                 Audit scripts (01â€“05)
lab/                     Vulnerable lab setup + remediation
docs/                    Findings notes and prerequisites
evidence/screenshots/    Captioned SSMS evidence images
reports/                 Final Word report + PDF
presentation/            10-minute presentation materials
```

## How to run the lab

1. Install SQL Server Express + SSMS and restore AdventureWorks2022.
2. Connect in SSMS to `localhost\SQLEXPRESS` with Windows Authentication.
3. Run `lab/setup-vulnerable-procs.sql` to create intentionally weak lab procedures.
4. Run audit scripts in order:
   - `scripts/01-inventory.sql`
   - `scripts/02-code-patterns.sql`
   - `scripts/03-permissions.sql`
   - `scripts/04-server-config.sql`
   - `scripts/05-audit-check.sql`
5. Review findings in `docs/findings-template.md`.
6. Run `lab/remediate-findings.sql`.
7. Re-run scripts `02`â€“`05` to verify remediation.

## Key findings (all fixed)

| ID | Severity | Issue |
|----|----------|-------|
| F-001 | Critical | SQL injection via dynamic SQL concatenation |
| F-002 | High | `EXECUTE AS OWNER` privilege escalation |
| F-003 | Critical | `xp_cmdshell` wrapper procedure |
| F-004 | High | `EXECUTE` granted to `public` |
| F-005 | Medium | SQL Server Audit missing |
| F-006 | Low | `remote access` enabled |

## Report and evidence

- Final report (Word): `reports/CY376-Blue-Team-Report.docx`
- Final report (PDF): `reports/CY376-Blue-Team-Report.pdf`
- Evidence screenshots: `evidence/screenshots/`
- Screenshot index: `evidence/README.md`

## References

- [CIS Microsoft SQL Server Benchmarks](https://www.cisecurity.org/benchmark/microsoft_sql_server)
- [OWASP SQL Injection Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html)
- [Microsoft SQL Server Audit](https://learn.microsoft.com/en-us/sql/relational-databases/security/auditing/sql-server-audit-action-groups-and-actions)
- [NetSPI SQL Server Detective Control Cheat Sheet](https://github.com/NetSPI/PowerUpSQL/wiki/SQL-Server-Detective-Control-Cheat-Sheet)

## Academic integrity note

Vulnerable procedures in `lab/` are intentional training artefacts for this course lab only. Do not deploy them to production systems.

