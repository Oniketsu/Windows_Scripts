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
$Model = "ADP Laser"
$ModelName = "ADP Laser"
$PortName = ("TCPPort:" + $Address)
$Address = "10.25.0.21"
$DriverName = "PCL6"
$DriverFullName = "HP Universal PCL6"
$DriverFile = ($DriverName + ".zip")

#--FTP SETUP--
$FTP = "FTP_IP"
$FileURL = ($FTP + "/HostedFiles/" + $DriverFile)
$User = "tr-ftp"
$Pass = "user_pass"
$Directory = "C:\techrunnerit"
$Output = ($Directory + "\" + $DriverFile)

#--GET DRIVER--
cls

Start-Sleep -Milliseconds 100
Write-Host "Checking for driver... " -ForegroundColor Cyan -NoNewline
Start-Sleep -Milliseconds 300
#$GotDriver = Get-PrinterDriver | Where {$_.Name -like "*$Model*"}
Clear-Variable "GotDriver"

If ($GotDriver -eq $Null) {
    Write-Host "DOWNLOAD REQUIRED" -ForegroundColor Yellow
} Else {
    Write-Host "OK!" -ForegroundColor Green
}

If ($GotDriver -eq $Null) {
    #--DOWNLOAD ZIP--
    Start-Sleep -Milliseconds 100
    Write-Host "Downloading driver... " -ForegroundColor Cyan -NoNewline
    Start-Sleep -Milliseconds 300
    If (!(Test-Path -Path $Output -ErrorAction SilentlyContinue)) {
    Try {
        $FTPRequest = [System.Net.FtpWebRequest]::Create("$FileURL")
        $FTPRequest = [System.Net.FtpWebRequest]$FTPRequest
        $FTPRequest.Method = [System.Net.WebRequestMethods+Ftp]::DownloadFile
        $FTPRequest.Credentials = new-object System.Net.NetworkCredential($User, $Pass)
        $FTPRequest.UseBinary = $true
        $FTPRequest.UsePassive = $false
        $FTPResponse = $FTPRequest.GetResponse() 
        $ResponseStream = $FTPResponse.GetResponseStream()
        $LocalFileFile = New-Object IO.FileStream ($Output,[IO.FileMode]::Create)
        [byte[]]$ReadBuffer = New-Object byte[] 1024
    	    do { 
		    $ReadLength = $ResponseStream.Read($ReadBuffer,0,1024)
		    $LocalFileFile.Write($ReadBuffer,0,$ReadLength)
	    } while ($ReadLength -ne 0)
        $LocalFileFile.Close()
        #$client.DownloadFile($FileURL, $Output)    
        $j.JobState

        Write-Host "OK!" -ForegroundColor Green
    }
    Catch {
        Write-Host "FAILED" -ForegroundColor Red
        Return
    }
    }
    Else {
        Write-Host "ALREADY EXISTS" -ForegroundColor Yellow
    }

    #--EXTRACT ZIP--
    Start-Sleep -Milliseconds 100
    Write-Host "Extracting files... " -ForegroundColor Cyan -NoNewline
    Start-Sleep -Milliseconds 300
    If (!(Test-Path -Path $Directory\$DriverName -ErrorAction SilentlyContinue)) {
    Try {
        $shell = new-object -com shell.application
        $zip = $shell.NameSpace(“$Output”)
        foreach($item in $zip.items())
        {
            $shell.Namespace(“$Directory”).copyhere($item)
        }
        Write-Host "OK!" -ForegroundColor Green
    }
    Catch {
        Write-Host "FAILED" -ForegroundColor Red
        Return
    }
    }
    Else {
        Write-Host "ALREADY EXIST" -ForegroundColor Yellow
    }

    #--INSTALL DRIVER--
    Start-Sleep -Milliseconds 100
    Write-Host "Installing driver... " -ForegroundColor Cyan -NoNewline
    Start-Sleep -Milliseconds 300

    Try {
        pnputil /add-driver $Directory\$DriverName\*.inf /install
        $Drivers = Get-ChildItem -Path $Directory\$DriverName | Where {$_.Name -like "*.inf"}
        $Driver = Get-WindowsDriver -Online -All | Where {$_.Name -like $($Drivers[0]).Name}
        #Foreach ($Driver in $Drivers) {
        #    
        #}
        Write-Host "OK!" -ForegroundColor Green
    } Catch {
        Write-Host "FAILED" -ForegroundColor Red
        Return
    }
}

#--SET PORT--
Start-Sleep -Milliseconds 100
Write-Host "Adding port... " -ForegroundColor Cyan -NoNewline
Start-Sleep -Milliseconds 300
If ((Get-PrinterPort -Name $PortName -ErrorAction SilentlyContinue).PrinterHostAddress -eq $Address) {
    Write-Host "ALREADY EXISTS" -ForegroundColor Yellow
} Else {
    Add-PrinterPort -Name $PortName -PrinterHostAddress $Address
    Write-Host "OK!" -ForegroundColor Green
}

#--ADD PRINTER--
Start-Sleep -Milliseconds 100
Write-Host "Adding printer... " -ForegroundColor Cyan -NoNewline
Start-Sleep -Milliseconds 300
Add-Printer -DriverName $($GotDriver.Name) -Name $ModelName -PortName $($PortName)
Write-Host "OK!" -ForegroundColor Green