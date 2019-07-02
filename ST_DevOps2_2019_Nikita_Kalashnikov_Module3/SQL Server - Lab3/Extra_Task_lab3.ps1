$serverInstance = 'vm1\mssqlserver'
$userInstance = 'sa'
$userPwd = 'N19_94Kv'
$serverCred = Get-Credential -UserName 'DEVOPS\Administrator'
$serverName = 'vm1'
$csvPath = 'D:\Home\Learning\EPAM DevOps\Module 3 - SQL Server\Lab3\logins.csv'
$csv = Import-Csv -Path $csvPath -Delimiter ','

# Create local users
foreach ($item in $csv){
    Invoke-Command -ComputerName $serverName -Credential $serverCred -ScriptBlock {
        New-LocalUser -Name ($using:item.username) -Password (ConvertTo-SecureString  ($using:item.password) -AsPlainText -Force); 
        New-LocalGroup -Name ($using:item.function);
        Add-LocalGroupMember -Group ($using:item.function) -Member ($using:item.username)
    }    
}

foreach ($item in $csv){
    USE user_db;  
    GO  
    CREATE LOGIN $($item.username) WITH PASSWORD = $($item.password), Default_Database = user_db
    GO
    USE user_db;
    CREATE USER $($item.username) FROM LOGIN $($item.username)
    GO
    USE user_db;
    EXEC sp_addrolemember  @rolename = $($item.username), @membername = $($item.username)
    EXEC sp_addrolemember  @rolename = $($item.username), @membername = $($item.username)
}
