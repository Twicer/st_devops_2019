USE MASTER
GO

CREATE CERTIFICATE Security_Certificate 
FROM FILE = 'C:\Temp\security_certificate.cer'
WITH PRIVATE KEY ( 
    FILE = 'C:\Temp\security_certificate.key' ,   
    DECRYPTION BY PASSWORD = 'CertPa$$w0rd'
);

USE Master ;
Open Master Key Decryption by password = 'Pa$$w0rd'
Backup master key to file = 'C:\Temp\Master_Key_2.key'
        ENCRYPTION BY PASSWORD = 'Pa$$w0rd';
GO

Use master 
    restore master key
    FROM FILE = 'C:\Temp\Master_Key_2.key'
    DECRYPTION BY PASSWORD = 'Pa$$w0rd'
    ENCRYPTION BY PASSWORD = 'Pa$$w0rd'

USE MASTER
OPEN MASTER KEY DECRYPTION BY PASSWORD = 'Pa$$w0rd';


RESTORE DATABASE [user_db] FROM DISK = 'C:\Temp\user_db_FULLEncrtypted.bak' 
WITH RECOVERY, 
	MOVE 'AdventureWorksLT2008_Data' TO 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLNAMED\MSSQL\user_db_data.mdf',   
	MOVE 'AdventureWorksLT2008_Log' TO 'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLNAMED\MSSQL\user_db_log.ldf';   


