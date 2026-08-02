# CY376: Network Monitoring, Security and Auditing
## End-of-Semester Project Report

---

### Cover Page

**Student Name:** Veronica Okyere  
**Index Number:** FCM.41,018.206.23  
**Topic Title:** Blue Team — Auditing Stored Procedures and Database Objects for Security Weaknesses  
**Track:** Blue Team  
**Course Code:** CY376  
**Institution / Programme:** As indicated on course registration  
**Date:** August 2026  

**GitHub Repository:**  
https://github.com/cy-vokyere3623-hash/CY376-Blue-Team-Stored-Procedure-Audit  

*(Update this URL if your final repository name differs after creation on GitHub.)*

---

## Abstract

Databases remain a high-value target because they store customer records, credentials, and business-critical data. Even when network controls are present, weak stored procedures, excessive permissions, and missing audit logging can allow attackers to steal data or escalate privileges from inside the database engine. This Blue Team project investigated how to audit Microsoft SQL Server stored procedures and related database objects for security weaknesses in an isolated laboratory environment.

The laboratory used SQL Server 2022 Express, SQL Server Management Studio (SSMS), and the Microsoft AdventureWorks2022 sample database. Intentionally vulnerable stored procedures were created to simulate common weaknesses: SQL injection through unsafe dynamic SQL, privilege escalation through `EXECUTE AS OWNER`, operating-system command execution via an `xp_cmdshell` wrapper, and excessive `EXECUTE` grants to the `public` role. A structured audit methodology was then applied using catalog views and custom Transact-SQL (T-SQL) scripts aligned with CIS Microsoft SQL Server Benchmark recommendations, OWASP SQL Injection Prevention guidance, Microsoft SQL Server Audit documentation, and NetSPI detective-control practices.

Six findings were identified and severity-rated. Remediation removed or replaced unsafe procedures, revoked public execute rights, enabled SQL Server Audit, and disabled the `remote access` configuration option. Re-running the same audit scripts verified that the critical and high risks were eliminated and that detective controls were active. The project demonstrates a complete blue-team workflow: inventory, detection, documentation, remediation, and verification.

---

## Table of Contents

1. Introduction  
2. Literature and Tooling Review  
3. Methodology  
4. Implementation  
5. Results and Findings  
6. Analysis and Recommendations  
7. Conclusion  
8. References  
9. Appendices  

*(Insert page numbers when converting this Markdown file to Word/PDF.)*

---

## 1. Introduction

### 1.1 Background

Blue team work focuses on defending systems by identifying weaknesses, improving controls, and ensuring that suspicious activity can be detected. In database environments, defenders must look beyond firewalls and host antivirus. Stored procedures, views, functions, triggers, and permission grants form part of the application’s trust boundary. A single unsafe procedure that concatenates user input into dynamic SQL can enable SQL injection even if the front-end application appears to use parameters. Likewise, a procedure marked `EXECUTE AS OWNER` can allow a low-privilege caller to act with the owner’s rights. Extended procedures such as `xp_cmdshell` can bridge the database engine to the operating system, creating a path from SQL access to host compromise.

### 1.2 Problem statement

Many organizations assume that “using stored procedures” is automatically secure. Industry guidance contradicts that assumption. OWASP notes that stored procedures are safe only when implemented without unsafe dynamic SQL. CIS Benchmarks for SQL Server recommend reducing surface area (for example disabling `xp_cmdshell`) and limiting privileges granted to the `public` role. Without a repeatable audit process, these weaknesses remain invisible until an incident occurs.

### 1.3 Project aim and objectives

**Aim:** To audit stored procedures and database objects in a SQL Server laboratory for security weaknesses and to remediate and verify the identified issues using blue-team methods.

**Objectives:**

1. Deploy an isolated SQL Server lab with a sample database suitable for auditing.  
2. Establish intentionally vulnerable stored procedures that represent realistic weaknesses.  
3. Inventory database modules and inspect definitions for dangerous patterns.  
4. Review object permissions and server configuration against CIS-aligned expectations.  
5. Assess whether SQL Server Audit detective controls are present.  
6. Document findings with severity ratings and evidence.  
7. Remediate the findings and re-verify with the same audit scripts.  
8. Produce a report, repository, and presentation suitable for academic assessment.

### 1.4 Scope and limitations

The scope was limited to a local SQL Server 2022 Express instance (`localhost\SQLEXPRESS`) and the AdventureWorks2022 database. No production systems or unauthorized third-party targets were tested. Limitations include Express edition feature constraints, the use of simulated vulnerable procedures rather than a live enterprise application, and the absence of a full enterprise SIEM correlation stack. These limitations are appropriate for a controlled academic blue-team exercise.

---

## 2. Literature and Tooling Review

### 2.1 CIS Microsoft SQL Server Benchmarks

The Center for Internet Security (CIS) publishes consensus benchmarks for Microsoft SQL Server. Relevant themes for this project include surface-area reduction (disabling unnecessary features such as `xp_cmdshell` and OLE Automation), least privilege (restricting grants to `public`), and auditing/logging expectations. The project used CIS recommendations as the primary hardening checklist for server configuration and permission review (Center for Internet Security, n.d.).

### 2.2 OWASP SQL Injection Prevention

The OWASP SQL Injection Prevention Cheat Sheet explains that stored procedures are not inherently immune to injection. Auditors should look for dynamic execution constructs such as `EXEC`, `EXECUTE`, and `sp_executesql` when user input is concatenated into SQL strings. The preferred defenses are parameterized queries and safely implemented procedures (OWASP Foundation, n.d.). Finding F-001 in this project maps directly to that guidance.

### 2.3 Microsoft SQL Server Audit and catalog views

Microsoft documentation describes catalog views such as `sys.sql_modules` for retrieving module definitions and SQL Server Audit for logging security-relevant events. Audit action groups and database-level execute auditing provide detective controls for dangerous procedures and configuration changes (Microsoft, n.d.-a; Microsoft, n.d.-b). Finding F-005 addressed the absence of these controls in the initial lab state.

### 2.4 NetSPI detective controls for SQL Server

NetSPI’s SQL Server Detective Control Cheat Sheet provides practical patterns for auditing execution of high-risk procedures (for example `xp_cmdshell`, OLE automation, external scripts) and for monitoring configuration changes. These patterns informed the design of the project’s audit verification and remediation audit specifications (NetSPI, n.d.).

### 2.5 Tools used

| Tool | Role in the project |
|------|---------------------|
| SQL Server 2022 Express | Database engine under audit |
| SQL Server Management Studio 21 | Interactive query and administration |
| AdventureWorks2022 | Sample OLTP database (Microsoft samples) |
| Custom T-SQL audit scripts | Inventory, pattern hunt, permissions, config, audit checks |
| Windows Application Log | Destination for SQL Server Audit events |
| Git / GitHub | Version control and submission artifact |

---

## 3. Methodology

### 3.1 Laboratory design

The laboratory was hosted on a local Windows machine. SQL Server Express ran as the named instance `SQLEXPRESS`. Authentication for administrative auditing used Windows Authentication. AdventureWorks2022 provided realistic schema objects (tables, procedures, views) without exposing real personal data.

**Figure 1.** Conceptual lab topology

```text
[ Auditor Workstation ]
          |
          | Windows Auth / SSMS / sqlcmd
          v
[ SQL Server 2022 Express : localhost\SQLEXPRESS ]
          |
          +-- System DBs: master, msdb, model, tempdb
          +-- User DB: AdventureWorks2022
                |
                +-- Lab vulnerable / safe stored procedures
                +-- Database audit specification
          |
          +-- Server Audit: BlueTeamLabAudit --> Windows Application Log
```

*(When printing, replace this ASCII diagram with a clean Visio/PowerPoint diagram labeled “Figure 1. Laboratory topology for the blue-team SQL Server audit.”)*

### 3.2 Ethical and safety controls

All testing remained inside an instructor-appropriate isolated lab. No unauthorized external systems were scanned or exploited. Vulnerable procedures were labeled as lab-only and were not intended for production use.

### 3.3 Audit workflow

The methodology followed five stages:

1. **Prepare** — install engine and tools; restore AdventureWorks2022.  
2. **Seed** — deploy intentionally weak procedures to create measurable findings.  
3. **Detect** — run inventory and security audit scripts; capture outputs.  
4. **Document** — record findings with severity, evidence, and references.  
5. **Remediate and verify** — apply fixes; re-run detection scripts; update status.

### 3.4 Severity model

| Severity | Meaning |
|----------|---------|
| Critical | Clear path to data theft via injection or OS command execution |
| High | Privilege escalation or broadly excessive execute rights |
| Medium | Missing detective controls that delay incident response |
| Low | Unnecessary surface area with limited immediate impact |

---

## 4. Implementation

### 4.1 Environment preparation

SQL Server 2022 Express and SSMS 21 were installed and verified. AdventureWorks2022 was restored and confirmed online (71 base tables and multiple existing procedures). Project folders were organized as `scripts`, `lab`, `docs`, `evidence`, `report`, and `presentation`.

### 4.2 Intentionally vulnerable procedures

Three procedures were created in AdventureWorks2022 (`lab/setup-vulnerable-procs.sql`):

1. **`dbo.usp_LabSearchProducts_Unsafe`** — builds a SQL string by concatenating `@ProductName` and executes it with `EXEC(@sql)`. This models classic second-order / procedure-level SQL injection risk.  
2. **`dbo.usp_LabGetEmployee_Elevate`** — defined `WITH EXECUTE AS OWNER`, allowing callers to inherit owner privileges when reading employee data.  
3. **`dbo.usp_LabRunCommand_Dangerous`** — wraps `master.dbo.xp_cmdshell`, representing an OS command-execution bridge.

All three were granted `EXECUTE` to `public`, violating least privilege and simulating a common misconfiguration.

### 4.3 Audit script suite

| Script | Purpose |
|--------|---------|
| `scripts/01-inventory.sql` | List modules, execute-as mode, encryption/visibility |
| `scripts/02-code-patterns.sql` | Search definitions for dangerous patterns; list elevated procedures |
| `scripts/03-permissions.sql` | Review `public` grants and execute rights on risky objects |
| `scripts/04-server-config.sql` | Check CIS-relevant configuration options and `sysadmin` membership |
| `scripts/05-audit-check.sql` | Inventory server audits and audit specifications |

These scripts query catalog views such as `sys.sql_modules`, `sys.objects`, `sys.database_permissions`, `sys.configurations`, and SQL Server Audit catalog/DMV views.

### 4.4 Remediation implementation

Remediation was applied with `lab/remediate-findings.sql`:

- Replaced the unsafe search procedure with `dbo.usp_LabSearchProducts_Safe` using static parameterized filtering (no `EXEC(@sql)` concatenation).  
- Replaced the elevated employee procedure with `dbo.usp_LabGetEmployee_Safe` running as caller.  
- Dropped the `xp_cmdshell` wrapper entirely (no safe equivalent retained).  
- Revoked `EXECUTE` from `public` on the safe replacements.  
- Created and enabled server audit `BlueTeamLabAudit` writing to the Windows Application log, with server and database audit specifications.  
- Set `remote access` to `0` and confirmed runtime value after service restart.

### 4.5 Configuration excerpts

**Unsafe pattern (pre-remediation):**

```sql
SET @sql = N'SELECT ... WHERE Name LIKE ''%' + @ProductName + N'%''';
EXEC(@sql);
```

**Safer replacement (post-remediation):**

```sql
SELECT ProductID, Name, ProductNumber
FROM Production.Product
WHERE Name LIKE N'%' + @ProductName + N'%';
```

**Audit creation (excerpt):**

```sql
CREATE SERVER AUDIT BlueTeamLabAudit
TO APPLICATION_LOG
WITH (QUEUE_DELAY = 1000, ON_FAILURE = CONTINUE);
ALTER SERVER AUDIT BlueTeamLabAudit WITH (STATE = ON);
```

---

## 5. Results and Findings

### 5.1 Summary of findings

**Table 1.** Findings identified during the stored procedure and database object audit

| ID | Severity | Category | Object | Status after remediation |
|----|----------|----------|--------|--------------------------|
| F-001 | Critical | SQL Injection | `dbo.usp_LabSearchProducts_Unsafe` | Fixed |
| F-002 | High | Privilege Escalation | `dbo.usp_LabGetEmployee_Elevate` | Fixed |
| F-003 | Critical | Dangerous Feature | `dbo.usp_LabRunCommand_Dangerous` | Fixed |
| F-004 | High | Excessive Permissions | Lab procedures / `public` | Fixed |
| F-005 | Medium | Missing Detective Controls | SQL Server Audit | Fixed |
| F-006 | Low | Surface Area | `remote access` | Fixed |

### 5.2 Detection evidence (pre-remediation)

**Figure 2.** Dangerous code-pattern results  
*(Insert screenshot of `02-code-patterns.sql` showing `usp_LabSearchProducts_Unsafe` and `usp_LabRunCommand_Dangerous`, plus `EXECUTE AS OWNER` for `usp_LabGetEmployee_Elevate`. Caption: “Figure 2. Pre-remediation output of the dangerous code-pattern audit.”)*

Before remediation, script `02-code-patterns.sql` returned the unsafe and dangerous procedures and identified the elevated execute-as procedure. Script `03-permissions.sql` showed `EXECUTE` granted to `public` on all three lab procedures. Script `05-audit-check.sql` initially returned no configured audits.

### 5.3 Finding narratives

**F-001 (Critical) — SQL injection risk.**  
User-controlled input was concatenated into a dynamic SQL string and executed. An attacker supplying crafted input could alter query logic. This violates OWASP safe stored-procedure guidance.

**F-002 (High) — Privilege escalation.**  
`EXECUTE AS OWNER` caused the procedure to run with owner rights regardless of the caller’s privileges. Combined with public execute rights, this expanded the blast radius of a compromised low-privilege account.

**F-003 (Critical) — OS command bridge.**  
Wrapping `xp_cmdshell` creates a reusable command-execution interface. Even though `xp_cmdshell` was disabled at the server level during parts of testing, the presence of such a wrapper is a high-risk code smell and a future enablement hazard.

**F-004 (High) — Public execute grants.**  
Granting execute on sensitive procedures to `public` means every database principal inherits the right. CIS guidance emphasizes minimizing `public` permissions.

**F-005 (Medium) — No SQL Server Audit.**  
Without audit specifications, defenders lack reliable telemetry for configuration changes and sensitive procedure execution.

**F-006 (Low) — Remote access enabled.**  
The `remote access` option increases unnecessary surface area for legacy remote procedure scenarios and was disabled per hardening practice.

### 5.4 Positive controls observed

Even before remediation of the lab procedures, several CIS-aligned controls were already in a good state:

- `xp_cmdshell` disabled  
- OLE Automation Procedures disabled  
- CLR disabled  
- Ad Hoc Distributed Queries disabled  
- `sa` login disabled  

### 5.5 Post-remediation verification

**Figure 3.** Post-remediation code-pattern check  
*(Insert screenshot of `02-code-patterns.sql` returning 0 risky rows. Caption: “Figure 3. Verification that dangerous stored-procedure patterns were removed.”)*

**Figure 4.** Server configuration after hardening  
*(Insert screenshot showing `remote access | 0 | 0`. Caption: “Figure 4. Confirmation that remote access is disabled at runtime.”)*

**Figure 5.** SQL Server Audit status  
*(Insert screenshot of `BlueTeamLabAudit` with status STARTED and enabled specifications. Caption: “Figure 5. Detective controls enabled via SQL Server Audit.”)*

After remediation:

- Dangerous code-pattern query: **0 rows**  
- Elevated execute-as procedures: **0 rows**  
- Risky lab `public` execute grants: **0 rows**  
- Audit `BlueTeamLabAudit`: **STARTED**  
- `remote access`: **value = 0, value_in_use = 0**

**Table 2.** Verification matrix

| Control area | Pre-remediation | Post-remediation |
|--------------|-----------------|------------------|
| Unsafe dynamic SQL lab proc | Present | Removed / replaced |
| EXECUTE AS OWNER lab proc | Present | Removed / replaced |
| xp_cmdshell wrapper | Present | Removed |
| Public execute on lab procs | Granted | Revoked |
| SQL Server Audit | Absent | Enabled |
| remote access | Enabled at runtime | Disabled |

---

## 6. Analysis and Recommendations

### 6.1 What the results mean

The exercise shows that blue-team database auditing must combine **code review**, **permission review**, and **configuration review**. Focusing on only one layer leaves gaps. For example, disabling `xp_cmdshell` is necessary but insufficient if application code still contains wrappers and if execute rights are overly broad. Similarly, replacing unsafe procedures without enabling audit leaves defenders blind to future regressions.

### 6.2 Recommendations for operational environments

1. **Ban unsafe dynamic SQL patterns** in code review and automated scanning of `sys.sql_modules`.  
2. **Avoid `EXECUTE AS OWNER`** unless a documented least-privilege impersonation account is required.  
3. **Keep `xp_cmdshell`, OLE Automation, and Ad Hoc Distributed Queries disabled** unless a formal exception exists.  
4. **Never grant sensitive execute rights to `public`**; use application roles instead.  
5. **Enable SQL Server Audit** (or equivalent) for configuration changes and high-risk object execution; forward events to a SIEM.  
6. **Re-run audit scripts on a schedule** and after every schema release.  
7. **Treat remediation as incomplete until verification scripts pass.**

### 6.3 Mapping to defensive value

| Finding class | Attacker opportunity if ignored | Blue-team value of fix |
|---------------|----------------------------------|------------------------|
| Injection in procedures | Data exfiltration / tampering | Removes a common database foothold |
| EXECUTE AS OWNER | Privilege escalation | Restores least privilege |
| xp_cmdshell wrappers | Host command execution | Cuts DB-to-OS bridge |
| Public execute | Wide abuse by any DB user | Shrinks attack surface |
| Missing audit | Stealthy changes | Improves detection & forensics |

---

## 7. Conclusion

This Blue Team project delivered a practical audit of stored procedures and database objects on SQL Server 2022 Express using AdventureWorks2022. By seeding realistic weaknesses, applying CIS- and OWASP-informed detection scripts, documenting six findings, remediating them, and verifying the results, the project completed the full defensive lifecycle expected in network monitoring, security, and auditing coursework.

The key lesson is that database security is not only about login passwords. Procedure code quality, permission design, surface-area configuration, and detective auditing together determine whether a database can resist and reveal abuse. The same methodology can be extended to linked servers, SQL Agent jobs, encryption settings, and continuous CIS benchmark compliance scanning.

All findings identified in the laboratory were remediated and verified. The accompanying GitHub repository contains the scripts, documentation, and report materials required for independent review.

---

## 8. References

Center for Internet Security. (n.d.). *CIS Microsoft SQL Server benchmarks*. https://www.cisecurity.org/benchmark/microsoft_sql_server

Microsoft. (n.d.-a). *sys.sql_modules (Transact-SQL)*. Microsoft Learn. https://learn.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-sql-modules-transact-sql

Microsoft. (n.d.-b). *SQL Server audit action groups and actions*. Microsoft Learn. https://learn.microsoft.com/en-us/sql/relational-databases/security/auditing/sql-server-audit-action-groups-and-actions

Microsoft. (n.d.-c). *AdventureWorks sample databases*. Microsoft Learn. https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure

NetSPI. (n.d.). *SQL Server detective control cheat sheet*. PowerUpSQL Wiki. https://github.com/NetSPI/PowerUpSQL/wiki/SQL-Server-Detective-Control-Cheat-Sheet

OWASP Foundation. (n.d.). *SQL injection prevention cheat sheet*. OWASP Cheat Sheet Series. https://cheatsheetseries.owasp.org/cheatsheets/SQL_Injection_Prevention_Cheat_Sheet.html

Portcullis Labs. (n.d.). *MS SQL Server audit: Extended stored procedures / table privileges*. https://labs.portcullis.co.uk/blog/ms-sql-server-audit-extended-stored-procedures-table-privileges/

---

## 9. Appendices

### Appendix A — Audit script list

- `scripts/01-inventory.sql`  
- `scripts/02-code-patterns.sql`  
- `scripts/03-permissions.sql`  
- `scripts/04-server-config.sql`  
- `scripts/05-audit-check.sql`  

### Appendix B — Lab procedure scripts

- `lab/setup-vulnerable-procs.sql` (pre-remediation seed)  
- `lab/remediate-findings.sql` (fixes and audit enablement)  

### Appendix C — Findings working sheet

See `docs/findings-template.md` in the repository for the working findings table used during the audit.

### Appendix D — Screenshot checklist for printing

Before producing the final PDF, insert cropped screenshots into Section 5 for Figures 2–5 and replace Figure 1 with a drawn topology diagram. Ensure each figure has a number, caption, and in-text reference.

### Appendix E — How to reproduce the laboratory

1. Install SQL Server 2022 Express and SSMS.  
2. Restore AdventureWorks2022.  
3. Run `lab/setup-vulnerable-procs.sql`.  
4. Run scripts `01`–`05` and record findings.  
5. Run `lab/remediate-findings.sql`.  
6. Re-run scripts `02`–`05` to verify.  

---

**End of report draft**

**Student declaration:** This submission reflects laboratory work completed for CY376 on an isolated SQL Server environment. External standards and tools are cited. No unauthorized systems were tested.
