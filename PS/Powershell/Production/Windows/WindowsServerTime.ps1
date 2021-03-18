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

#--CHECK IF DOMAIN CONTROLLER--
Write-Host "Checking for Domain Controller status..." -ForegroundColor Cyan
If ((gwmi win32_computersystem).DomainRole -eq 5) {
    Write-Host "Valid Primary Domain Controller. Proceeding..." -ForegroundColor Green
} Else {
    Write-Warning "Current machine is NOT a Primary Domain Controller."
    Return
}


Function Restart-TimeService {
    Write-Host "`nRestarting time service..." -ForegroundColor Cyan
    net stop w32time
    Start-Sleep -s 5
    net start w32time
    Start-Sleep -s 5
    Write-Host "Time service restarted." -ForegroundColor Green
}

#--RE-REGISTER WINDOWS TIME SERVICE--
Write-Host "`nRe-registering Windows Time Service..." -ForegroundColor Cyan
net stop w32time
Start-Sleep -s 5
w32tm /unregister
Start-Sleep -s 2
w32tm /register
Start-Sleep -s 2
net start w32time
Start-Sleep -s 5
Write-Host "Time Service re-registered." -ForegroundColor Green

#--RESET REGISTRY SETTINGS TO DEFAULT--
#Write-Host "`nResetting registry settings..." -ForegroundColor Cyan
#net time /setsntp:
#Start-Sleep -s 2
#Write-Host "Registry settings reset."

#Restart-TimeService

#--RESYNC PEER LIST--
Write-Host "`nRe-syncing peer list..." -ForegroundColor Cyan
w32tm /config /manualpeerlist:time-a.nist.gov /syncfromflags:manual /reliable:yes /update
w32tm /resync /rediscover
Start-Sleep -s 2
Write-Host "Peer list re-synced." -ForegroundColor Green

Restart-TimeService