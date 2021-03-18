#--SETUP--
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\"
Set-Location $RegistryPath

#--CREATE KEY--
Try {
    Write-Host "Creating key..."
    New-Item -Path $RegistryPath -Name "Cloud Content" -Force | Out-Null
    Write-Host "Key created." -ForegroundColor Green
}
Catch {
    Write-Warning "Couldn't create key."
}

#--CREATE AND SET DWORD--
Set-Location "$RegistryPath\Cloud Content"

Try {
    Write-Host "Setting DWORD..."
    New-ItemProperty -Path "$RegistryPath\Cloud Content" -Name "DisableWindowsConsumerFeatures" -Value 1 -PropertyType DWORD -Force | Out-Null
    Write-Host "DWORD set successfully. Restart computer to see changes." -ForegroundColor Green
}
Catch {
    Write-Warning "Couldn't set DWORD."
}