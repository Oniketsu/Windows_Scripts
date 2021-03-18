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
$EndDate = "2012-01-01" #Delete all mail before this date

#--ENTER EXCHANGE SHELL--
Write-Host "`nEntering Exchange shell..." -ForegroundColor Cyan
Try {
    $s = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri ('http://' + $Server + '.' + $Domain + '/PowerShell/') -Authentication Kerberos
    Import-PSSession $s -AllowClobber
}
Catch {
    Write-Warning "Couldn't enter Exchange shell."
}

#--GET MAILBOXES--
Write-Host "`nRetrieving all mailbox information..." -ForegroundColor Cyan
Try {
    $Mailboxes = Get-Mailbox -ResultSize unlimited
    Write-Host "Mailbox information retrieved." -ForegroundColor Green    
}
Catch { Write-Warning "Couldn't retrieve mailbox information." }

#--DELETE MAIL--
Foreach ($Mailbox in $Mailboxes) {
    Write-Host ("`nDeleting all mail received before " + $EndDate + " from " + $Mailbox.Name + "...") -ForegroundColor Green
    Try {
        Do {
            $Result = (Get-Mailbox -identity $Mailbox.Name | Search-Mailbox -SearchQuery ('Received<="' + $EndDate + '" OR Sent<="' + $EndDate + '"') -DeleteContent -Force)
        } Until ($Result.ResultItemsCount -eq 0)
        Write-Host ("Mail deleted from " + $Mailbox.Name + ".") -ForegroundColor Green
    }
    Catch {
        Write-Warning "Couldn't delete mail from server."
    
    }
}