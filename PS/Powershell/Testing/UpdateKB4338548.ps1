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
$FTP = "ftp://1025.techrunnerit.com";
$FileName = "windows10.0-kb4338548-x64_03a08a477b154e6206d42116f9a0efcfafa53f0e.msu"
$FileURL = ($FTP + "/HostedFiles/" + $FileName);
$User = "tr-ftp";
$Pass = "user_pass";
$Directory = "C:\techrunnerit";
$Output = ("$Directory\" + $FileName);
$UpdateVer = "KB4338548";
$progressPreference = 'Continue';

#--CREATE TEMP DIRECTORY--;
Write-Host "Checking for $Directory..." -ForegroundColor Cyan;
if(!(Test-Path -Path $Directory)){
    New-Item -ItemType directory -Path $Directory -ErrorAction SilentlyContinue;
    Write-Host "$Directory created." -ForegroundColor Green;
}
else{
    Write-Host "$Directory exists. Proceeding..." -ForegroundColor Yellow;
}

#--DOWNLOAD UPDATE--;
Write-Host "Downloading $UpdateVer installer..." -ForegroundColor Cyan;
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

    Write-Host "Update file downloaded successfully." -ForegroundColor Green;
}
Catch {
    Write-Warning "Couldn't download update file.";
}
}
Else {
    Write-Host "File already downloaded. Proceeding..." -ForegroundColor Yellow;
}

#--INSTALL UPDATE--;
$Command = "wusa.exe $Output /quiet /norestart";

Write-Host "Installing update $UpdateVer..." -ForegroundColor Cyan;
Try {
    Invoke-Expression -Command $Command;
    Write-Host "Update installer ran successfully." -ForegroundColor Green;
}
Catch {
    Write-Warning "Couldn't install update.";
}

#############################################################################
#End
############################################################################# 