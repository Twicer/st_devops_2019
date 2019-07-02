$instanceName = 'mssqlfromfile'
$cred = Get-Credential Administrator
$credSa =  Get-Credential sa

$fromDataPath = 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\AdventureWorksLT2012_Data'
$fromLogPath = 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\AdventureWorksLT2012_Log'
$destPath = 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLFROMFILE\MSSQL\DATA\'


Invoke-Sqlcmd -ServerInstance vm1 -Credential $credSa -Query`
 "USE user_db;
 GO
 EXEC sp_detach_db 'user_db', 'true'"

 Copy-Item -Path $fromDataPath -Destination $destPath
 Copy-Item -Path $fromLogPath -Destination $destPath

 Invoke-Sqlcmd -ServerInstance $instanceName -Credential $credSa -Query`
 "
 -- Creating a DMK in the master DB
USE master;
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Pa$$w0rd';

-- Creating a Certificate in the master DB
CREATE CERTIFICATE Security_Certificate FROM FILE = 'C:\Temp\security_certificate.cer'
WITH PRIVATE KEY
(FILE = 'C:\Temp\security_certificate.key',
ENCRYPTION BY PASSWORD = 'CertPa$$w0rd');

-- Creating Database
CREATE DATABASE user_db   
    ON (FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLFROMFILE\MSSQL\DATA\AdventureWorksLT2012_Data.mdf'),   
    (FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLFROMFILE\MSSQL\DATA\AdventureWorksLT2012_Log.ldf')   
    FOR ATTACH;
 "