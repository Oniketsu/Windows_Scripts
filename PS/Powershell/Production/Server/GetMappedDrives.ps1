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
$Path = "C:\techrunnerit"
$FileName = "MappedDriveRecon.txt"

#--GET COMPUTER LIST--
$Computers = Get-ADComputer -Filter 'Enabled -eq "True"'

#--GET LIST OF USERS ON EACH COMPUTER--
Write-Host "Working..." -ForegroundColor Cyan
If (!(Test-Path $Path)) {
    New-Item -ItemType Directory -Path $Path
}

If (Test-Path ($Path + "\" + $FileName)) {
    Remove-Item ($Path + "\" + $FileName)
}
Start-Transcript -Path ($Path + "\" + $FileName) -Force
Foreach ($Computer in $Computers) {
    If (Test-Connection -ComputerName $Computer.Name -BufferSize 16 -Count 1 -Quiet) {
        $Users = Get-ADUser -Filter 'Enabled -eq "True"'
        #--CHECK EACH USER FOR MAPPED DRIVES--
        Foreach ($User in $Users) {        
            #--SHOW MAPPED DRIVES--
            $Disks = Get-WmiObject -Class Win32_MappedLogicalDisk -ComputerName $Computer.Name -ErrorAction:SilentlyContinue
            If ($Disks.count -gt 0) {
                Foreach ($Disk in $Disks) {
                }
                Write-Host ("┬ Found " + $Disk.Name + " on user " + $User.Name + " on computer " + $Computer.Name + ".") -ForegroundColor Green
                Write-Host ("└── Path: " + $Disk.ProviderName + "`r`n") -ForegroundColor Green
            }
        }
    } Else {
        Write-Host ("***Can't reach " + $Computer.name + ".`r`n") -ForegroundColor Red
    }
}
Stop-Transcript