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
$baseurl = 'https://unifi.techrunnerit.com:8443'
$username = 'techrunnerit'
$password = 'Mk7CgB_-KIBwDQm1_=f'
$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$useragent = [Microsoft.PowerShell.Commands.PSUserAgent]::Chrome

#--SITES--

$sites = @(
"lwff4dak", #A&C Pest Management
"mv1cmbd0", #All Island Hardwood
"hu566udh", #Axletek
"6h72vorf", #Chasanoff Properties
"default",  #Default
"soiba8yi", #Diamond Finance
"ndzbsqy2", #Ditmars Real Estate
"fixu5m07", #Function Physical Therapy
"x9kz39qg", #Handyside
"lefm3u3o", #Herrick Stamp
"2ddtlfj2", #Marshall Kopelman CPA
"obsc-hh",  #Oyster Bay Harbor House
"obsc-obm", #Oyster Bay Manor
"lak8tdez", #Onyx - 900 Stewart
"6yn5udbr", #Onyx - 990 Stewart
"0ckbapzc", #Onyx - Jericho Plaza
"eors01iu", #Source One Packaging
"tl0nt7sr", #Suffolk County Brake Service
"tvy90ief", #TechRunner IT - Office
"rf2zx712", #Truck King - 2nd Ave
"zjsptj3o", #Truck King - Maspeth
"0tj7ui9j", #Truck King - Newark, NJ
"8f5fbop7", #Truck King - Ronkonkoma
"8fa8bg8l", #Truck King - West Babylon
"jz3oedb0" #ZacMel Graphics
)


#--IGNORE SSL ERRORS--
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }

#--TLS12--
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#--LOGIN TO UNIFI CONTROLLER--
$postparams = ConvertTo-Json -InputObject @{username=$username;password=$password}
$result = Invoke-WebRequest -Uri "$($baseurl)/api/login" -ContentType "application/json" -Method POST -Body $postparams -SessionVariable session -UserAgent $useragent -UseBasicParsing
$loginsuccess = ConvertFrom-Json -InputObject $result.Content
if( $loginsuccess.meta.rc -ne "ok" ) {
    Write-Warning "Unable to login to UniFi Controller. $($result.RawContent)"
}

#--FOREACH SITE--
ForEach ( $site in $sites ) {
    
    #--RESET COUNTERS--
    $onlinecount=0
    $offlinecount=0


    Write-Host "`nGetting list of devices from $site..." -ForegroundColor Cyan
    #--GET DEVICE STATUS--

    $result2 = Invoke-WebRequest -Uri "$($baseurl)/api/s/$($site)/stat/device" -Method POST -Body "" -WebSession $session -UserAgent $useragent -UseBasicParsing 
    $status = ConvertFrom-Json -InputObject $result2.Content
    if( $status.meta.rc -ne "ok" ) {
        Write-Warning "Unable to retrieve UniFi device status for $site. $($result2.RawContent)"
    }

    # Loop through each device and output it's status
    ForEach ( $ap in $status.data ) {

        # Formatting for NAME
        if( [string]::IsNullOrEmpty($ap.name) ) {
            $apname = "(no name)"
        } else {
            $apname = $ap.name
        }

        # Formatting for Model
        $apmodel = "$($ap.type) $($ap.model)"

        # Format the status line
        $statusline = "$($apmodel) - $($ap.ip.PadRight(15)) ($($ap.mac.PadRight(17))) - v$($ap.version.PadRight(13)) - $($apname) "
               
        #--CHECK IF ONLINE--
        If( $ap.state -eq 1 ) {
            # Device is online
            $onlinecount++
            Write-Host "`nONLINE: $statusline" -ForegroundColor Green
        } Else {
            # Device is offline
            $offlinecount++
            Write-Host "`nOFFLINE: $statusline" -ForegroundColor Red
        }

        #--UPGRADE IF ABLE--
        If( $ap.upgradable -eq "True" ) {
            Write-Host "OUT OF DATE: Upgrade available for $apname. Queueing..." -ForegroundColor Yellow
            $cmd = @"
            {
            "cmd":"upgrade",
            "mac":"$($ap.mac)"
            }
"@
            $upgrade = Invoke-RestMethod -Uri "$($baseurl)/api/s/$($site)/cmd/devmgr" -Method Post -Body $cmd -WebSession $session -ErrorAction SilentlyContinue
        } Else {
            Write-Host "UP TO DATE: No upgrades available for $apname." -ForegroundColor Green
        }

    }

    #--DISPLAY STATUS--
    If( ($offlinecount -eq 0) -and ($onlinecount -eq 0) ) {
        Write-Warning [System.Exception] "ERROR: No UniFi devices found at $site. Is site name or request parameters wrong?"
    } ElseIf( $offlinecount -gt 0 ) {
        Write-Warning "`nSome UniFi devices at $site are OFFLINE."
    } Else {
        Write-Host "`nOKAY: All UniFi devices at $site appear to be ONLINE." -ForegroundColor Green
    }

    Write-Host "End of site $site." -ForegroundColor Cyan
}