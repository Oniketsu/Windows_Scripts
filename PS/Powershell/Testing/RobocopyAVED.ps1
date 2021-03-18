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

#--COPY JOBS--
robocopy '\\avedserver\AveD-Office' '\\aved-ds01\AveD-Office' *.* /copyall /e /r:0 /w:0 /xf *.tmp *.temp
robocopy '\\avedserver\INSTALL' '\\aved-ds01\INSTALL' *.* /copyall /e /r:0 /w:0 /xf *.tmp *.temp
robocopy '\\salemserver\Data' '\\aved-ds01\Data' *.* /copyall /e /r:0 /w:0 /xf *.tmp *.temp
robocopy '\\salemserver\Install' '\\aved-ds01\INSTALL' *.* /copyall /e /r:0 /w:0 /xf *.tmp *.temp
robocopy '\\salemserver\Robert' '\\aved-ds01\Robert' *.* /copyall /e /r:0 /w:0 /xf *.tmp *.temp
robocopy '\\salemserver\Sales' '\\aved-ds01\Sales' *.* /copyall /e /r:0 /w:0 /xf *.tmp *.temp
robocopy '\\salemserver\Used Trucks' '\\aved-ds01\Used Trucks' *.* /copyall /e /r:0 /w:0 /xf *.tmp *.temp