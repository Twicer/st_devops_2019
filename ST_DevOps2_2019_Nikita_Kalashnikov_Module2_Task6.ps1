#1.	Для каждого пункта написать и выполнить соответсвующий скрипт автоматизации администрирования:
#1.1.	Вывести все IP адреса вашего компьютера (всех сетевых интерфейсов)
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName . |
Select-Object -ExpandProperty IPAddress
#1.2.	Получить mac-адреса всех сетевых устройств вашего компьютера и удалённо.
Get-WmiObject -Class Win32_NetworkAdapter | Select-Object -ExpandProperty MACAddress

Invoke-Command -ComputerName VM2 -ScriptBlock {Get-WmiObject -Class Win32_NetworkAdapter | 
Select-Object -ExpandProperty MACAddress}

#1.3.	На всех виртуальных компьютерах настроить (удалённо) получение адресов с DHСP.
$machines = @("VM1", "VM2", "VM3")
$cred = Get-Credential Administrator
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=true -ComputerName $machines -Credential $cred | 
ForEach-Object -Process {$_.InvokeMethod("EnableDHCP", $null)}

Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "IPEnabled=true and DHCPEnabled=true" -ComputerName $machines -Credential $cred | 
ForEach-Object -Process {$_.InvokeMethod("ReleaseDHCPLease",$null)}

Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "IPEnabled=true and DHCPEnabled=true" -ComputerName $machines -Credential $cred | 
ForEach-Object -Process {$_.InvokeMethod("RenewDHCPLease",$null)}

#1.4.	Расшарить папку на компьютере

net share myshare = C:\myfolder /users:25 /remark:"My shared folder"

#1.5.	Удалить шару из п.1.4

net share myshare /delete

#1.6.	Скрипт входными параметрами которого являются Маска подсети и два ip-адреса. Результат  – сообщение (ответ) в одной ли подсети эти адреса.

[CmdletBinding()]
Param (
    [parameter(Mandatory=$true,HelpMessage="Enter First IP Address")]
    [string]$FirstAddress,
    [parameter(Mandatory=$true,HelpMessage="Enter Second IP Address")]
    [string]$SecondAddress,
    [parameter(Mandatory=$true,HelpMessage="Enter Subnet CIDR Mask")]
    [string]$SubnetMask
)

Install-Module AZSBTools

$TestSubnetMask = Convert-MaskLengthToIpAddress -MaskLength ($SubnetMask.Split('/')[1])
$IPNetworkOne = (Get-IPv4Details -IPAddress $FirstAddress -SubnetMask $TestSubnetMask).NetDottedDecimal
$IPNetworkTwo = (Get-IPv4Details -IPAddress $SecondAddress -SubnetMask $TestSubnetMask).NetDottedDecimal

if ($IPNetworkOne -eq $IPNetworkTwo) {
    "IP addresses $FirstAddress and $SecondAddress  IS in the same  subnet mask $SubnetMask"
} else {
    "Different Subnets"
}

#2.	Работа с Hyper-V
#2.1.	Получить список коммандлетов работы с Hyper-V (Module Hyper-V)
#2.2.	Получить список виртуальных машин
    Get-VM 
<# Output:
    Name            State  CPUUsage(%) MemoryAssigned(M) Uptime           Status             Version
----            -----  ----------- ----------------- ------           ------             -------
KALASHNIKOV_VM1 Paused 0           2048              00:00:45.9100000 Operating normally 8.3
KALASHNIKOV_VM2 Off    0           0                 00:00:00         Operating normally 8.3

#>
#2.3.	Получить состояние имеющихся виртуальных машин
#2.4.	Выключить виртуальную машину
#2.5.	Создать новую виртуальную машину
#2.6.	Создать динамический жесткий диск
#2.7.	Удалить созданную виртуальную машину