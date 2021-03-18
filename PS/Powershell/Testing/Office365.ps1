#--NOTES--
#https://support.office.com/en-us/article/Use-the-Office-2016-offline-installer-f0a85fe7-118f-41cb-a791-d59cef96ad1c?ui=en-US&rs=en-US&ad=US&fromAR=1#OfficePlans=signinorgid
#Walkthrough to run offline installer

#--SETUP--
$FileURL = "ftp://1025.techrunnerit.com/Office.zip"
$Directory = "C:\techrunnerit"
$Output = "$Directory\Office.zip"

#--CREATE TEMP DIRECTORY--
Write-Host "Creating temp directory for Office files..."
if(!(Test-Path -Path $Directory)){
    New-Item -ItemType directory -Path $Directory -ErrorAction SilentlyContinue
    Write-Host "Temp directory created." -ForegroundColor Green
}
else{
    Write-Host "Temp directory exists. Proceeding..." -ForegroundColor Yellow
}

$progressPreference = 'Continue'

#--DOWNLOAD ZIP--
Write-Host "Downloading Office files..."
If ((!(Test-Path -Path $Output -ErrorAction SilentlyContinue)) -Or (!(Get-Item $Output).length -eq 2065472621 )) {
Try {
    #$Cred = Get-Credential
    #Start-BitsTransfer $FileURL $Output -Credential "mike@techrunnerit.com"

    #$webClient = New-Object System.Net.WebClient
    #$UserAgent = "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.2; .NET CLR 1.0.3705;)"
    #$webClient.Headers.Add([System.Net.HttpRequestHeader]::UserAgent, $UserAgent)
    #$webClient.DownloadFile($FileURL, $Output) | Out-Null

    Invoke-WebRequest -Uri "$FileURL" -OutFile "$Output" | Out-Null
    #Invoke-WebRequest "$FileURL" -UseBasicParsing | Select-Object -ExpandProperty Content | Out-File "$Output"
    #--WITH CREDENTIALS--
    #Invoke-WebRequest -Uri "$FileURL" -OutFile "$Output" -Credential "username"
    
    $j.JobState

    Write-Host "Office files downloaded successfully." -ForegroundColor Green
}
Catch {
    Write-Warning "Couldn't download Office files."
}
}
Else {
    Write-Host "Files already downloaded. Proceeding..." -ForegroundColor Yellow
}

#--EXTRACT ZIP--
Write-Host "Extracting files..."
If (!(Test-Path -Path $Directory\Office -ErrorAction SilentlyContinue)) {
Try {
    $shell = new-object -com shell.application
    $zip = $shell.NameSpace(“$Output”)
    foreach($item in $zip.items())
    {
    $shell.Namespace(“$Directory”).copyhere($item)
    }
    Write-Host "Files extracted successfully." -ForegroundColor Green
}
Catch {
    Write-Warning "Couldn't extract files."
}
}
Else {
    Write-Host "Files already extracted. Proceeding..." -ForegroundColor Yellow
}

#--INSTALL OFFICE--
$Command = "$Directory\Office\setup.exe /configure $Directory\Office\configuration.xml"

Write-Host "Installing Office..."
Try {
    Invoke-Expression -Command $Command | Out-Null
    Write-Host "Office installer ran successfully." -ForegroundColor Green
}
Catch {
    Write-Warning "Couldn't install Office."
}