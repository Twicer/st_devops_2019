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
    [parameter(Mandatory=$true,HelpMessage="Enter Subnet CIDR Mask (example:'/25')")]
    [string]$SubnetMask
)

Install-Module AZSBTools

$TestSubnetMask = Convert-MaskLengthToIpAddress -MaskLength ($SubnetMask.Split('/')[1])
$IPNetworkOne = (Get-IPv4Details -IPAddress $FirstAddress -SubnetMask $TestSubnetMask).NetDottedDecimal
$IPNetworkTwo = (Get-IPv4Details -IPAddress $SecondAddress -SubnetMask $TestSubnetMask).NetDottedDecimal

if ($IPNetworkOne -eq $IPNetworkTwo) {
    "IP addresses $FirstAddress and $SecondAddress are in the same subnet mask $SubnetMask"
} else {
    "Different Subnets!"
}

<# Output:

PS C:\WINDOWS\system32> C:\mask.ps1 -FirstAddress 10.11.12.13 -SecondAddress 10.121.17.14 -SubnetMask /24
Different Subnets!

PS C:\WINDOWS\system32> C:\mask.ps1 -FirstAddress 10.11.12.13 -SecondAddress 10.121.17.14 -SubnetMask /8
IP addresses 10.11.12.13 and 10.121.17.14  IS in the same  subnet mask /8

#>

#2.	Работа с Hyper-V
#2.1.	Получить список коммандлетов работы с Hyper-V (Module Hyper-V)
Get-Command -Module Hyper-V

<# Output:

    CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Cmdlet          Add-VMAssignableDevice                             2.0.0.0    Hyper-V
Cmdlet          Add-VMDvdDrive                                     2.0.0.0    Hyper-V
Cmdlet          Add-VMFibreChannelHba                              2.0.0.0    Hyper-V
Cmdlet          Add-VMGpuPartitionAdapter                          2.0.0.0    Hyper-V
Cmdlet          Add-VMGroupMember                                  2.0.0.0    Hyper-V
Cmdlet          Add-VMHardDiskDrive                                2.0.0.0    Hyper-V
Cmdlet          Add-VMHostAssignableDevice                         2.0.0.0    Hyper-V
Cmdlet          Add-VMKeyStorageDrive                              2.0.0.0    Hyper-V
Cmdlet          Add-VMMigrationNetwork                             2.0.0.0    Hyper-V
Cmdlet          Add-VMNetworkAdapter                               2.0.0.0    Hyper-V
Cmdlet          Add-VMNetworkAdapterAcl                            2.0.0.0    Hyper-V
Cmdlet          Add-VMNetworkAdapterExtendedAcl                    2.0.0.0    Hyper-V
Cmdlet          Add-VMNetworkAdapterRoutingDomainMapping           2.0.0.0    Hyper-V
Cmdlet          Add-VMPmemController                               2.0.0.0    Hyper-V
Cmdlet          Add-VMRemoteFx3dVideoAdapter                       2.0.0.0    Hyper-V
Cmdlet          Add-VMScsiController                               2.0.0.0    Hyper-V
Cmdlet          Add-VMStoragePath                                  2.0.0.0    Hyper-V
Cmdlet          Add-VMSwitch                                       2.0.0.0    Hyper-V
Cmdlet          Add-VMSwitchExtensionPortFeature                   2.0.0.0    Hyper-V
Cmdlet          Add-VMSwitchExtensionSwitchFeature                 2.0.0.0    Hyper-V
Cmdlet          Add-VMSwitchTeamMember                             2.0.0.0    Hyper-V
Cmdlet          Checkpoint-VM                                      2.0.0.0    Hyper-V
Cmdlet          Compare-VM                                         2.0.0.0    Hyper-V
.....................................................................................
Cmdlet          Wait-VM                                            2.0.0.0    Hyper-V
#>

#2.2.	Получить список виртуальных машин
Get-VM 

<# Output:

    Name            State  CPUUsage(%) MemoryAssigned(M) Uptime           Status             Version
----            -----  ----------- ----------------- ------           ------             -------
KALASHNIKOV_VM1 Paused 0           2048              00:00:45.9100000 Operating normally 8.3
KALASHNIKOV_VM2 Off    0           0                 00:00:00         Operating normally 8.3

#>

#2.3.	Получить состояние имеющихся виртуальных машин
get-vm | Select-Object -Property Name, State

<# Output:

    Name             State
----             -----
KALASHNIKOV_VM1 Paused
KALASHNIKOV_VM2    Off

#>

#2.4.	Выключить виртуальную машину
Stop-VM -Name kalashnikov_vm1
#2.5.	Создать новую виртуальную машину
New-VM -Name kalashnikov_vm -NewVHDSizeBytes 20Gb -NewVHDPath `
'D:\Virtual Machines\Hyper-V\kalashnikov_vm\Virtual Hard Disks\kalashnikov_vm.vhdx' `
-Path 'D:\Virtual Machines\Hyper-V\kalashnikov_vm\' -MemoryStartupBytes 1024MB

# Ставим число процессоров 2
Set-VMProcessor -VMName kalashnikov_vm -Count 2

# Добавляем ранее созданный Private адаптер KALASHNIKOV_LAN
Connect-VMNetworkAdapter -VMName kalashnikov_vm -SwitchName KALASHNIKOV_LAN

<# Output:

Name           State CPUUsage(%) MemoryAssigned(M) Uptime   Status             Version
----           ----- ----------- ----------------- ------   ------             -------
kalashnikov_vm Off   0           0                 00:00:00 Operating normally 8.3

#>

#2.6.	Создать динамический жесткий диск
New-VHD -Dynamic -SizeBytes 10Gb -Path 'D:\Virtual Machines\Hyper-V\kalashnikov_vm\Virtual Hard Disks\backup_kalashnikov_vm.vhdx'

#2.7.	Удалить созданную виртуальную машину
Remove-VM -VMName  kalashnikov_vm