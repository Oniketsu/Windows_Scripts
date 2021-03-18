#--PREPARE MODULE DOWNLOAD--
$FileURL = "https://gallery.technet.microsoft.com/Powershell-Function-to-45f37bfc/file/129598/3/Export-ADUsers.zip"
$Directory = "\temp\AD"
$Output = "$Directory\ADUsers.zip"
$ModuleName = "Export-ADUsers"

#--UNZIP FUNCTION--
Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$outpath)

    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

#========================================================

#--CHECK FOR MODULE AND INSTALL--
If (!(Get-Module -Name "$ModuleName")) {
    Write-Host "Module does not exist. Starting import process..."

#--CREATE TEMP DIRECTORY--
if(!(Test-Path -Path $Directory)){
    Write-Host "Creating temp directory for Office files..."
    New-Item -ItemType directory -Path $Directory -ErrorAction SilentlyContinue
    Write-Host "Temp directory created." -ForegroundColor Green
}
else{
    Write-Host "Temp directory exists. Proceeding..."
}

#--DOWNLOAD MODULE--
Write-Host "Downloading AD module..."
Try {
    Invoke-WebRequest -Uri "$FileURL" -OutFile "$Output"
    Write-Host "Module downloaded successfully." -ForegroundColor Green
}
Catch {
    Write-Warning "Couldn't download module."
    Exit
}

#--EXTRACT ZIP--
Write-Host "Extracting files..."
Try {
    Unzip "$Output" "$Directory"
    Write-Host "Files extracted." -ForegroundColor Green
}
Catch {
    Write-Warning "Couldn't extract files."
}

#--IMPORT MODULE--
Write-Host "Importing module..."
Try {
    Import-Module -Name "$Directory\Export-ADUsers\Export-ADUsers\Export-ADUsers.psm1"
    Write-Host "Module imported." -ForegroundColor Green
}
Catch {
    Write-Warning "Couldn't import module."
    Exit
}
} Else {
    Write-Host "Module already exists. Exiting..." -ForegroundColor Green
}

#--CLEANUP--
Remove-Item -Path $Directory -Recurse