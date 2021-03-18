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
$Server = (Get-WmiObject Win32_ComputerSystem).Name
$Domain = (Get-WmiObject Win32_ComputerSystem).Domain
$EndDate = "2012-01-01"
$ExportPath = "C:\techrunnerit"
$ExportFile = ($Server + ".csv")

#--ENTER EXCHANGE SHELL--
Write-Host "Entering Exchange shell..." -ForegroundColor Cyan
Try {
    $s = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri ('http://' + $Server + '.' + $Domain + '/PowerShell/') -Authentication Kerberos
    Import-PSSession $s
    Write-Host "Entered Exchange shell." -ForegroundColor Green
}
Catch {
    Write-Warning "Couldn't enter Exchange shell. Exiting..."
    Return
}

#--GET MAILBOXES--
Write-Host "Retrieving all mailbox information..." -ForegroundColor Cyan
Try {
    $Mailboxes = Get-Mailbox -ResultSize unlimited
    Write-Host "Mailbox information retrieved." -ForegroundColor Green    
}
Catch { Write-Warning "Couldn't retrieve mailbox information." }


#--EXPORT MAILBOXES--
Foreach ($Mailbox in $Mailboxes) {
    Write-Host ("Exporting mailbox " + $Mailbox.Name + "...") -ForegroundColor Cyan
    Try {
        #New-MailboxExportRequest -Mailbox $Mailbox.Name -ContentFilter {(Received -lt $EndDate)} -FilePath ($ExportPath + '\' + $ExportFile)
        Write-Host ("Mailbox " + $Mailbox.Name + " exported.") -ForegroundColor Green
    }
    Catch {
        Write-Warning ("Couldn't export mailbox " + $Mailbox.Name + ".")
    }
}