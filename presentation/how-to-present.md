# How to Present — CY376 Blue Team (10 Minutes)

**Student:** Veronica Okyere (`FCM.41.018.206.23`)  
**Deck:** `presentation/CY376-Blue-Team-Presentation-FINAL.pptx`  
**Repo:** [https://github.com/cy-vokyere3623-hash/CY376-Blue-Team-Stored-Procedure-Audit](https://github.com/cy-vokyere3623-hash/CY376-Blue-Team-Stored-Procedure-Audit)

Use this file as your speaking script. The PowerPoint slides stay clean for the audience; say these points out loud.

## Timing map


| #   | Title                          | Time | Emphasize                                          |
| --- | ------------------------------ | ---- | -------------------------------------------------- |
| 1   | Title                          | 0:30 | Name, Blue Team topic, GitHub                      |
| 2   | Problem and Objective          | 1:00 | Why stored procedures can be unsafe                |
| 3   | Laboratory Setup               | 0:45 | Express, SSMS, AdventureWorks, lab-only            |
| 4   | Topology + Connection Evidence | 0:45 | Show real lab path                                 |
| 5   | Methodology                    | 1:00 | Inventory → detect → document → remediate → verify |
| 6   | Findings Overview              | 1:00 | Six findings by severity                           |
| 7   | Critical Evidence              | 1:15 | F-001 / F-003 screenshot                           |
| 8   | High Findings Evidence         | 1:15 | F-002 / F-004 screenshots                          |
| 9   | Audit Gap + Positive Controls  | 0:45 | F-005 / F-006 + good baselines                     |
| 10  | Remediation and Verification   | 1:15 | 0 rows + BlueTeamLabAudit started                  |
| 11  | Recommendations                | 0:45 | Practical blue-team controls                       |
| 12  | Conclusion / Q&A               | 0:30 | Close + invite questions                           |




## Slide-by-slide script



### Slide 1 — Title

Say: Good morning/afternoon. My name is Veronica Okyere. This Blue Team project audited stored procedures and database objects on SQL Server for security weaknesses. I will cover the problem, lab setup, method, findings with evidence, remediation, and recommendations within 10 minutes.

### Slide 2 — Problem and Objective

Explain: Blue team means defence — find weaknesses before attackers do. Stored procedures can hide SQL injection if developers concatenate input into EXEC. EXECUTE AS OWNER can escalate privileges. xp_cmdshell wrappers can lead to OS commands. My goal was a full cycle: inventory, detect, document, fix, verify. Standards used: CIS SQL Server, OWASP SQLi, Microsoft SQL Audit, NetSPI detective controls.

### Slide 3 — Laboratory Setup

Show connection if needed: `localhost\SQLEXPRESS` with Windows Authentication. AdventureWorks2022 provided tables like Production.Product and HumanResources.Employee. Vulnerable procedures were training artefacts only — never for production. This matches the submission rule: lab/simulated data throughout.

### Slide 4 — Topology and Connection Evidence

Point to topology: I sat at the auditor workstation, used SSMS, connected to SQL Express, audited AdventureWorks2022 objects, permissions, and SQL Server Audit. Connection evidence proves the lab was real and reproducible.

### Slide 5 — Methodology

Walk the six steps slowly. Mention scripts by name so interviewers know you own the work. `05-audit-check.sql` checked whether SQL Server Audit existed. Literature: CIS for surface area, OWASP for injection, Microsoft for `sys.sql_modules` and Audit, NetSPI for detective controls.

### Slide 6 — Findings Overview

Do not read every cell. Say: Six findings — two Critical, two High, one Medium, one Low. Critical means clear injection or OS command path. High means privilege and broad exposure. Medium is missing detection. Low is surface area. All marked Fixed after remediation. Next slides show evidence.

### Slide 7 — Critical Findings Evidence

Explain F-001: user input concatenated into dynamic SQL then EXEC — classic injection. F-003: wrapper around xp_cmdshell — if that feature is enabled, OS commands become possible. Even when xp_cmdshell is disabled, keeping the wrapper + public execute is dangerous. OWASP says stored procedures are only safe when implemented without unsafe dynamic SQL.

### Slide 8 — High Findings Evidence

F-002: WITH EXECUTE AS OWNER runs the procedure as the owner, so a low-privilege caller can inherit higher rights. F-004: GRANT EXECUTE TO public means every database user can run those procedures. Together, a weak procedure becomes widely reachable. CIS stresses least privilege and careful public-role grants.

### Slide 9 — Audit Gap, Surface Area, Positive Controls

Be balanced: not everything was broken. Dangerous features were already off, which is good. The gap was missing detective audit and a few object-level weaknesses we introduced for the lab. Remote access was disabled and confirmed `0|0` after service restart.

### Slide 10 — Remediation and Verification

This is the proof slide. Left: after remediation, `02-code-patterns.sql` returns zero risky rows. Right: BlueTeamLabAudit is STARTED with specifications. Mention `remediate-findings.sql`. Interview tip: explain why you re-ran the same scripts — to avoid “trust me” remediation.

### Slide 11 — Recommendations

Keep this practical. Link each recommendation to a finding: parameterized SQL → F-001; least privilege → F-002/F-004; surface area → F-003/F-006; audit → F-005. Mention CIS and OWASP as justification.

### Slide 12 — Conclusion / Q&A

Close on time. Offer to open the GitHub repo or walk through any script.

## Interview readiness

Be ready to explain:

- Why stored procedures are not automatically safe (OWASP)
- What `EXECUTE AS OWNER` does
- Why `public` EXECUTE is dangerous
- What `BlueTeamLabAudit` monitors
- Before vs after screenshots
- Every script in `scripts/` and `lab/`
- Commit history on GitHub

