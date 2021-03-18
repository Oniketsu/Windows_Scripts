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
$ImportPath = ("\\192.168.72.37\seagate8TB\Pre2012Mailboxes\" + $Domain)

#--ENTER EXCHANGE SHELL--
Write-Host "Entering Exchange shell..." -ForegroundColor Cyan
Try {
    $Sessions = Get-PSSession
    If (!($Sessions[0].ConfigurationName -eq "Microsoft.Exchange")) {
        $s = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri ('http://' + $Server + '.' + $Domain + '/PowerShell/') -Authentication Kerberos
        Import-PSSession $s
    } Else {
        Write-Host "Already in Exchange shell. Proceeding..." -ForegroundColor Yellow
    }
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

#--IMPORT MAILBOXES--
Foreach ($Mailbox in $Mailboxes) {
    Write-Host ("Importing contacts for mailbox " + $Mailbox.Name + "...") -ForegroundColor Cyan
    Try {
        New-MailboxImportRequest -Mailbox $Mailbox.Name -FilePath ($ImportPath + "\" + $Mailbox.Name + ".pst") -IncludeFolders "#Contacts#\*"
        New-MailboxImportRequest -Mailbox $Mailbox.Name -FilePath ($ImportPath + ".OLD\" + $Mailbox.Name + ".pst") -IncludeFolders "#Contacts#\*"
        Write-Host ("Contacts for mailbox " + $Mailbox.Name + " queued for import.") -ForegroundColor Green
    }
    Catch {
        Write-Warning ("Couldn't import mailbox " + $Mailbox.Name + ".")
    }
}