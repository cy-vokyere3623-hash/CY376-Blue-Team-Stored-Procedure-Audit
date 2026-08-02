$ErrorActionPreference = 'Stop'
$sqlcmd = 'C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\SQLCMD.EXE'
$bak = 'C:\Cybersecurity\Blue team Broni\downloads\AdventureWorks2022.bak'
$log = 'C:\Cybersecurity\Blue team Broni\restore-aw.log'

# Default data path for Express
$dataRoot = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA'
if (-not (Test-Path $dataRoot)) {
    # Discover from instance
    $q = "SELECT SERVERPROPERTY('InstanceDefaultDataPath') AS p;"
    $dataRoot = (& $sqlcmd -S '.\SQLEXPRESS' -E -h -1 -W -Q $q).Trim()
}

$mdf = Join-Path $dataRoot 'AdventureWorks2022.mdf'
$ldf = Join-Path $dataRoot 'AdventureWorks2022_log.ldf'

$restoreSql = @"
IF DB_ID('AdventureWorks2022') IS NOT NULL
BEGIN
    PRINT 'AdventureWorks2022 already exists';
END
ELSE
BEGIN
    RESTORE DATABASE [AdventureWorks2022]
    FROM DISK = N'$bak'
    WITH MOVE N'AdventureWorks2022' TO N'$mdf',
         MOVE N'AdventureWorks2022_log' TO N'$ldf',
         REPLACE, STATS = 10;
END
SELECT name, state_desc FROM sys.databases WHERE name = 'AdventureWorks2022';
"@

$restoreSql | Set-Content 'C:\Cybersecurity\Blue team Broni\lab\restore-adventureworks.sql' -Encoding UTF8
& $sqlcmd -S '.\SQLEXPRESS' -E -i 'C:\Cybersecurity\Blue team Broni\lab\restore-adventureworks.sql' 2>&1 |
    Tee-Object -FilePath $log
