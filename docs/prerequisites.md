# Blue Team Lab — Prerequisites

## Status on this machine: READY

| Component | Status | Details |
|-----------|--------|---------|
| SQL Server 2022 Express | Ready | `localhost\SQLEXPRESS` |
| SSMS 21 | Ready | v21.6.17 |
| AdventureWorks2022 | Online | 71 tables |
| AdventureWorksLT2022.bak | Downloaded | `lab\backups\` |
| Lab vulnerable procs | Deployed | `usp_Lab*` |
| Audit scripts | Ready | `scripts\` |
| Portable sqlcmd | Ready | `tools\sqlcmd\sqlcmd.exe` |

## Connect

- Server: `localhost\SQLEXPRESS` or `.\SQLEXPRESS`
- Authentication: Windows Authentication

## Verify from PowerShell

```powershell
& "C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\SQLCMD.EXE" `
  -S "localhost\SQLEXPRESS" -E `
  -Q "SELECT name, state_desc FROM sys.databases;"
```

## Start auditing

1. Open SSMS and connect
2. Run `lab\setup-vulnerable-procs.sql` only if you need to recreate lab procs
3. Run `scripts\01-inventory.sql` through `05-audit-check.sql`
4. Record findings in `docs\findings-template.md`

## Official sources used

- [Microsoft AdventureWorks samples](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure)
- [go-sqlcmd releases](https://github.com/microsoft/go-sqlcmd/releases)
- [CIS SQL Server Benchmarks](https://www.cisecurity.org/benchmark/microsoft_sql_server)
