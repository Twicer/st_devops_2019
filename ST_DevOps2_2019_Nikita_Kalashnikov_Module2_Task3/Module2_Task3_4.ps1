[CmdletBinding()]
Param (
    [Parameter(Mandatory=$false)]
    [string]$Folder='C:'
)
$a=0;
Get-ChildItem -Path $Folder -Recurse -Exclude *.tmp -File | ForEach-Object {$a+=$_.Length}
Write-Output ("{0:N2}" -f $($a/1Gb))