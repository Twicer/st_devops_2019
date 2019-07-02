[CmdletBinding()]
Param (
    [Parameter(Mandatory=$false)]
    [string]$File='D:\Services.txt'
)

Get-Service | Where-Object -Property Status -eq Running | Out-File $File
Get-ChildItem C:
Get-Content $File | Write-Host