$cur_Date = Get-Date
Write-Host "Creating Restore Point incase something bad happens"
Enable-ComputerRestore -Drive "C:\"
Checkpoint-Computer -Description "RestorePoint1-AT: $cur_Date" -RestorePointType "MODIFY_SETTINGS"