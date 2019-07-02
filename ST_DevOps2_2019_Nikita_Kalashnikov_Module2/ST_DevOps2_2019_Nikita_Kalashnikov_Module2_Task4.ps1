#1.	Вывести список всех классов WMI на локальном компьютере. 
Get-WmiObject -List
#2.	Получить список всех пространств имён классов WMI.
Get-WmiObject -Class __NAMESPACE | select Name
#3.	Получить список классов работы с принтером.
Get-WmiObject -List | Where-Object {$_.name -match "printer"}
#4.	Вывести информацию об операционной системе, не менее 10 полей.
Get-WmiObject win32_operatingsystem -Property manufacturer, status, serialNumber, OSType, Organization, name, locale, oslanguage, Distributed, BuildType
#5.	Получить информацию о BIOS.
Get-WmiObject win32_bios
#6.	Вывести свободное место на локальных дисках. На каждом и сумму.
$a=0; `
Get-WmiObject win32_logicaldisk | Select-Object -Property FreeSpace | ForEach-Object {$_.freespace/1GB; $($a+=$_.freespace) }; `
Write-Host $($a/1gb)Gb
#7.	Написать сценарий, выводящий суммарное время пингования компьютера (например 10.0.0.1) в сети.
Get-WmiObject -Class Win32_PingStatus -Filter "Address='192.168.100.1'" | Select-Object -Property ResponseTime
#8.	Создать файл-сценарий вывода списка установленных программных продуктов в виде таблицы с полями Имя и Версия.
Get-WmiObject win32_product | Select-Object -Property Name, Version | Format-Table
#9.	Выводить сообщение при каждом запуске приложения MS Word.
$qw = "Select * from win32_ProcessStartTrace where processname = 'winword.exe'"
Register-WmiEvent -Query $qw -Action {Write-Host "MS Word has been Started!!!"}
