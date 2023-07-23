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
$FTP = "ftp://172.16.210.50/";
$User = "ftp_user";
$Pass = "$Password";
$Directory = "C:\SWK\Installs";

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
    $FileURL = ($FTP + "/RoarAgent.msi")
    $Output = "$Directory\RoarAgent.msi";
    Write-Host "64-bit architecture detected. Configured." -ForegroundColor Magenta
} Else {
    $FileURL = ($FTP + "/RoarAgent.msi")
    $Output = "$Directory\RoarAgent.msi";
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

#--INSTALL ROAR Agent--
Write-Host "Running installer..." -ForegroundColor Cyan
Try {
  #  Start-Process msiexec.exe -ArgumentList "/i $Output /quiet" -Wait
  $Output = "$Directory\RoarAgent.msi"
  msiexec /i $Output ROARURL=swktech.app.liongard.com ROARACCESSKEY=99a804fb302c0a9b847b ROARACCESSSECRET=5ea3dda0c378780a476e59aaa2f3c829edaf192b64cfca8069d05fe67ff4ba20 /qn
  Write-Host "Installer ran successfully." -ForegroundColor Green
} Catch {
    Write-Warning "Could not run installer."
}