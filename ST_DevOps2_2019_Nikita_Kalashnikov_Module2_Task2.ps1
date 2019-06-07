#1.	Просмотреть содержимое ветви реeстра HKCU

Get-ChildItem HKCU:

#2.	Создать, переименовать, удалить каталог на локальном диске

New-Item -ItemType Directory "D:\New_Folder"
Rename-Item -path "D:\New_Folder\" -NewName "Renamed_Folder"
Remove-Item "D:\Renamed_Folder"

#3.	Создать папку C:\M2T2_ФАМИЛИЯ. Создать диск ассоциированный с папкой 
#C:\M2T2_ФАМИЛИЯ.

New-Item -ItemType Directory "C:\M2T2_KALASHNIKOV"
New-PSDrive -Name "M2T2" -PSProvider "FileSystem" -Root "C:\M2T2_KALASHNIKOV"

#4.	Сохранить в текстовый файл на созданном диске список запущенных(!) служб. Просмотреть содержимое диска. Вывести содержимое файла в консоль PS.

Get-Service | Where-Object -Property Status -eq Running | Out-File M2T2:\Running_Serices.txt
Get-ChildItem M2T2:
Get-Content M2T2:\Running_Serices.txt | Write-Host

#5.	Просуммировать все числовые значения переменных текущего сеанса.

$a=0
Get-Variable | ForEach-Object {if (($_.Name -ne "null") -and ($_.Value.GetType() -eq [int])){$a+=$_.Value} else{}}

#6.	Вывести список из 6 процессов занимающих дольше всего процессор.

Get-Process | Sort-Object -Property CPU -Descending | Select-Object -First 6

#7.	Вывести список названий и занятую виртуальную память (в Mb) каждого процесса, разделённые знаком тире, при этом если процесс занимает более 100Mb – выводить информацию красным цветом, иначе зелёным.

Get-Process | ForEach-Object {if ($($_.VM/1Mb) -gt 100) `
{Write-Host (("{0:N2}" -f $($_.VM/1Mb)), $_.Name) -Separator " - " -ForegroundColor Red | `
Format-List} else {Write-Host (("{0:N2}" -f $($_.VM/1Mb)), $_.Name) -Separator " - " -ForegroundColor Green}}

#8.	Подсчитать размер занимаемый файлами в папке C:\windows (и во всех подпапках) за исключением файлов *.tmp

$a=0
Get-ChildItem -path C:\ -Recurse -Exclude *.tmp -File | ForEach-Object {$a+=$_.Length}

#9.	Сохранить в CSV-файле информацию о записях одной ветви реестра HKLM:\SOFTWARE\Microsoft.

Get-ChildItem HKLM:\SOFTWARE\Microsoft | Export-Csv D:\Export_HKLM.csv

#10.	Сохранить в XML -файле историческую информацию о командах выполнявшихся в текущем сеансе работы PS.

Get-History | Export-Clixml D:\Export_History.xml

#11.	Загрузить данные из полученного в п.10 xml-файла и вывести в виде списка информацию о каждой записи, в виде 5 любых (выбранных Вами) свойств.

Import-Clixml D:\Export_History.xml | Select-Object -Property StartExecutionTime, EndExecutionTime, CommandLine, Id, ExecutionStatus | Format-List

#12.	Удалить созданный диск и папку С:\M2T2_ФАМИЛИЯ

Remove-PSDrive M2T2
Remove-Item C:\M2T2_KALASHNIKOV
