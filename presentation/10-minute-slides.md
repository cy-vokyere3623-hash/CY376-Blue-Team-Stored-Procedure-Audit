# 10-Minute Presentation Outline
## CY376 Blue Team — Veronica Okyere (FCM.41,018.206.23)

**Title:** Auditing Stored Procedures and Database Objects for Security Weaknesses  
**Time limit:** 10 minutes (practice with a timer)

---

### Slide 1 — Problem / Objective (≈45 sec)
- Databases store high-value data
- Stored procedures can hide SQL injection, privilege escalation, and OS command risks
- **Goal:** Blue-team audit → document → remediate → verify on SQL Server lab

### Slide 2 — Lab Setup (≈60 sec)
- SQL Server 2022 Express (`localhost\SQLEXPRESS`)
- SSMS + AdventureWorks2022
- Isolated lab only (no real external targets)
- Show topology diagram (Figure 1 from report)

### Slide 3 — Methodology (≈60 sec)
Five stages:
1. Prepare environment
2. Seed vulnerable procedures
3. Detect with audit scripts
4. Document findings
5. Remediate and re-verify

### Slide 4 — What I Built (≈60 sec)
- `lab/setup-vulnerable-procs.sql`
- Audit suite `scripts/01`–`05`
- `lab/remediate-findings.sql`
- SQL Server Audit: `BlueTeamLabAudit`

### Slide 5 — Findings (Critical/High) (≈90 sec)
Show screenshot evidence:
- F-001 SQL injection (dynamic SQL)
- F-002 `EXECUTE AS OWNER`
- F-003 `xp_cmdshell` wrapper
- F-004 `public` execute grants

### Slide 6 — Findings (Medium/Low) + Positives (≈60 sec)
- F-005 missing audit
- F-006 remote access
- Already good: xp_cmdshell/OLE/CLR off, sa disabled

### Slide 7 — Remediation & Verification (≈90 sec)
- Replaced/removed unsafe procs
- Revoked public execute
- Enabled SQL Server Audit
- `remote access = 0 | 0`
- Re-run scripts → 0 risky rows

### Slide 8 — Recommendations & Close (≈45 sec)
- Parameterize / avoid unsafe dynamic SQL
- Least privilege; no sensitive public grants
- Keep dangerous features disabled
- Continuous audit + scheduled re-checks
- Thank you / questions

---

## Demo backup plan
If live SSMS fails:
1. Show screenshots from `evidence/screenshots/`
2. Open `report/CY376-Blue-Team-Report.md` tables
3. Walk through `lab/remediate-findings.sql` in the repo

## Likely interview questions (prepare answers)
- Why are stored procedures not automatically safe?
- What does `EXECUTE AS OWNER` risk?
- Why is granting EXECUTE to `public` bad?
- How did you verify remediation?
- Which CIS/OWASP controls guided you?
- What would you monitor in a real SIEM next?
