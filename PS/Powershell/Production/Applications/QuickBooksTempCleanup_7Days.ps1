#--SETUP--
$Disks = gwmi win32_logicaldisk -Filter "DriveType='3'"
$TempFolders = New-Object System.Collections.ArrayList
$ErrorActionPreference = "silentlycontinue"

#--SCAN FOR TEMP FOLDERS--
Write-Host "Scanning for QuickBooks temporary folders..." -ForegroundColor Cyan
Try {
    Foreach ($Drive in $Disks) {
        $TempFolders += Get-Childitem -Path ($Drive.DeviceID + "\") -Directory -Include *QBBackupTemp* -Recurse -ErrorAction SilentlyContinue | Where{$_.LastWriteTime -le (Get-Date).AddDays(-7)}
    }
    Write-Host "Scanning completed successfully." -ForegroundColor Green
}
Catch {
    Write-Warning "Scan encountered errors and may have failed. Continuing..."
}

#--CLEAN TEMP FILES--
If (!$TempFolders) {Write-Host "No temporary files found." -ForegroundColor Magenta}
Else {
    Try {
        Foreach ($Path in $TempFolders) {
            Write-Host "Found path $Path"
            Write-Host "Removing $Path..." -ForegroundColor Red
            Remove-Item -Path $Path -Recurse
            Write-Host "$Path removed." -ForegroundColor Green
        }
    }
    Catch {
        Write-Warning "Failed."
    }
}