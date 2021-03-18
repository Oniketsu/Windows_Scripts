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
$FTP = "ftp://173.15.137.212/";
$User = "ftp_user";
$Pass = "2Bu3XWDvE2ZxrNV4";
$Directory = "C:\SWK\Installs";

#--Roar Info--;
$RoarURL = 'swktech.app.liongard.com'
$RoarAccessKey = "a3e4ced5dce5d7cbf7a3"
$RoarAccessSecret = "e5707d99243e7a73bd4abf608ba5e960afb247e114a64043809b8c6309fe2b74"
$InstallerName = "RoarAgent.msi"
$DebugLog = Join-Path $Env:TMP RoarDebug.log
$MsiLog = Join-Path $Env:TMP RoarInstall.log
$AgentName = $env:computername
#$InstallerPath = Join-Path $Directory $InstallerName

function Get-TimeStamp {
    return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)   
}

#--CREATE TEMP DIRECTORY--;
function Create-Dir{
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
}
#--DOWNLOAD MSI--;
function Download-MSI{
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
}
#
function Install-Roar {
   
    $RoarArgs = "ROARURL=" + $RoarURL + " ROARACCESSKEY=" + $RoarAccessKey + " ROARACCESSSECRET=" + $RoarAccessSecret + " ROARAGENTNAME=" + "`"$AgentName`""
    

    $InstallArgs = @(
        "/i"
        "`"$Output`""
        $RoarArgs
        "/qn"
        "/L*V"
        "`"$MsiLog`""
        "/norestart"
    )

    Start-Process msiexec.exe -ArgumentList $InstallArgs -Wait -PassThru
}


#--INSTALL ROAR Agent--
function main{
    Write-Host "Running installer..." -ForegroundColor Cyan
    If (!(Get-Service "Roar Agent" -ErrorAction SilentlyContinue)) {
        Create-Dir
       Download-MSI
      Install-Roar
      Write-Host "Installer ran successfully." -ForegroundColor Green
    } Else {
        Write-Warning "Could not run installer."
    }
}
main