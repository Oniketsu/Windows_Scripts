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

$RansomStringRaw = '.id-6A533648.[bkp@cock.li].bkp'
$RansomString = ".id-6A533648.bkpcock.li.bkp"
$RansomStringWorkable = "bkp@cock.li"
$BucketString = "gs://obsc-backup/MBS-96d4777b-3971-4abc-b139-e86de38c163a/CBB_OBSC08SRV01/"
$BadStuff = "\\obsc-ds01\badstuff"
#$LogPath = "C:\techrunnerit\log.txt"
#$RoboLogPath = "C:\techrunnerit\robolog.txt"
$NewLogPath = "C:\techrunnerit\newlog.txt"
#$NewRoboLogPath = "C:\techrunnerit\newrobolog.txt"
#$Test = [String]"- 2018 Mercury Public Affairs LLC W9.pdf.id-6A533648.[bkp@cock.li].bkp"

$NewLogArray = New-Object System.Collections.ArrayList

#$LogArray = New-Object System.Collections.ArrayList
#$RoboLogArray = New-Object System.Collections.ArrayList
#$FolderArray = @(
#"AdministrativeOffice",
#"BHC",
#"HHNursing",
#"HHRec",
#"HR",
#"HarborHouse",
#"Kitchen",
#"OBM",
#"Users Shared Folders"
#)


#Foreach ($Line in [System.IO.File]::ReadLines($LogPath))
#{
#    $Line = $Line -Replace "[][@]", ""
#    $Line = $Line.Replace($RansomString,"")
#    $Line = $Line.Replace($BucketString,"")
#    $Line = $Line.Substring(0, $Line.IndexOf(':/20'))
#
#    [void]$LogArray.Add($Line)
#
#}

#Foreach ($File in [System.IO.File]::ReadLines($RoboLogPath))
#{
#    #[void]$RoboLogArray.Add()
#    [void]$RoboLogArray.Add( $File.Substring($File.IndexOf($BadStuff)) )
#}
#
#    $LogArray | Out-File "c:\techrunnerit\newlog.txt"
#    $RoboLogArray | Out-File "c:\techrunnerit\newrobolog.txt"

#Foreach ($NewLogLine in Get-Content $NewLogPath) {
#    Foreach ($NewRoboLogLine in Get-Content $NewRoboLogPath) {
#        $Check = $NewRoboLogLine -Replace "[][@]",""
#        $Check = $Check.Replace("$RansomString","")
#        $GetDir = $Check
#        $Check = $Check.Replace("$BadStuff\","")
#        $GetDir = $GetDir.Replace("\$Check","")
#        If (($NewLogLine -like "*$Check*") -and ($Check.Length -gt 6)) {
#            $PlaceDir = $NewLogLine.Replace("/$Check","")
#            $Command = ("Robocopy """ + $GetDir + """ """ + $PlaceDir + """ """ + $Check + $RansomStringRaw + """ /move /w:0 /r:0")
#            Invoke-Expression -Command $Command
#            Write-Host "Found and moved $Check" -ForegroundColor Green
#            Continue
#        }
#    }
#}

#--SCAN FOR FILES FROM BADSTUFF--
If ($Files -ne $null) {Clear-Variable "Files"}
Write-Host "Getting file data from $BadStuff..." -ForegroundColor Cyan -NoNewline
$Files = Get-ChildItem -Path $BadStuff -Exclude "*$RansomStringWorkable*" -Name -File
Write-Host ("`rFound " + $Files.Count + " file(s) in $BadStuff.                       ") -ForegroundColor Green
Start-Sleep -Milliseconds 500

#--PULL DATA FROM TEXT FILE WITH E DRIVE STRUCTURE--
Write-Host "Loading data from $NewLogPath..." -ForegroundColor Cyan -NoNewline
$LogFiles = Get-Content $NewLogPath
Write-Host "`rLoaded data from $NewLogPath.                         " -ForegroundColor Green
Start-Sleep -Milliseconds 500

#--MOVE FILES BACK TO THEIR HOMES--
#Write-Host "Working..." -ForegroundColor Cyan
#Foreach ($File in $Files) {
#    #$Matched = $false
#    Write-Host "Working on $File..." -ForegroundColor Cyan
#    Foreach ($NewLogLine in $LogFiles) {
#        If (($NewLogLine -like "*$File") -and ($File -like "*.*")) {
#            $PlaceDir = $NewLogLine.Replace("/$File","")
#            $Command = ("Robocopy """ + $BadStuff + """ """ + $PlaceDir + """ """ + $File + """ /move /w:0 /r:0")
#            Write-Host "Matched $File" -ForegroundColor Green
#            #$Matched = $true
#            Invoke-Expression -Command $Command
#            Continue
#        }
#    }
#    #If ($Matched -eq $false) {Write-Host "Couldn't match $File" -ForegroundColor Red}
#}

#--MOVE FILES BACK TO THEIR HOMES--
Write-Host "Converting text file into workable format..." -ForegroundColor Cyan -NoNewline
Foreach ($NewLogLine in $LogFiles) {
    $NewLogArray.Add($NewLogLine.Substring($NewLogLine.LastIndexOf("/")+1)) | Out-Null
}
Write-Host "`rConverted $($NewLogArray.Count) file(s) from text file.                " -ForegroundColor Green

Write-Host "Matching files to list..." -ForegroundColor Cyan -NoNewline
$Matched = Compare-Object -ReferenceObject $NewLogArray -DifferenceObject $Files -ExcludeDifferent -IncludeEqual
Write-Host "`rFound $($Matched.Count) matching file(s)`n." -ForegroundColor Green

$Count = 0
Foreach ($File in $Matched) {
    $Count++
    $PlaceDir = $NewLogLine.Substring(0,$NewLogLine.LastIndexOf("/"))
    $Command = ("Robocopy """ + $BadStuff + """ """ + $PlaceDir + """ """ + $File.InputObject + """ /move /w:0 /r:0")
    Write-Host ("`rAttempting to move file " + $Count + "...      ") -ForegroundColor Cyan -NoNewline
    #$Matched = $true
    Invoke-Expression -Command $Command | Out-Null
    Continue
}
Write-Host "Attempted to move all files.                      " -ForegroundColor Green
Pause
#Foreach ($Folder in $FolderArray) {
#    $Command = ("Robocopy """ + $BadStuff + "\" + $Folder + """ ""E:\" + $Folder + """ *.* /xf '" + $RansomStringRaw + "' /move /w:0 /r:0")
#}