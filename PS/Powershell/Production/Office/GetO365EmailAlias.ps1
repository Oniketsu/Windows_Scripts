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
$Directory = "c:\techrunnerit"
Try {
    $Creds = Get-Credential -Message "Enter Office 365 admin credentials."
} Catch {
    Write-Warning "Couldn't get credentials. Exiting..."
    Return
}

If (!(Get-Module -ListAvailable -Name "MSOnline")) {
    Write-Host "Getting MSOnline module..." -ForegroundColor Cyan
    Install-Module MsOnline -Force
    Write-Host "Installed MSOnline module." -ForegroundColor Green
} Else { Write-Host "No need to install MSOnline module; already present." -ForegroundColor Yellow }

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

#--GET MAILBOXES--
$Domain = (Get-MsolDomain)[0].Name
$FilePath = ($Directory + "\" + $Domain + "_EmailAlias.csv")

$Mailboxes = Get-Mailbox | Where {$_.Name -notlike '*DiscoverySearchMailbox*'} | Select Name,DisplayName,Alias,PrimarySmtpAddress,EmailAddresses

#--CREATE CSV REPORT--
Write-Host "`nPreparing .CSV report..." -ForegroundColor Cyan
$Mailboxes | Export-Csv "$FilePath" -notypeinformation
Write-Host "Report exported to: $FilePath" -ForegroundColor Green

#--EMAIL--
Write-Host "`nPreparing email..." -ForegroundColor Cyan
$Output = Import-Csv -Path "$FilePath" | ConvertTo-Html -Fragment
$Email = "themailman@techrunnerit.com"
$Password = "user_pass" | ConvertTo-SecureString -AsPlainText -Force

$EmailCreds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Email, $Password

$MailBody =
"Email Addresses and Aliases:<br><br>
$Output"

Try {
    Write-Host "Sending email report..." -ForegroundColor Cyan
    Send-MailMessage -Body $MailBody -BodyAsHtml -From $Email -To "itmail@techrunnerit.com" -Subject "Email Addresses - $Domain" -Attachments "$FilePath" -Encoding $([System.Text.Encoding]::UTF8) -Credential $EmailCreds -SmtpServer "smtp.office365.com" -Port 587 -UseSsl | Out-Null
    Write-Host "Email report sent successfully to: itmail@techrunnerit.com" -ForegroundColor Green
}
Catch {
    Write-Warning "Couldn't send email report."
}

#--EXIT EXCHANGE SHELL--
Write-Host "`nExiting Exchange shell..." -ForegroundColor Cyan
Try {
    Remove-PSSession -Session $s
    Write-Host "Exited Exchange shell." -ForegroundColor Green
} Catch {
    Write-Warning "Couldn't exit Exchange shell."
}