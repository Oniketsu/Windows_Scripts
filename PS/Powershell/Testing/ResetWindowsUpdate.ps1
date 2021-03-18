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

#--FUNCTIONS--
Function StopService($ServiceName){
    Write-Host "Stopping $ServiceName service..." -ForegroundColor Cyan
    net stop $ServiceName
    If ((Get-Service | Where Name -like "$ServiceName").Status -like "Stopped") {
        Write-Host "$ServiceName service stopped." -ForegroundColor Green
    } Else {
        Write-Host "Couldn't stop $ServiceName service. Might require elevation." -ForegroundColor Red -BackgroundColor Black
    }
}

#--STOP SERVICES--
StopService("BITS")
StopService("wuauserv")
StopService("appidsvc")
StopService("cryptsvc")

#--RESET--
Write-Host "Flushing DNS..." -ForegroundColor Cyan
Ipconfig /Flushdns
Write-Host "DNS flushed." -ForegroundColor Green

Get-ChildItem -Path "%ALLUSERSPROFILE%\Microsoft\Network\Downloader\qmgr*.dat" | Remove-Item
Get-ChildItem -Path "%ALLUSERSPROFILE%\Application Data\Microsoft\Network\Downloader\qmgr*.dat" | Remove-Item