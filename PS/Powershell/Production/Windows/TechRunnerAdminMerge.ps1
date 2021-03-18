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
$TechRunner = "$env:SystemDrive\TechRunnerIT"
$Admin = "$env:SystemDrive\admin"

#--TEST PATHS--
Write-Host "Scanning for folders...`n" -ForegroundColor Cyan

If (Test-Path $TechRunner) {
    If (Test-Path $Admin) {
        Write-Host "Both Admin and TechRunnerIT exist.`nMerging Admin into TechRunnerIT..." -ForegroundColor Yellow
        Try {
            robocopy $Admin $TechRunner *.* /e /xo /move /w:0 /r:0 | Out-Null
            Write-Host "Admin successfully merged into TechRunnerIT." -ForegroundColor Green
        } Catch {
            Write-Warning "Couldn't merge Admin into TechRunnerIT."
        }
    } Else {
        Write-Host "TechRunnerIT exists; Admin doesn't.`nAll set!" -ForegroundColor Green
    }
} Else {
    If (Test-Path $Admin) {
        Write-Host "Admin exists; TechRunnerIT doesn't.`nRenaming Admin to TechRunnerIT..." -ForegroundColor Yellow
        Try {
            Rename-Item -Path $Admin -NewName $TechRunner -Force
            Write-Host "Admin renamed to TechRunnerIT." -ForegroundColor Green
        } Catch {
            Write-Warning "Couldn't rename Admin to TechRunnerIT."
        }
    } Else {
        Write-Host "Neither TechRunnerIT nor Admin exist.`nCreating TechRunnerIT..." -ForegroundColor Yellow
        Try {
            New-Item -ItemType Directory -Path $TechRunner
            Write-Host "Created TechRunnerIT." -ForegroundColor Green
        } Catch {
            Write-Warning "Couldn't create TechRunnerIT."
        }
    }
}