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
$Model = "M278"
$ModelName = "HP Color LaserJet MFP M281fdw"
$PortName = "TCPPort:"
$Address = "10.25.0.21"
$DriverName = ""
$DriverFile = ""

#--REMOVE PRINTER--
cls

Start-Sleep -Milliseconds 100
Write-Host "Removing printer... " -ForegroundColor Cyan -NoNewline
Start-Sleep -Milliseconds 300
Remove-Printer -Name $ModelName
Write-Host "OK!" -ForegroundColor Green