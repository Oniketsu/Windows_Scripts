$WillClose = "`nThis window will automatically close in 20 seconds.`n"
$CouldntRead = "Couldn't read your input. Please try again.`n"

cls

Write-Host "  .: TechRunner IT - RD Disconnect Script :.  " -ForegroundColor DarkBlue -BackgroundColor White -NoNewline
Write-Host "`nThis script will disconnect a user from Remote Desktop.`n" -ForegroundColor Gray
Start-Sleep -Milliseconds 250

#--CHECK FOR ADMIN--
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
If (!($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    Write-Host "This script needs administrator rights to run successfully!" -ForegroundColor Yellow
    Start-Sleep 2
    Write-Host "`nPlease open as an Administrator (Right click -> Run as administrator) and try again." -ForegroundColor Yellow
    Start-Sleep 2
    Write-Host $WillClose -ForegroundColor Gray
    Start-Sleep 20
    Return
}

pause

#--GET SERVER--
Do {
    $CanContinue = $false
    Do {
        cls
        Clear-Variable "ServerName" -ErrorAction SilentlyContinue
        Start-Sleep -Milliseconds 250
        Write-Host "Enter the name of the remote desktop server: " -ForegroundColor Magenta -NoNewline
        $ServerName = Read-Host
        If (($ServerName -eq "") -or ($ServerName -eq $Null)){
            Write-Host $CouldntRead -ForegroundColor Yellow
            Start-Sleep -Milliseconds 250
            pause
        }
    } Until (($ServerName -ne "") -and ($ServerName -ne $Null))

    Do {
        $CanContinue = $False
        Write-Host "`nIs the server name ""$ServerName"" correct?" -ForegroundColor White
        Write-Host "[Y] Yes  [N] No : " -ForegroundColor Magenta -NoNewline
        $Confirm = Read-Host
        If ($Confirm -eq "Y") {
            $CanContinue = $true
        } ElseIf ($Confirm -eq "N") {
            Start-Sleep -Milliseconds 250
            Write-Host "Please try again.`n" -ForegroundColor Yellow
            Start-Sleep -Milliseconds 250
            pause
        } Else {
            Start-Sleep -Milliseconds 250
            Write-Host $CouldntRead -ForegroundColor Yellow
            Start-Sleep -Milliseconds 250
            pause
        }
    } Until (($Confirm -eq "Y") -or ($Confirm -eq "N"))
} Until ($CanContinue -eq $true)

cls
Start-Sleep -Milliseconds 500

Do {
    #--GET RDWEB USERS--
    Write-Host "Getting user info from $ServerName... " -ForegroundColor Cyan -NoNewline
    Start-Sleep -Milliseconds 250

    Try {
        $Users = Get-RDUserSession -ConnectionBroker $ServerName -ErrorAction Stop
        Start-Sleep -Milliseconds 200
        Write-Host "OK!" -ForegroundColor Green
        Start-Sleep 1
    } Catch {
        Start-Sleep -Milliseconds 200
        Write-Host "FAILED" -ForegroundColor Red
        Start-Sleep 1
        Write-Host "`nPlease check that the server name is entered correctly, then run this script again." -ForegroundColor Yellow
        Start-Sleep 3
        Write-Host "`nIf the server name is correct, please contact us!`n>  help@techrunnerit.com" -ForegroundColor Yellow
        Start-Sleep 1
        Write-Host $WillClose -ForegroundColor Gray
        Start-Sleep 20
        Return
    }

    #--CHOOSE USER--
    cls
    Start-Sleep -Milliseconds 250
    Clear-Variable "Confirm"

    Do {
        $CanContinue = $false
        Do {
            Start-Sleep -Milliseconds 200
            Write-Host "List of connected users:" -ForegroundColor Gray
            $Users | Select-Object -Property @{Name="ID";Expression={$_."UnifiedSessionId"}},UserName | Format-Table -AutoSize
            Start-Sleep 2
            Write-Host "Enter the ID of the user to disconnect: " -ForegroundColor Magenta -NoNewline
            $SessionId = Read-Host
            If (($SessionId -eq "") -or ($SessionId -eq $Null)){
                Start-Sleep -Milliseconds 250
                Write-Host $CouldntRead -ForegroundColor Yellow
                Start-Sleep -Milliseconds 250
                pause
                cls
            }
        } Until (($SessionId -ne "") -and ($SessionId -ne $Null))

        $UserToDC = $Users | Select | Where {$_.UnifiedSessionId -like $SessionId}

        If ($UserToDC -ne $Null) {        
            Do {
                Write-Host "`nDisconnect user $($UserToDC.UserName)`?" -ForegroundColor White
                Write-Host "[Y] Yes  [N] No : " -ForegroundColor Magenta -NoNewline
                $Confirm = Read-Host
                If ($Confirm -eq "Y") {
                    $CanContinue = $true
                } ElseIf ($Confirm -eq "N") {
                    Start-Sleep -Milliseconds 250
                    Write-Host "Please try again.`n" -ForegroundColor Yellow
                    Start-Sleep -Milliseconds 250
                    pause
                    cls
                } Else {
                    Start-Sleep -Milliseconds 250
                    Write-Host $CouldntRead -ForegroundColor Yellow
                    Start-Sleep -Milliseconds 250
                    pause
                    cls
                }
            } Until (($Confirm -eq "Y") -or ($Confirm -eq "N"))
        } Else {
            Start-Sleep -Milliseconds 250
            Write-Host "ID does not match any logged in users. Please try again.`n" -ForegroundColor Yellow
            Start-Sleep -Milliseconds 250
            pause
            cls
        }
    } Until ($CanContinue -eq $true)

    cls
    Start-Sleep -Milliseconds 250

    #--DISCONNECT USER--
    Write-Host "Disconnecting $($UserToDC.UserName)... " -ForegroundColor Cyan -NoNewline
    Try {
        Invoke-RDUserLogoff -HostServer $ServerName -UnifiedSessionID $($UserToDC.UnifiedSessionId) -Force
        Start-Sleep -Milliseconds 200
        Write-Host "OK!" -ForegroundColor Green
        Start-Sleep 1
    } Catch {
        Write-Host "Could not disconnect $($UserToDC.UserName)." -ForegroundColor Yellow
        Start-Sleep 3
        Write-Host "`nPlease try the script again, or contact us for assistance.`n>  help@techrunnerit.com`n" -ForegroundColor Yellow
        Start-Sleep 1
        Write-Host $WillClose -ForegroundColor Gray
        Start-Sleep 20
    }

    Start-Sleep 1

    Write-Host "`n$($UserToDC.UserName) successfully disconnected." -ForegroundColor Green

    Start-Sleep 2

    Do {
        $CanContinue = $False
        Write-Host "`nAny more users to disconnect?" -ForegroundColor White
        Write-Host "[Y] Yes  [N] No : " -ForegroundColor Magenta -NoNewline
        $Confirm = Read-Host
        If ($Confirm -eq "N") {
            $CanContinue = $true
            cls
            Start-Sleep -Milliseconds 250
        } ElseIf ($Confirm -ne "Y") {
            Write-Host $CouldntRead -ForegroundColor Yellow
        } ElseIf ($Confirm -eq "Y") {
            cls
            Start-Sleep -Milliseconds 250
        }
    } Until (($Confirm -eq "Y") -or ($Confirm -eq "N"))
} Until ($CanContinue -eq $True)

Write-Host $WillClose -ForegroundColor Gray
Start-Sleep 20