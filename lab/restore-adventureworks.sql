IF DB_ID('AdventureWorks2022') IS NOT NULL
BEGIN
    PRINT 'AdventureWorks2022 already exists';
END
ELSE
BEGIN
    RESTORE DATABASE [AdventureWorks2022]
    FROM DISK = N'C:\Cybersecurity\Blue team Broni\downloads\AdventureWorks2022.bak'
    WITH MOVE N'AdventureWorks2022' TO N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\AdventureWorks2022.mdf',
         MOVE N'AdventureWorks2022_log' TO N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\AdventureWorks2022_log.ldf',
         REPLACE, STATS = 10;
END
SELECT name, state_desc FROM sys.databases WHERE name = 'AdventureWorks2022';
