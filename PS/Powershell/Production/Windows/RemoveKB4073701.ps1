$KBNumber = "4073701"
$RemovalCommand = "wusa.exe /uninstall /kb:$KBNumber /quiet /log /norestart";
Write-Host ("Removing update with command: " + $RemovalCommand);
Invoke-Expression -Command $RemovalCommand;
    while (@(Get-Process wusa -ErrorAction SilentlyContinue).Count -ne 0)
    {
        Start-Sleep 1
        Write-Host "Waiting for update removal to finish ..."
    }