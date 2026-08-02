# CY376 Blue Team: Auditing Stored Procedures and Database Objects

**Student:** Veronica Okyere  
**Index Number:** FCM.41,018.206.23  
**Course:** CY376 — Network Monitoring, Security and Auditing  
**Track:** Blue Team  
**GitHub:** https://github.com/cy-vokyere3623-hash/CY376-Blue-Team-Stored-Procedure-Audit  

## Summary

This project audits Microsoft SQL Server stored procedures and database objects for security weaknesses in an isolated lab. It covers inventory, dangerous code-pattern detection, permission review, server hardening checks, SQL Server Audit, remediation, and verification.

## Tools used

- SQL Server 2022 Express (`localhost\SQLEXPRESS`)
- SQL Server Management Studio 21
- AdventureWorks2022 sample database
- Custom T-SQL audit and remediation scripts
- Windows Application Log (SQL Server Audit destination)

## Repository layout

```text
├── README.md
├── .gitignore
├── scripts/                 # Audit scripts 01–05
├── lab/                     # Vulnerable seed + remediation SQL
├── docs/                    # Working findings notes
├── evidence/screenshots/    # Insert SSMS screenshots here
├── report/                  # Full academic report (Markdown → PDF)
├── presentation/            # 10-minute slide outline
└── reports/                 # Short executive summary
```

## How to run the lab

1. Open SSMS and connect to `localhost\SQLEXPRESS` (Windows Authentication).
2. Confirm `AdventureWorks2022` is online.
3. Run `lab/setup-vulnerable-procs.sql` to create the practice weaknesses.
4. Run in order:
   - `scripts/01-inventory.sql`
   - `scripts/02-code-patterns.sql`
   - `scripts/03-permissions.sql`
   - `scripts/04-server-config.sql`
   - `scripts/05-audit-check.sql`
5. Record findings in `docs/findings-template.md`.
6. Run `lab/remediate-findings.sql`.
7. Re-run scripts `02`–`05` to verify fixes.

## Key findings (all remediated)

| ID | Severity | Issue |
|----|----------|-------|
| F-001 | Critical | SQL injection via dynamic SQL concatenation |
| F-002 | High | `EXECUTE AS OWNER` privilege escalation |
| F-003 | Critical | `xp_cmdshell` wrapper procedure |
| F-004 | High | `EXECUTE` granted to `public` |
| F-005 | Medium | SQL Server Audit missing |
| F-006 | Low | `remote access` enabled |

## Report and presentation

- Full report draft: `report/CY376-Blue-Team-Report.md`
- Convert that file to Word/PDF, insert screenshots, print for Monday submission
- Presentation outline: `presentation/10-minute-slides.md`

## Screenshots

Place cropped SSMS evidence in `evidence/screenshots/` using the checklist in `evidence/screenshots/README.md`.

## References

- CIS Microsoft SQL Server Benchmarks
- OWASP SQL Injection Prevention Cheat Sheet
- Microsoft SQL Server Audit documentation
- NetSPI SQL Server Detective Control Cheat Sheet

## Academic integrity note

This repository contains laboratory scripts and documentation for coursework. Do not use the intentionally vulnerable procedures outside an isolated lab.
