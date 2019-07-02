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