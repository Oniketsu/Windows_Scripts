#--SETUP--
$Path = "E:\Personal\"
$Destination = "\\192.168.72.37\seagate8tb\acctarchive\Personal\"
$Date = '01/01/2012'

#--GET FILE INFO--
Write-Host "Getting file info..." -ForegroundColor Cyan
#$Files = Get-ChildItem -Path $Path -Recurse | Where {$_.CreationTime -lt $Date} | Select Name, FullName, Directory
#$Folders = Get-ChildItem -Path $Path -Recurse | Where {($_.CreationTime -lt $Date) -and ($_.Mode -like "*d*")} | Select Name, FullName
$Folders = Get-ChildItem -Path $Path -Recurse | Where {($_.Mode -like "*d*")} | Select Name, FullName
$PropertiesList = [System.Collections.ArrayList]@()
Foreach ($Folder in $Folders) {
    $Properties =Get-ChildItem $Folder.FullName | Measure-Object
    If ($Properties.Count -eq 0) {
        $PropertiesList.Add($Properties)
    }
}
Write-Host "File info obtained." -ForegroundColor Green

$Output = [System.Collections.ArrayList]@()

Foreach ($Folder in $Folders) {
    $Properties = Get-ChildItem $Folder.FullName | Measure-Object
    If ($Properties.Count -eq 0) {
        $Output.Add($Folder)
    }
}

Write-Host "IS THE SERVER FINALLY CLEAN?" -ForegroundColor Yellow -BackgroundColor Black

If ($Output.Count -eq 0) {
    Write-Host "Yes. Yes, it is." -ForegroundColor Green -BackgroundColor DarkGray
} Else {
    Write-Host "No. No, it is not." -ForegroundColor Red -BackgroundColor DarkGray
}