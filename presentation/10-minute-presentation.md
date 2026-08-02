# CY376 Presentation â€” 10 Minutes

**Student:** Veronica Okyere (`FCM.41.018.206.23`)  
**Topic:** Blue Team â€” Auditing Stored Procedures and Database Objects for Security Weaknesses  
**Repo:** https://github.com/cy-vokyere3623-hash/CY376-Blue-Team-Stored-Procedure-Audit

## Slide plan (keep to 10 minutes)

| # | Slide | Speak for | What to show |
|---|-------|-----------|--------------|
| 1 | Problem / objective | 1 min | Topic title, Blue Team goal |
| 2 | Lab setup | 1 min | `localhost\SQLEXPRESS`, AdventureWorks2022, Figure 1â€“2 |
| 3 | Methodology | 1 min | Inventory â†’ detect â†’ document â†’ remediate â†’ verify |
| 4 | Finding: SQL injection + xp_cmdshell | 1.5 min | Figures 7 / F-001 / F-003 |
| 5 | Finding: EXECUTE AS OWNER + public grants | 1.5 min | Figures 4, 8 / F-002 / F-004 |
| 6 | Remediation + verification | 2 min | Figures 5, 9, 10, 11 |
| 7 | Recommendations | 1 min | Least privilege, parameterized SQL, audit |
| 8 | Close | 1 min | All 6 findings fixed; Q&A ready |

## Suggested talking points

### Slide 1 â€” Objective
> This project audited stored procedures and database objects from a blue-team perspective to find weaknesses before attackers exploit them.

### Slide 2 â€” Setup
> I used SQL Server 2022 Express, SSMS, and AdventureWorks2022 in an isolated lab. I created intentionally vulnerable procedures for practice.

### Slide 3 â€” Method
> I ran five audit scripts for inventory, dangerous code patterns, permissions, CIS surface area, and SQL Server Audit status.

### Slides 4â€“5 â€” Results
> I found six issues: SQL injection via dynamic SQL, EXECUTE AS OWNER elevation, an xp_cmdshell wrapper, public execute grants, missing audit, and remote access enabled.

### Slide 6 â€” Fix and proof
> I remediated with `remediate-findings.sql`, then re-ran the scripts. Dangerous patterns returned zero rows, audit was started, and remote access was disabled.

### Slide 7 â€” Recommendations
> Use parameterized SQL, avoid EXECUTE AS OWNER, never grant EXECUTE to public on sensitive procs, keep xp_cmdshell off, and enable SQL Server Audit.

### Slide 8 â€” Close
> All six findings were fixed and verified. Scripts, evidence, and the full report are in the GitHub repository.

## Interview readiness checklist

Be able to explain:

- Why stored procedures are not automatically safe (OWASP)
- What `EXECUTE AS OWNER` does
- Why `public` EXECUTE is dangerous
- What `BlueTeamLabAudit` monitors
- Difference between before and after screenshots
- Every script in `scripts/` and `lab/`

## Timing tip

Practice once with a timer. If a live demo fails, switch immediately to screenshots in `evidence/screenshots/`.

