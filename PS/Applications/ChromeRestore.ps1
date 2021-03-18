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

#--CREATE KEYS--
If (!(Test-Path -Path "HKLM:\\SOFTWARE\Policies\Google\")) {New-Item -Path "HKLM:\\SOFTWARE\Policies\" -Name "Google" -Force}
If (!(Test-Path -Path "HKLM:\\SOFTWARE\Policies\Google\Chrome\")) {New-Item -Path "HKLM:\\SOFTWARE\Policies\Google\" -Name "Chrome" -Force}

#--TOGGLE VALUE--
If (Get-ItemProperty -Path "HKLM:\\SOFTWARE\Policies\Google\Chrome" -Name RestoreOnStartup -ErrorAction SilentlyContinue) {
    Write-Host "Value found. Removing..." -ForegroundColor Cyan
    Remove-ItemProperty -Path "HKLM:\\SOFTWARE\Policies\Google\Chrome" -Name "RestoreOnStartup"
    Write-Host "Value removed. RestoreOnStartup disabled." -ForegroundColor Green
} Else {
    Write-Host "Value not found. Creating..." -ForegroundColor Cyan
    New-ItemProperty -Path "HKLM:\\SOFTWARE\Policies\Google\Chrome" -Name "RestoreOnStartup" -Value 1 -PropertyType Dword -Force | Out-Null
    Write-Host "Value created. RestoreOnStartup enabled." -ForegroundColor Green
}