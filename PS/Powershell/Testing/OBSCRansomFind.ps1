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

$FoundFiles = New-Object System.Collections.ArrayList

$Drives = Gwmi Win32_LogicalDisk -Filter "DriveType = 3"
Foreach ($Drive in $Drives) {
    Foreach ($Item in (Get-ChildItem -Path $Drive.DeviceID -Recurse -Include $String)) {
        #Write-Host "Found " $Item.FullName
        $CopyJob = "robocopy $Path NULL /L /S /NJH /BYTES /FP /NC /NDL /XJ /TS /R:0 /W:0"
        [void]$FoundFiles.Add($CopyJob)

    }
}

$FileName = ($env:ComputerName + "_RansomFiles.csv")
$FilePath = ("\\obsc-ds01\badstuff\reports\" + $FileName)

$LocalPath = "c:\techrunnerit"
If ((Test-Path -Path $LocalPath) -eq $false) {
    New-Item -Path $LocalPath -ItemType Directory
}

$Email = "themailman@techrunnerit.com"
$Password = "KdaKh=P18Gtp2uW"
$Password | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File "C:\techrunnerit\pass.txt"
$Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Email, (Get-Content "C:\techrunnerit\pass.txt" | ConvertTo-SecureString)

If ($CopyJob -ne $null) {
    #$FoundFiles | Export-Csv $FilePath -NoTypeInformation
    Send-MailMessage -Body $CopyJob -From $Email -To "itmail@techrunnerit.com" -Subject "Ransomware Files for $env:ComputerName" -Encoding $([System.Text.Encoding]::UTF8) -Credential $Credentials -SmtpServer "smtp.office365.com" -Port 587 -UseSsl | Out-Null
} Else {
    Write-Host "No ransomware files detected!"
}