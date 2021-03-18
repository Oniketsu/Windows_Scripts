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
$Path = "c:\techrunnerit"

If (!(Test-Path $Path)) {
    New-Object -ItemType Directory -Path $Path
}

Try {
    $Creds = Get-Credential -Message "Enter Office 365 admin credentials."
} Catch {
    Write-Warning "Couldn't get credentials. Exiting..."
    Return
}

#--ENTER EXCHANGE SHELL--
Write-Host "`nEntering Exchange shell..." -ForegroundColor Cyan
Try {
    $s = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell -Credential $Creds -Authentication Basic -AllowRedirection
    Import-PSSession $s -AllowClobber
}
Catch {
    Write-Warning "Couldn't enter Exchange shell."
}

Connect-MsolService -Credential $Creds

$Domain = Get-MsolDomain | Where {$_.IsDefault -eq $true}


#--GET TRANSPORT RULE INFORMATION--
Write-Host "`nGetting redirection rule information..." -ForegroundColor Cyan
$Redirection = Get-TransportRule | Select -Property Name,Description
#Where {$_.Description -like '*Redirect*'} | 
If ($Redirection -eq $null) {
    Write-Host "No redirection rules found." -ForegroundColor Green
} Else {
    Write-Host ("Redirection rules found.") -ForegroundColor Yellow
    $RdrPath = ($Path + "\" + $Domain.Name + "_MailFlowRules.csv")
    $Redirection | Export-Csv -Path $RdrPath | Out-Null
    Write-Host ("Redirection report written to: " + $RdrPath) -ForegroundColor Green
}


#--GET FORWARDING INFORMATION--
Write-Host "`nGetting forwarding rule information..." -ForegroundColor Cyan
$Forwarding = Get-Mailbox | Select UserPrincipalName,ForwardingSmtpAddress,DeliverToMailboxAndForward
If ($Forwarding -eq $null) {
    Write-Host "No forwarding rules found." -ForegroundColor Green
} Else {
    Write-Host ("Forwarding rules found.") -ForegroundColor Yellow
    $FwdPath = ($Path + "\" + $Domain.Name + "_Forwarding.csv")
    $Forwarding | Export-Csv -Path $FwdPath | Out-Null
    Write-Host ("Forwarding report written to: " + $FwdPath) -ForegroundColor Green
}