# Evidence Screenshots Index

Student: Veronica Okyere  
Index: FCM.41.018.206.23  
Topic: Blue Team — Auditing Stored Procedures and Database Objects for Security Weaknesses  
Instance: `localhost\SQLEXPRESS` / Database: `AdventureWorks2022`

## Primary evidence (use these in the report)

| Figure | File | What it proves |
|------|------|----------------|
| Fig. 1 | `01-ssms-connect-localhost-SQLEXPRESS.png` | Lab connection |
| Fig. 2 | `02-setup-vulnerable-procs-success.png` | Vulnerable lab procs created |
| Fig. 3 | `03-inventory-execute-as-owner-lab-procs.png` | Inventory / EXECUTE AS OWNER |
| Fig. 4 | `10-lab-topology-diagram.png` | Lab topology diagram |
| Fig. 5 | `11-code-patterns-before-remediation.png` | Dangerous code patterns BEFORE |
| Fig. 5b | `11b-code-patterns-before-LIVE.png` | Live before capture (same findings) |
| Fig. 6 | `12-permissions-public-execute-before.png` | public EXECUTE on lab procs BEFORE |
| Fig. 6b | `12b-permissions-public-execute-before-LIVE.png` | Live before permissions capture |
| Fig. 7 | `04-remediate-findings-run.png` | Remediation executed |
| Fig. 8 | `05-code-patterns-after-0-rows.png` | Dangerous patterns AFTER = 0 rows |
| Fig. 9 | `06-permissions-public-role-audit.png` | Permission audit run |
| Fig. 10 | `07-server-config-cis-surface-area.png` | CIS surface area / remote access=0 |
| Fig. 11 | `08-sql-audit-BlueTeamLabAudit-started.png` | SQL Audit started |
| Fig. 12 | `09-findings-template-documented.png` | Findings F-001–F-006 documented |

## Raw query outputs

- `raw/12-code-patterns-before.txt`
- `raw/13-permissions-public-execute-before.txt`

## Note for report captions

For before-state figures, caption as query results captured during the audit of intentionally vulnerable lab procedures (not production systems).
