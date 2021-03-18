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

$ErrorActionPreference = "SilentlyContinue"

#--BUILD APP LIST--
$AppList = @(
    #--MICROSOFT--
    "*BingFinance*"
    "*BingNews*"
    "*BingSports*"
    "*BingWeather*"
    "*BingTravel*"
    "*OfficeHub*"
    "*Office.Desktop*"
    "*Office.Sway*"
    "*Office.OneNote*"
    #"*Zune*"
    "*WindowsPhone*"
    "*Xbox*"
    "*NetworkSpeedTest*"
    "*Getstarted*"
    "*3DBuilder*"
    "*SkypeApp*"
    "*windowscommunicationsapps*"
    "*WindowsAlarms*"
    "*Microsoft.People*"
    "*FeedbackHub*"
    "*Microsoft.Wallet*"
    "*Microsoft.OneConnect*"
    "*Microsoft.MSPaint*"

    #--DELL--
    "*Dell*"

    #--GAMES--
    "*Games*"
    "*Minecraft*"
    "*BubbleWitch*"
    "*CandyCrush*"
    "*Slots*"
    "*Casino*"
    "*Racing*"
    "*Empires*"
    "*Crossword*"
    "*Disney*"

    #--ENTERTAINMENT--
    "*Entertainment*"
    "*Plex*"
    "*Netflix*"
    "*Spotify*"
    "*Pandora*"
    "*Radio*"
    "*Shazam*"

    #--SOCIAL--
    "*Facebook*"
    "*Twitter*"
    "*LinkedIn*"

    #--MISCELLANEOUS--
    "*Wunderlist*"
    "*Duolingo*"
    "*Autodesk*"
    "*Flipboard*"
    "*Drawboard*"
    "*Sketch*"
    "*CyberLink*"
    "*PhotoshopExpress*"
    "*Actipro*"
    "*Eclipse*"
)

#--SCAN FOR APPS--
cls
Start-Sleep -Milliseconds 200
Write-Host "Scanning for apps and programs (this may take a while)..." -ForegroundColor Cyan -NoNewline

$GotAppxPack = [System.Collections.ArrayList]@()
$GotAppxProvPack = [System.Collections.ArrayList]@()
$GotWmiObject = [System.Collections.ArrayList]@()

$WmiList = Get-WmiObject -Class Win32_Product
$Count = 0

Foreach ($App in $AppList) {
    $FoundAppxProvPack = Get-AppxProvisionedPackage -Online | Where DisplayName -like $App
    $FoundAppxPack = Get-AppxPackage -AllUsers | Where Name -like $App
    $FoundWmiObject = $WmiList | Where {$_.Name -like $App}
    If ($FoundAppxProvPack -ne $null) {
        $FoundAppxProvPack | %{$GotAppxProvPack.Add($_)} | Out-Null
    }
    If ($FoundAppxPack -ne $null) {
        $FoundAppxPack | %{$GotAppxPack.Add($_)} | Out-Null
    }
    If ($FoundWmiObject -ne $null) {
        $FoundWmiObject | %{$GotWmiObject.Add($_)} | Out-Null
    }
}

Write-Host " OK!" -ForegroundColor Green
Start-Sleep -s 1

#--CHECK IF RESULTS EMPTY--
If (($GotAppxPack.Count -eq 0) -and ($GotAppxProvPack -eq 0) -and ($GotWmiObject.Count -eq 0)) {
    Write-Host "`nNo apps found. Exiting..." -ForegroundColor Green
    Start-Sleep -s 5
    Return
}

#--REMOVE APPS--
If ($GotAppxProvPack.Count -ne 0) {
    Foreach ($AppxProvPack in $GotAppxProvPack) {
        #Check if app still exists
        Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Where DisplayName -like $AppxProvPack.DisplayName | Out-Null
        If ($? -eq $False) {Continue}

        $Count++
        Write-Host ("`nFound provisioned app " + $AppxProvPack.DisplayName + ". Removing...") -ForegroundColor Cyan -NoNewline
        $AppxProvPack | Remove-AppxProvisionedPackage -Online -ErrorVariable Errs | Out-Null
        If ($Errs.Count -eq 0) {
            Write-Host (" OK!") -ForegroundColor Green
        } Else {
            Write-Host (" FAILED") -ForegroundColor Red
            Write-Host "Reason: " -ForegroundColor Yellow -NoNewline
            Write-Host $Errs.Message -ForegroundColor Red
            #Clear-Variable "Errs"
        }
    }
}
If ($GotAppxPack.Count -ne 0) {
    Foreach ($AppxPack in $GotAppxPack) {
        #Check if app still exists
        Get-AppxPackage -AllUsers -ErrorAction SilentlyContinue | Where Name -like $AppxPack.Name | Out-Null
        If ($? -eq $False) {Continue}
        Get-AppxProvisionedPackage -AllUsers -ErrorAction SilentlyContinue | Where Name -like $AppxPack.Name | Out-Null
        If ($? -eq $False) {Continue}

        $Count++
        Write-Host ("`nFound app " + $AppxPack.Name + ". Removing...") -ForegroundColor Cyan -NoNewline
        $AppxPack | Remove-AppxPackage -AllUsers -ErrorVariable Errs | Out-Null
        If ($Errs.Count -eq 0) {
            Write-Host (" OK!") -ForegroundColor Green
        } Else {
            Write-Host (" FAILED") -ForegroundColor Red
            Write-Host "Reason: " -ForegroundColor Yellow -NoNewline
            Write-Host $Errs.Message -ForegroundColor Red
            #Clear-Variable "Errs"
        }
    }
}
If ($GotWmiObject.Count -ne 0) {
    Foreach ($WmiObject in $GotWmiObject) {
        $Count++
        Write-Host ("`nFound " + $WmiObject.Name + ". Removing...") -ForegroundColor Cyan -NoNewline
        $WmiObject.Uninstall() | Out-Null
        If ($Errs.Count -eq 0) {
            Write-Host (" OK!") -ForegroundColor Green
        } Else {
            Write-Host (" FAILED") -ForegroundColor Red
            Write-Host "Reason: " -ForegroundColor Yellow -NoNewline
            Write-Host $Errs.Message -ForegroundColor Red
            #Clear-Variable "Errs"
        }
    }
}

#--CHECK IF WORK WAS DONE--
If ($Count -eq 0) {
    Write-Host "`nNo apps found. Exiting..." -ForegroundColor Green
    Start-Sleep -s 5
    Return
}


#--DISABLE SUGGESTIONS--
$KeyName = "DisableWindowsConsumerFeatures"
$KeyPath = "HKLM:\\SOFTWARE\Policies\Microsoft\Windows\Cloud Content\"
If ((Get-ItemProperty -Path $KeyPath -Name $KeyName).$KeyName -ne 1) {
    Write-Host "`nDisabling Microsoft Consumer Experience..." -ForegroundColor Cyan
    Set-ItemProperty -Path $KeyPath -Name $KeyName -Value "1" -Force
    Write-Host "Microsoft Consumer Experience disabled." -ForegroundColor Green
    Start-Sleep -s 1
}

Write-Host "`nDone. Exiting..." -ForegroundColor Green
Start-Sleep -s 5