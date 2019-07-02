[CmdletBinding()]
Param (
    [Parameter(Mandatory=$false)]
    [string]$File='D:\Top_Processes.txt'
)
Get-Process | Sort-Object -Property CPU -Descending | Select-Object -First 6 | Out-File $File