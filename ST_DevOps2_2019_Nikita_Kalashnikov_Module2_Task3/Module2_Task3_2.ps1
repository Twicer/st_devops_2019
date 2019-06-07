$result=0;
Get-Variable | ForEach-Object {if (($_.Name -ne "null") -and ($_.Value.GetType() -eq [int])){$result+=$_.Value} else{}}
Write-Host $result