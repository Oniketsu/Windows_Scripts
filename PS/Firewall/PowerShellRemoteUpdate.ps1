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

#--PREEMPTIVE VERSION CHECK--
If ($PSVersionTable.PSVersion.Major -ge 4) {
    Write-Host "PowerShell is already updated. Exiting..." -ForegroundColor Cyan
    Return
}

#--SETUP--
$Version = (gwmi Win32_OperatingSystem).caption
$FTP = "ftp://1025.techrunnerit.com/";
$User = "tr-ftp";
$Pass = "cmHJG7=bMZCYa2?i#6jNi:U}";
$Directory = "C:\techrunnerit";

#--CREATE TEMP DIRECTORY--;
Write-Host "Creating temp directory for update files..." -ForegroundColor Cyan;
if(!(Test-Path -Path $Directory)){
    New-Item -ItemType directory -Path $Directory -ErrorAction SilentlyContinue;
    Write-Host "Temp directory created." -ForegroundColor Green;
}
else{
    Write-Host "Temp directory exists. Proceeding..." -ForegroundColor Yellow;
}

$progressPreference = 'Continue';

#--DETECT VERSION--
If (($Version -like "*Windows 10*") -or ($Version -like "*Windows 8*")) {
    Write-Host "$Version detected. Configuring..." -ForegroundColor Cyan
    $FileURL = ($FTP + "/HostedFiles/Windows8-RT-KB2799888-x64.msu");
    $Output = "$Directory\Windows8-RT-KB2799888-x64.msu"
    Write-Host "Configuration for $Version successful." -ForegroundColor Green
}
Elseif ($Version -like "*Windows 7*") {
    Write-Host "$Version detected. Configuring..." -ForegroundColor Cyan
    $FileURL = ($FTP + "/HostedFiles/Windows6.1-KB2819745-x64-MultiPkg.msu");
    $Output = "$Directory\Windows6.1-KB2819745-x64-MultiPkg.msu"
    Write-Host "Configuration for $Version successful." -ForegroundColor Green
}

#--DOWNLOAD UPDATE FILES--
Write-Host "Downloading update files..." -ForegroundColor Cyan;
If (!(Test-Path -Path $Output -ErrorAction SilentlyContinue)) {
Try {
    $FTPRequest = [System.Net.FtpWebRequest]::Create("$FileURL");
    $FTPRequest = [System.Net.FtpWebRequest]$FTPRequest;
    $FTPRequest.Method = [System.Net.WebRequestMethods+Ftp]::DownloadFile;
    $FTPRequest.Credentials = new-object System.Net.NetworkCredential($User, $Pass);
    $FTPRequest.UseBinary = $true;
    $FTPRequest.UsePassive = $false;
    $FTPResponse = $FTPRequest.GetResponse() ;
    $ResponseStream = $FTPResponse.GetResponseStream();
    $LocalFileFile = New-Object IO.FileStream ($Output,[IO.FileMode]::Create);
    [byte[]]$ReadBuffer = New-Object byte[] 1024;
    	do { 
		$ReadLength = $ResponseStream.Read($ReadBuffer,0,1024);
		$LocalFileFile.Write($ReadBuffer,0,$ReadLength);
	} while ($ReadLength -ne 0)
    $LocalFileFile.Close();
    #$client.DownloadFile($FileURL, $Output);    
    $j.JobState;

    Write-Host "Update files downloaded successfully." -ForegroundColor Green;
}
Catch {
    Write-Warning "Couldn't download update files.";
}
}
Else {
    Write-Host "Files already downloaded. Proceeding..." -ForegroundColor Yellow;
}

#--INSTALL UPDATE--
#$Command = "wusa.exe '$Output' /quiet /norestart"

Write-Host "Installing update..." -ForegroundColor Cyan;
Try {
    #Invoke-Expression -Command $Command
    Start-Process -FilePath 'wusa.exe' -ArgumentList "$Output","/quiet","/norestart" -Verb RunAs -Wait -Passthru
    Write-Host "Update installed successfully." -ForegroundColor Green;
}
Catch {
    Write-Warning "Couldn't install update.";
}
