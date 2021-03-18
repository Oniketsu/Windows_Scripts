#############################################################################
#If Powershell is running the 32-bit version on a 64-bit machine, we 
#need to force powershell to run in 64-bit mode .
#############################################################################
if ($env:PROCESSOR_ARCHITEW6432 -eq "AMD64") {
    write-warning "Y'arg Matey, we're off to 64-bit land....."
    if ($myInvocation.Line) {
        &"$env:WINDIR\sysnative\windowspowershell\v1.0\powershell.exe" -NonInteractive -NoProfile $myInvocation.Line
    }else{
        &"$env:WINDIR\sysnative\windowspowershell\v1.0\powershell.exe" -NonInteractive -NoProfile -file "$($myInvocation.InvocationName)" $args
    }
exit $lastexitcode
}

#--SETUP--
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows"
$NewRegPath = ($RegPath + "\Explorer")

#--CREATE KEY--
Try {
    Write-Host "Creating key..."
#    If (!(Test-Path $NewRegPath))
#        {
        Set-Location $RegPath
        New-Item -Name "Explorer" -Force
        Write-Host "Key created." -ForegroundColor Green
#        }
}
Catch {
    Write-Error $Error
}


#--CREATE AND SET DWORD--
Try {
    Write-Host "Setting DWORD..."
    New-ItemProperty -Path $NewRegPath -Name "DisableNotificationCenter" -Value 1 -PropertyType DWORD -Force
    Write-Host "DWORD set successfully. Restart computer to see changes." -ForegroundColor Green
}
Catch {
    Write-Warning "Couldn't set DWORD."
}