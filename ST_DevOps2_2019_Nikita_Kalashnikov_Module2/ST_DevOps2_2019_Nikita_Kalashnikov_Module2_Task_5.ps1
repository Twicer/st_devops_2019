#1.	При помощи WMI перезагрузить все виртуальные машины.
$cred = Get-Credential administrator
$names = @("VM1", "VM2", "VM3")
(Get-WmiObject win32_operatingsystem -ComputerName $names -cred $cred).Win32Shutdown(6)
#2.	При помощи WMI просмотреть список запущенных служб на удаленном компьютере. 
$cred = Get-Credential administrator
$names = @("VM1", "VM2", "VM3")
Get-WmiObject Win32_Service -ComputerName $names -cred $cred
#3.	Настроить PowerShell Remoting, для управления всеми виртуальными машинами с хостовой.
<#
    Вводим все компьютеры в домен. На контроллере домена включаем политику "Allow automatic configuration of listeners"
    Включаем в фаерволе правило, разрешающее трафик WS-Management. Так как у нас один домен, заносить имена хостов
    в список Trusted необязательно.
#>

#4.	Для одной из виртуальных машин установить для прослушивания порт 42658. Проверить работоспособность PS Remoting.
    # Для этого заранее отключаем политику "Allow automatic configuration of listeners" на DC и применяем команду
    Set-Item WSMan:\localhost\listener\listener*\port -Value 42658
    #Затем создаем сессию с указанием порта
    Enter-PSSession -ComputerName vm2.devops.local -Port 42658
#5.	Создать конфигурацию сессии с целью ограничения использования всех команд, кроме просмотра содержимого дисков.
#На VM создаем сессию с ограничением
New-PSSessionConfigurationFile -Path C:\myses.pssc -VisibleCmdlets Get-ChildItem
Register-PSSessionConfiguration -Path C:\myses.pssc -Name Myses
#Создаем сессию от DC к VM2 и сохраняем ее в переменную $session
$session = New-PSSession -ComputerName vm2.devops.local -ConfigurationName Myses
#Теперь выполнение командлета кроме Get-ChildItem приводит к ошибке

Invoke-Command -Session $session -ScriptBlock {Get-ChildItem C:\}

<# Вывод
Directory: C:\


Mode                LastWriteTime         Length Name                                PSComputerName
----                -------------         ------ ----                                --------------
d-----         6/3/2019   9:43 AM                inetpub                             vm2.devops.local
d-----        7/16/2016   6:23 AM                PerfLogs                            vm2.devops.local
d-r---         6/3/2019   9:43 AM                Program Files                       vm2.devops.local
d-----         6/3/2019   9:43 AM                Program Files (x86)                 vm2.devops.local
d-r---        6/13/2019   9:51 AM                Users                               vm2.devops.local
d-----         6/3/2019   9:43 AM                Windows                             vm2.devops.local
-a----        6/13/2019  12:32 PM           2462 myses.pssc                          vm2.devops.local
#>

Invoke-Command -Session $session -ScriptBlock {Get-Date}

<# Ошибка

The term 'Get-Date' is not recognized as the name of a cmdlet, function, script file, or operable program. Check the
spelling of the name, or if a path was included, verify that the path is correct and try again.
    + CategoryInfo          : ObjectNotFound: (Get-Date:String) [], CommandNotFoundException
    + FullyQualifiedErrorId : CommandNotFoundException
    + PSComputerName        : vm2.devops.local
#>