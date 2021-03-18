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
$Path = "E:\Personal\"
$Destination = "\\192.168.72.37\seagate8tb\acctarchive\Personal\"
$Date = '01/01/2012'

#--GET FILE INFO--
Write-Host "Getting file info..." -ForegroundColor Cyan
#$Files = Get-ChildItem -Path $Path -Hidden -Recurse | Where {$_.CreationTime -lt $Date} | Select Name, FullName, Directory
#$Folders = Get-ChildItem -Path $Path -Recurse | Where {($_.CreationTime -lt $Date) -and ($_.Mode -like "*d*")} | Select Name, FullName
$Folders = Get-ChildItem -Path $Path -Hidden -Recurse -Force | Where {($_.Mode -like "*d*")} | Select Name, FullName
$PropertiesList = [System.Collections.ArrayList]@()
Foreach ($Folder in $Folders) {
    $Properties =Get-ChildItem $Folder.FullName | Measure-Object
    If ($Properties.Count -eq 0) {
        $PropertiesList.Add($Properties)
    }
}
Write-Host "File info obtained." -ForegroundColor Green


#--MOVE FILES--
Write-Host "`nMoving files..." -ForegroundColor Cyan

Do {
    $Counter = 0

    Foreach ($Folder in $Folders) {
        $Properties = Get-ChildItem $Folder.FullName | Measure-Object
        If ($Properties.Count -eq 0) {
            $NewDest = (($Destination + ($Folder.FullName.Substring(0,$Folder.FullName.Length-$Folder.Name.Length)).Remove(0,$Path.Length)))
            If (!(Test-Path ($NewDest + $Folder.Name))) {
                If (!(Test-Path $NewDest)) {
                    New-Item -ItemType Directory -Path $NewDest
                }
                $status = "Folder {0} of {1}: Moving {2} to {3}" -f $Counter,$Folders.Count,$Folder.FullName,$NewDest
                Write-Progress -Activity "Move data" $status -PercentComplete ($counter / $Folders.Count*100)
                #Move-Item -Path $Folder.FullName -Destination ($NewDest + $Folder.Name) -Force
                robocopy $Folder.FullName ($NewDest + $Folder.Name) /e /xf /move /copy:dat /dcopy:T
                $Counter++
            } Else {
                $status = "Folder {0} of {1}: Moving {2} to {3}" -f $Counter,$Folders.Count,$Folder.FullName,$NewDest
                Write-Progress -Activity "Move data" $status -PercentComplete ($counter / $Folders.Count*100)
                Remove-Item -Path $Folder.FullName -Force -Recurse
                $Counter++
            }
        }
    }

    Write-Host "`nGetting file info..." -ForegroundColor Cyan
    #$Folders = Get-ChildItem -Path $Path -Recurse | Where {($_.CreationTime -lt $Date) -and ($_.Mode -like "*d*")} | Select Name, FullName
    $Folders = Get-ChildItem -Path $Path -Recurse | Where {($_.Mode -like "*d*")} | Select Name, FullName
    $PropertiesList = [System.Collections.ArrayList]@()
    Foreach ($Folder in $Folders) {
        $Properties =Get-ChildItem $Folder.FullName | Measure-Object
        If ($Properties.Count -eq 0) {
            $PropertiesList.Add($Properties) | Out-Null
        }
    }
    Write-Host "File info obtained." -ForegroundColor Green

    If ($PropertiesList.Count -eq 0) {
        Write-Host "`nAll clean." -ForegroundColor Green
    } Else {
        Write-Host "`nFound more folders. Performing additional sweep..." -ForegroundColor Yellow
    }

} Until ($PropertiesList.Count -eq 0)

#Foreach ($File in $Files) {
#    $NewDest = (($Destination + ($File.Directory.FullName).Remove(0,$Path.Length)))
#    If (!(Test-Path $NewDest)) {
#        New-Item -ItemType Directory -Path $NewDest
#    }
#    $Counter++
#    If (!(Test-Path ($NewDest + "\" + $File.Name))){
#        $status = "File {0} of {1}: Moving {2} to {3}" -f $Counter,$Files.Count,$File.FullName,$NewDest
#        Write-Progress -Activity "Move data" $status -PercentComplete ($counter / $files.count*100)
#        Move-Item -Path $File.FullName -Destination ($NewDest + $File.Name) -Force
#    }
#}