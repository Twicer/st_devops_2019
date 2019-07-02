#1.	Создайте сценарии *.ps1 дл я задач из labwork 2, проверьте их работоспостобность. Каждый сценарий должен иметь параметры.
#1.1.	Сохранить в текстовый файл на диске список запущенных(!) служб. Просмотреть содержимое диска. Вывести содержимое файла в консоль PS.
[CmdletBinding()]
Param (
    [Parameter(Mandatory=$false)]
    [string]$File='D:\Services.txt'
)

Get-Service | Where-Object -Property Status -eq Running | Out-File $File
Get-ChildItem C:
Get-Content $File | Write-Host
#1.2.	Просуммировать все числовые значения переменных среды Windows. (Параметры не нужны)
$result=0;
Get-Variable | ForEach-Object {if (($_.Name -ne "null") -and ($_.Value.GetType() -eq [int])){$result+=$_.Value} else{}}
Write-Host $result
#1.3.	Вывести список из 10 процессов занимающих дольше всего процессор. Результат записывать в файл.
[CmdletBinding()]
Param (
    [Parameter(Mandatory=$false)]
    [string]$File='D:\Top_Processes.txt'
)
Get-Process | Sort-Object -Property CPU -Descending | Select-Object -First 10 | Out-File $File
#1.3.1.	Организовать запуск скрипта каждые 10 минут
$t = New-JobTrigger -Once -At "6/7/2019 0AM" -RepetitionInterval (New-TimeSpan -Minutes 10) -RepetitionDuration ([TimeSpan]::MaxValue)
$cred = Get-Credential Administrator
$o = New-ScheduledJobOption -RunElevated
Register-ScheduledJob -Name Start -FilePath 'D:\Home\Learning\EPAM DevOps\ST_DevOps2_2019\ST_DevOps2_2019_Nikita_Kalashnikov_Module2_Task3\Module2_Task3_3.ps1' -Trigger $t -Credential $cred -ScheduledJobOption $o
#1.4.	Подсчитать размер занимаемый файлами в папке (например C:\windows) за исключением файлов с заданным расширением(напрмер .tmp)
[CmdletBinding()]
Param (
    [Parameter(Mandatory=$false)]
    [string]$Folder='C:'
)
$a=0;
Get-ChildItem -Path $Folder -Recurse -Exclude *.tmp -File | ForEach-Object {$a+=$_.Length}
Write-Output ("{0:N2}" -f $($a/1Gb))
#1.5.	Создать один скрипт, объединив 3 задачи:
#1.5.1.	Сохранить в CSV-файле информацию обо всех обновлениях безопасности ОС.
#1.5.2.	Сохранить в XML-файле информацию о записях одной ветви реестра HKLM:\SOFTWARE\Microsoft.
#1.5.3.	Загрузить данные из полученного в п.1.5.1 или п.1.5.2 файла и вывести в виде списка  разным разными цветами
[CmdletBinding()]
Param (
    [Parameter(Mandatory=$false)]
    [string]$CSV_File_Path='D:\CSV_Info.csv',
    [string]$XML_File_Path='D:\XML_Info.xml'
)
Get-HotFix | Where-Object -Property Description -eq "Security Update" | Export-Csv $CSV_File_Path
Get-ChildItem HKLM:\SOFTWARE\Microsoft | Export-Clixml $XML_File_Path
Import-Csv $CSV_File_Path | Write-Host -ForegroundColor Red | Format-List
Import-Clixml $XML_File_Path | Write-Host -ForegroundColor Green | Format-List
#2.	Работа с профилем
#2.1.	Создать профиль
New-Item -ItemType file -Path $profile -force
#2.2.	В профиле изненить цвета в консоли PowerShell
(Get-Host).UI.RawUI.ForegroundColor = ″Red″
(Get-Host).UI.RawUI.BackgroundColor = ″black″
#2.3.	Создать несколько собственный алиасов
Set-Alias Date Get-Date
Set-Alias Omg Get-HotFix
#2.4.	Создать несколько констант
$a=0;
$TrainingName="ST_DevOps2_2019"
#2.5.	Изменить текущую папку
Set-Location D:\Home
#2.6.	Вывести приветсвие
Write-Host ″Yo man! whats up?″
#2.7.	Проверить применение профиля

#3.	Получить список всех доступных модулей
Get-Module -ListAvailable