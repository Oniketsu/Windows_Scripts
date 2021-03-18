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
$Printers = [System.Collections.ArrayList]@()

#--GET TCP/IP AND WSD PRINTERS--
Write-Host "Finding printers..." -ForegroundColor Cyan
$Ports = Get-PrinterPort | Where {($_.Description -eq 'Standard TCP/IP Port') -or ($_.Description -eq 'WSD Port')} | Select -Property Name,Description

Foreach ($Port in $Ports) {
    $i = 0
    If (Get-Printer | Where {$_.PortName -like $Port.Name} | Select -Property Name,PortName) {    
        $Printers.Add((Get-Printer | Where {$_.PortName -like $Port.Name} | Select -Property Name,PortName)) | Out-Null
        Write-Host ("Found printer named " + $Printers[$i].Name + ".") -ForegroundColor Yellow
    }
    Foreach ($Printer in $Printers) {
        If ($Printer.PortName -like $Port.Name) {
            $Printers[$i] | Add-Member -Type NoteProperty -Name "PortType" -Value $Port.Description
        }
        $i++
    }
}

#--REMOVE PORTS AND PRINTERS--
If ($Printers.count -eq 0) {
    Write-Host "`nNo removable printers found on system." -ForegroundColor Green
    Return
} Else {
    Write-Host "`nBeginning printer removal..." -ForegroundColor Magenta
}

Foreach ($Printer in $Printers) {
    Write-Host ("`nRemoving printer " + $Printer.Name + "...") -ForegroundColor Cyan
    Try {
        Remove-Printer -Name $Printer.Name -ErrorAction SilentlyContinue
        Write-Host ("Removed printer " + $Printer.Name + " successfully.") -ForegroundColor Green
    } Catch {
        Write-Warning ("Couldn't remove printer " + $Printer.Name + ".")
    }

    Write-Host ("Removing port " + $Printer.PortName + " (" + $Printer.Name + ")...") -ForegroundColor Cyan
    Try {
        Remove-PrinterPort -Name $Printer.PortName -ErrorAction SilentlyContinue
        Write-Host ("Removed port " + $Printer.PortName + " successfully.") -ForegroundColor Green
    } Catch {
        Write-Warning ("Couldn't remove port " + $Printer.PortName + ".")
    }
}

#--REPORT BACK IF NOTHING FOUND--

#--GET PRINTER IP'S-
#gwmi Win32_Printer | %{ $printer = $_.Name; $port = $_.portname; gwmi Win32_TCPIPPrinterPort | where { $_.Name -eq $port } | select @{name="PrinterName";expression={$Printer}}, HostAddress }
