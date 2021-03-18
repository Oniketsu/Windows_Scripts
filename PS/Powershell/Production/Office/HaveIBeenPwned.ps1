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

#--CHECK HAVEIBEEPWNED--
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Connect-MsolService

$CompanyName = (Get-MsolCompanyInformation).DisplayName -replace '\s',''
$Path = "c:\techrunnerit\haveibeenpwned"
$CsvPath = "$Path\$CompanyName.csv"
If ((Test-Path -Path $Path) -eq $false) {
    New-Item -Path $Path -ItemType Directory
}

If ((Test-Path -Path $CsvPath) -eq $true) {
    Remove-Item -Path $CsvPath -Force
}

$headers = @{
    "User-Agent"  = "$((Get-MsolCompanyInformation).DisplayName) Customer Account Check"
    "api-version" = 2
}
$baseUri = "https://haveibeenpwned.com/api"
$users = Get-msoluser -All
  
foreach ($user in $users) {
    $emails = $user.proxyaddresses | Where-Object {$_ -match "smtp:" -and $_ -notmatch ".onmicrosoft.com"}
    $emails | ForEach-Object {
        $email = ($_ -split ":")[1]
        $uriEncodeEmail = [uri]::EscapeDataString($email)
        $uri = "$baseUri/breachedaccount/$uriEncodeEmail"
        $breachResult = $null
        try {
            [array]$breachResult = Invoke-RestMethod -Uri $uri -Headers $headers -ErrorAction SilentlyContinue
        }
        catch {
            if($error[0].Exception.response.StatusCode -match "NotFound"){
                Write-Host "No Breach detected for $email" -ForegroundColor Green
            }else{
                Write-Host "Cannot retrieve results due to rate limiting or suspect IP. You may need to try a different computer"
            }
        }
        if ($breachResult) {
            foreach ($breach in $breachResult) {
                $breachObject = [ordered]@{
                    Email              = $email
                    UserPrincipalName  = $user.UserPrincipalName
                    LastPasswordChange = $user.LastPasswordChangeTimestamp
                    BreachName         = $breach.Name
                    BreachTitle        = $breach.Title
                    BreachDate         = $breach.BreachDate
                    BreachAdded        = $breach.AddedDate
                    BreachDescription  = $breach.Description
                    BreachDataClasses  = ($breach.dataclasses -join ", ")
                    IsVerified         = $breach.IsVerified
                    IsFabricated       = $breach.IsFabricated
                    IsActive           = $breach.IsActive
                    IsRetired          = $breach.IsRetired
                    IsSpamList         = $breach.IsSpamList
                }
                $breachObject = New-Object PSobject -Property $breachObject
                $breachObject | Export-csv $CsvPath -NoTypeInformation -Append
                Write-Host "Breach detected for $email - $($breach.name)" -ForegroundColor Yellow
                Write-Host $breach.description -ForegroundColor DarkYellow
            }
        }
        Start-sleep -Milliseconds 2000
    }
}

Write-Host "`n"

#--GET DATE--
$CurrentDate = Get-Date -DisplayHint Date

#--CHECK AGAINST CSV--
$Csv = [System.Collections.ArrayList](Import-Csv -Path $CsvPath)
$SentPath = ($Path + "\" + $CompanyName + "Sent.csv")
Clear-Variable "Index" -ErrorAction SilentlyContinue
$Index = New-Object System.Collections.ArrayList

If ((Test-Path -Path $SentPath -ErrorAction SilentlyContinue) -eq $true) {
    [System.Collections.ArrayList]$SentCsv = (Import-Csv -Path $SentPath)
    Foreach ($SentEntry in $SentCsv) {
        Foreach ($Entry in $Csv) {
            If (($Entry.Email -like $SentEntry.Email) -and ($Entry.BreachName -like $SentEntry.BreachName)) {
                [void]$Index.Add($Csv.IndexOf($Entry))
                Write-Host "$($Entry.BreachName) for $($Entry.Email) already sent; disregarding." -ForegroundColor Green
            }
        }
    }
    $Index = $Index | sort -Descending
    Foreach ($IndexEntry in $Index) {
        $Csv.RemoveAt($IndexEntry)
    }
}

Foreach ($Entry in $Csv){
    If (($Entry.BreachDataClasses -like "*Passwords*") -and ($Entry.IsVerified -like "TRUE")){
        $EntryDate = [DateTime]($Entry.BreachAdded).Substring(0,10)
        $BreachDate = [DateTime]($Entry.BreachDate)
        $Days = (New-TimeSpan -Start $EntryDate -End $CurrentDate).Days
        Write-Host "`n$($Entry.Email): $($Entry.BreachName)" -ForegroundColor Cyan
        Write-Host $EntryDate -ForegroundColor Cyan
        
        #--OLDER THAN 30 DAYS?--
        #If ($Days -ge 31){
        #    Write-Host "Older than 30 days." -ForegroundColor Red
        #} Else {
        #    Write-Host "Newer than 30 days." -ForegroundColor Green
        #}
        
        #--EMAIL REPORT PREP--
        $Email = "themailman@techrunnerit.com"
        $Password = "KdaKh=P18Gtp2uW"
        $Password | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File "C:\techrunnerit\pass.txt"
        $Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Email, (Get-Content "C:\techrunnerit\pass.txt" | ConvertTo-SecureString)

        #--GENERATE MESSAGE--
$mailBody =
"This is an automated message from TechRunner IT.<br><br>
There was a recently discovered data breach ($($Entry.BreachTitle)), and the email address $($Entry.Email) was included in a list of compromised accounts.<br>
The breach occurred on $($BreachDate.ToShortDateString()), and it was discovered on $($EntryDate.ToShortDateString()).<br><br>
Here is some information about the breach:<br><br>
<div style='margin-left: 40px'><font color='dimgray'>$($Entry.BreachDescription)<br><br>
Compromised data: $($Entry.BreachDataClasses)</font></div><br><br>
-<b><font color='darkslategray'>Tech</font><font color='steelblue'>Runner</font> IT</b>"
        
        #--SEND EMAIL--
        Try {
        Write-Host "Sending email..." -ForegroundColor Cyan
        #$mailBody
        Send-MailMessage -Body $mailBody -BodyAsHtml -From $Email -To "itmail@techrunnerit.com" -Subject "Account(s) Breached" -Encoding $([System.Text.Encoding]::UTF8) -Credential $Credentials -SmtpServer "smtp.office365.com" -Port 587 -UseSsl | Out-Null
        $Entry | Export-csv $SentPath -NoTypeInformation -Append
        Write-Host "Email sent successfully." -ForegroundColor Green
        }
        Catch {
        Write-Warning "Couldn't send email."
        }
    } Else {
        Continue
    }
}
