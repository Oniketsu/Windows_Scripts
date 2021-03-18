#--SETUP--;
$Paths = ("C:\admin", "C:\techrunnerit", "C:\ntr", "C:\programdata\vipre", "C:\programdata\ninjarmm", "C:\programdata\OpenDNS", "C:\programdata\webroot");
$Command = '"c:\program files (x86)\TechRunner IT\Cloud Backup\uninst.exe" /S'

#--CLOUD UNINSTALLER--;
Write-Host "Uninstalling TechRunner IT Cloud Backup..." -ForegroundColor Cyan;
Try {
    Invoke-Expression -Command $Command;
    Write-Host "TechRunner IT Cloud Backup uninstalled successfully." -ForegroundColor Green;
}
Catch {
    Write-Warning "Couldn't uninstall TechRunner IT Cloud Backup.";
}

#--REMOVE PATHS--;
Foreach ($Path in $Paths) {
    If (Test-Path $Path) {
        Write-Host "Removing path $Path..." -ForegroundColor Cyan;
        Try {
            Remove-Item -Path $Path -Recurse -Confirm:$false;
            Write-Host "$Path successfully removed." -ForegroundColor Green;
        }
        Catch {
            Write-Warning "Couldn't remove $Path. It may not exist.";
        }
    }
    Else {
        Write-Host "Path $Path doesn't exist. Skipping..." -ForegroundColor Yellow
    }
}