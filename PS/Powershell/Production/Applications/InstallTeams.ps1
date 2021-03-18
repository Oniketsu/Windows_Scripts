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

#--SETUP--;
$FTP = "ENTER FTP LINK";
$User = "FTP USER";
$Pass = "FTP PASSWORD";
$Directory = "C:\swk";

#--CREATE TEMP DIRECTORY--;
Write-Host "Creating temp directory for installer..." -ForegroundColor Cyan;
if(!(Test-Path -Path $Directory)){
    New-Item -ItemType directory -Path $Directory -ErrorAction SilentlyContinue;
    Write-Host "Temp directory created." -ForegroundColor Green;
}
else{
    Write-Host "Temp directory exists. Proceeding..." -ForegroundColor Yellow;
}


If ((gwmi -Class Win32_ComputerSystem).SystemType -match '(x64)') {
    $FileURL = ($FTP + "/HostedFiles/Teams_windows_x64.msi")
    $Output = "$Directory\Teams_windows_x64.msi";
    Write-Host "64-bit architecture detected. Configured." -ForegroundColor Magenta
} Else {
    $FileURL = ($FTP + "/HostedFiles/Teams_windows.msi")
    $Output = "$Directory\Teams_windows.msi";
    Write-Host "32-bit architecture detected. Configured." -ForegroundColor Magenta
}

$progressPreference = 'Continue';

#--DOWNLOAD MSI--;
Write-Host "Downloading installer..." -ForegroundColor Cyan;
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

    Write-Host "Installer downloaded successfully." -ForegroundColor Green;
}
Catch {
    Write-Warning "Couldn't download installer.";
}
} Else {
    Write-Host "Installer already downloaded. Proceeding..." -ForegroundColor Yellow;
}

#--INSTALL TEAMS--
Write-Host "Running installer..." -ForegroundColor Cyan
Try {
    Start-Process msiexec.exe -ArgumentList "/i $Output /quiet" -Wait
    Write-Host "Installer ran successfully." -ForegroundColor Green
} Catch {
    Write-Warning "Could not run installer."
}