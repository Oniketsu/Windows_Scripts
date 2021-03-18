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

$String = "*bkp@cock.li*"
$TargetDir = "\\obsc-ds01\badstuff"
$Path = "\\obsc-ds01"

$Locations = @("Payroll","office1","TechRunnerIT","Front Desk","HR-Resumes","Marketing","UserProfileFolders")

Foreach ($Location in $Locations) {
    #Foreach ($Item in (Get-ChildItem -Path ($Path + "\" + $Location) -Recurse -Include $String -Force | Where { ! $_.PSIsContainer })) {
        #Move-Item -LiteralPath $Item.FullName -Destination $TargetDir -Force
        #Write-Host "Moved $Item.FullName`n"
        $Command = ("Robocopy " + ($Path + "\" + $Location) + " $TargetDir $String /e /move /w:0 /r:0")
        Invoke-Expression -Command $Command
    #}
}
