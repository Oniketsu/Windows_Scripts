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
$FTP = "FTP_IP";
$FileURL = ($FTP + "/HostedFiles/Office.zip");
$User = "tr-ftp";
$Pass = "";
$Directory = "C:\techrunnerit";
$Output = "$Directory\Office.zip";

#--CREATE TEMP DIRECTORY--;
Write-Host "Creating temp directory... " -ForegroundColor Cyan -NoNewline;
if(!(Test-Path -Path $Directory)){
    New-Item -ItemType directory -Path $Directory -ErrorAction SilentlyContinue;
    Write-Host "OK!" -ForegroundColor Green;
}
else{
    Write-Host "ALREADY EXISTS" -ForegroundColor Yellow;
}


#--DOWNLOAD ZIP--;
Write-Host "Downloading files... " -ForegroundColor Cyan -NoNewline;
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

    Write-Host "OK!" -ForegroundColor Green;
}
Catch {
    Write-Host "FAILED" -ForegroundColor Red;
}
}
Else {
    Write-Host "ALREADY EXISTS" -ForegroundColor Yellow;
}
