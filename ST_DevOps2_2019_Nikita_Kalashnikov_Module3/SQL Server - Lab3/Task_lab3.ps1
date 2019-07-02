# Creating users
$Password = Read-Host 'Enter password' -AsSecureString

Invoke-Sqlcmd -ServerInstance vm1 -Username sa -Password $Password -Query "
    -- Create Developer
    USE user_db;  
    GO  
    CREATE LOGIN developer_2 WITH PASSWORD = 'N19_94Kv', Default_Database = user_db
    GO
    USE user_db;
    CREATE USER developer_2 FROM LOGIN developer_2
    GO
    USE user_db;
    EXEC sp_addrolemember  @rolename =  'db_datareader', @membername =  'developer_2'
    EXEC sp_addrolemember  @rolename =  'db_datawriter', @membername =  'developer_2'

    -- Create QA
    USE user_db;  
    GO  
    CREATE LOGIN qa_user_2 WITH PASSWORD = 'N19_94Kv', Default_Database = user_db
    GO
    USE user_db;
    CREATE USER qa_user_2 FROM LOGIN qa_user_2
    GO
    USE user_db;
    EXEC sp_addrolemember @rolename =  'db_datareader', @membername =  'qa_user_2'

    -- Create Application Service
    USE user_db;  
    GO  
    CREATE LOGIN service_app_2 WITH PASSWORD = 'N19_94Kv', Default_Database = user_db
    GO
    USE user_db;
    CREATE USER service_app_2 FROM LOGIN service_app_2
    GO
    USE user_db;
    EXEC sp_addrolemember @rolename =  'db_datareader', @membername =  'service_app_2'
	EXEC sp_addrolemember @rolename = 'db_datawriter', @membername =  'service_app_2'

    -- Create Service Account 
    USE user_db;  
    GO  
    CREATE LOGIN service_acc_2 WITH PASSWORD = 'N19_94Kv', Default_Database = user_db
    GO
    USE user_db;
    CREATE USER service_acc_2 FROM LOGIN service_acc_2
    GO
    USE user_db;
    EXEC sp_addrolemember @rolename =  'db_datareader', @membername =  'service_acc_2'
    EXEC sp_addrolemember @rolename = 'db_datawriter', @membername =  'service_acc_2'
    EXEC sp_addrolemember @rolename = 'db_backupoperator', @membername =  'service_acc_2'

    -- Create backup maker 
    USE user_db;  
    GO  
    CREATE LOGIN backup_maker_2 WITH PASSWORD = 'N19_94Kv', Default_Database = user_db
    GO
    USE user_db;
    CREATE USER backup_maker_2 FROM LOGIN backup_maker_2
    GO
    USE user_db;
    EXEC sp_addrolemember  @rolename =  'db_denydatareader', @membername =  'backup_maker_2'
    EXEC sp_addrolemember  @rolename =  'db_backupoperator', @membername =  'backup_maker_2'

    -- ENCRYPTION OF DATABESE

    -- Creating a DMK in the master DB
    USE master;
    CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Pa$$w0rd';

    -- Creating a Certificate in the master DB
    CREATE CERTIFICATE Security_Certificate
    WITH SUBJECT = 'DEK_Certificate';

    -- Backing up a Certificate and its Private Key
    BACKUP CERTIFICATE Security_Certificate
    TO FILE = 'C:\Temp\security_certificate.cer'
    WITH PRIVATE KEY(
    FILE = 'C:\Temp\security_certificate.key' ,
    ENCRYPTION BY PASSWORD = 'CertPa$$w0rd'
    );

    -- Creating a Database Encryption Key
    USE user_db;
    CREATE DATABASE ENCRYPTION KEY
    WITH ALGORITHM = AES_128
    ENCRYPTION BY SERVER CERTIFICATE Security_Certificate;

    -- Enabling Encryption for a Database
    ALTER DATABASE user_db
    SET ENCRYPTION ON;

    -- Querying sys.database to Determine Encryption Status
    USE master;
    SELECT name, is_encrypted FROM sys.databases;
"

