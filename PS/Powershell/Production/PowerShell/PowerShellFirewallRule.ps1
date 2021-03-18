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

#--CREATE FIREWALL RULES FOR POWERSHELL TO ALLOW SCRIPTS--
netsh advfirewall firewall add rule name="Allow PowerShell" dir=in action=allow program="%windir%\system32\WindowsPowerShell\v1.0\powershell.exe" enable=yes
netsh advfirewall firewall add rule name="Allow PowerShell" dir=out action=allow program="%windir%\system32\WindowsPowerShell\v1.0\powershell.exe" enable=yes