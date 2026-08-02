# Screenshot checklist for report and presentation

Take these in SSMS. Crop tightly. Save as PNG.

| File name | What to capture |
|-----------|-----------------|
| `01-lab-connection.png` | Connected to `localhost\SQLEXPRESS`, AdventureWorks2022 visible |
| `02-vulnerable-procs.png` | Object Explorer showing lab procedures (after running setup script) |
| `03-code-patterns-before.png` | Results of `scripts/02-code-patterns.sql` before remediation |
| `04-permissions-before.png` | `public` EXECUTE grants from `scripts/03-permissions.sql` |
| `05-audit-missing-before.png` | Empty/no audit from first `05-audit-check.sql` run (if recreated) |
| `06-remediation-script.png` | Portion of `lab/remediate-findings.sql` in query window |
| `07-code-patterns-after.png` | `02-code-patterns.sql` returning 0 risky rows |
| `08-permissions-after.png` | No risky lab public EXECUTE grants |
| `09-remote-access-fixed.png` | `remote access \| 0 \| 0` from `04-server-config.sql` |
| `10-audit-started.png` | `BlueTeamLabAudit` STARTED + specs enabled |

## How to recreate “before” screenshots if already remediated

1. Run `lab/setup-vulnerable-procs.sql`
2. Capture before screenshots (`03`, `04`)
3. Run `lab/remediate-findings.sql` again
4. Capture after screenshots (`07`–`10`)
