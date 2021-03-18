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

####################################################

    #--SETUP--
    $DriverFileName = "PCL6"
    $DriverFile = ($DriverFileName + ".zip")
    $PrinterIP = "206.89.180.227"
    $PrinterPort = "9100"
    $PrinterPortName = "IP_" + $PrinterIP
    $DriverName = "HP Universal Printing PCL 6"
    $DriverPath = "C:\techrunnerit\PCL6"
    $DriverInf = "C:\techrunnerit\PCL6\hpcu215u.inf"
    $PrinterCaption = "HP LaserJet M605"
    $ComputerName = (Get-WmiObject Win32_ComputerSystem).Name

    ####################################################

    ### ComputerList Option 1 ###
    # $ComputerList = @("lana", "lisaburger")

    ### ComputerList Option 2 ###
    # $ComputerList = @()
    # Import-Csv "C:\Temp\ComputersThatNeedPrinters.csv" | `
    # % {$ComputerList += $_.Computer}

    Function CreatePrinterPort {
    $wmi = [wmiclass]"\\$ComputerName\root\cimv2:win32_tcpipPrinterPort"
    $wmi.psbase.scope.options.enablePrivileges = $true
    $Port = $wmi.createInstance()
    $Port.name = $PrinterPortName
    $Port.hostAddress = $PrinterIP
    $Port.portNumber = $PrinterPort
    $Port.SNMPEnabled = $false
    $Port.Protocol = 1
    $Port.put()
    }

    Function InstallPrinterDriver {
    $wmi = [wmiclass]"\\$ComputerName\Root\cimv2:Win32_PrinterDriver"
    $wmi.psbase.scope.options.enablePrivileges = $true
    $wmi.psbase.Scope.Options.Impersonation = `
     [System.Management.ImpersonationLevel]::Impersonate
    $Driver = $wmi.CreateInstance()
    $Driver.Name = $DriverName
    $Driver.DriverPath = $DriverPath
    $Driver.InfName = $DriverInf
    $wmi.AddPrinterDriver($Driver)
    $wmi.Put()
    }

    Function CreatePrinter {
    $wmi = ([WMIClass]"\\$ComputerName\Root\cimv2:Win32_Printer")
    $Printer = $wmi.CreateInstance()
    $Printer.CreationClassName = "Win32_Printer"
    $Printer.Caption = $PrinterCaption
    $Printer.DriverName = $DriverName
    $Printer.PortName = $PrinterPortName
    $Printer.DeviceID = $PrinterCaption
    $Printer.Put()
    }

####################################################

#--FTP SETUP--
$FTP = "ftp://1025.techrunnerit.com/"
$FileURL = ($FTP + "/HostedFiles/" + $DriverFile)
$User = "tr-ftp"
$Pass = "cmHJG7=bMZCYa2?i#6jNi:U}"
$Directory = "C:\techrunnerit"
$Output = ($Directory + "\" + $DriverFile)

#--GET DRIVER--
cls

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
If (!(Test-Path -Path $Directory\$DriverFileName -ErrorAction SilentlyContinue)) {
    Try {
        $shell = new-object -com shell.application
        $zip = $shell.NameSpace(“$Output”)
        foreach($item in $zip.items())
        {
            $shell.Namespace(“$Directory”).copyhere($item, 1564)
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
    $Drivers = Get-ChildItem -Path $Directory\$DriverFileName | Where {$_.Name -like "*.inf"}
    pnputil /add-driver $Directory\$DriverFileName\*.inf /install | Out-Null
    InstallPrinterDriver | Out-Null
    Write-Host "OK!" -ForegroundColor Green
} Catch {
    Write-Host "FAILED" -ForegroundColor Red
    Return
}

#--INSTALL PRINTER--
Start-Sleep -Milliseconds 100
Write-Host "Installing printer... " -ForegroundColor Cyan -NoNewline
Start-Sleep -Milliseconds 300

Try {
    CreatePrinter | Out-Null
    Write-Host "OK!" -ForegroundColor Green
} Catch {
    Write-Host "FAILED" -ForegroundColor Red
    $ErrorMessage = $_.Exception.Message
    $BigError = $_.Exception
    Write-Host "`n$ErrorMessage" -ForegroundColor Red
    Write-Host "`n$FailedItem" -ForegroundColor Red
}