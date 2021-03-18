$Directory = "\temp\AD"
$Email = "mike@techrunnerit.com"
$InactiveUsers = Import-Csv -Path "$Directory\OLD_User.csv" | ConvertTo-Html -Fragment
$InactiveComps = Import-Csv -Path "$Directory\OLD_Computer.csv" | ConvertTo-Html -Fragment

$mailBody =
"Inactive Users:<br><br>
$InactiveUsers<br><br>
Inactive Computers:<br><br>
$InactiveComps"

Send-MailMessage -Body $mailBody -BodyAsHtml -From $Email -To $Email -Subject "Inactive Users/Computers" -Encoding $([System.Text.Encoding]::UTF8) -Credential $(Get-Credential) -SmtpServer "smtp.office365.com" -Port 587 -UseSsl