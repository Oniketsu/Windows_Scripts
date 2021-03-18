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

function Get-ValidEmail {
    Do {
        Do {
            Write-Host $args[0] -ForegroundColor Yellow
            $Email = Read-Host
            If (!($Email -Like '*@*.*')) {
                Do {
                    Write-Host "Invalid format. " -ForegroundColor Red -NoNewline
                    Write-Host "Enter a valid email address: " -ForegroundColor Yellow -NoNewline
                    $Email = Read-Host
                } Until ($Email -Like '*@*.*')
            }
            Write-Host ("Is this correct? " + $Email + " [Y/N]: ") -ForegroundColor Yellow -NoNewline
            $Confirmed = Read-Host
            If ($Confirmed -eq "n") { Write-Host "Try again. " -ForegroundColor Red -NoNewline }
        } Until ($Confirmed -eq "y")
        If ((Get-Recipient -Identity $Email -ErrorAction SilentlyContinue) -ne $null) { $ValidEmail = $true }
        If ($ValidEmail -ne $true) {
            Write-Warning "Email doesn't exist. Try again."
        }
    } Until ($ValidEmail -eq $true)
    $global:Passed = $Email
}

#--SETUP--
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

#--GET USERNAME--
Try {
    Get-ValidEmail "Enter the email of the user to offboard"
    $User = $Passed
} Catch {
    Write-Warning "Couldn't get user. Exiting..."
    Return
}

#--CONVERT TO SHARED MAILBOX--
If ((Read-Host "Convert mailbox to shared? (Y/N)") -eq "y") {
    Write-Host "`nAttempting to convert mailbox to shared..." -ForegroundColor Cyan

    Try {
        Set-Mailbox $User -Type Shared
        Write-Host ($User + " was converted to shared.") -ForegroundColor Green
    } Catch {
        Write-Warning ("Couldn't convert mailbox " + $User +".")
    }
}

#--REDIRECT MAILBOX--
If ((Read-Host "Redirect mail? (Y/N)") -eq "y") {
    Write-Host "`nPreparing to redirect mailbox..." -ForegroundColor Cyan
    Get-ValidEmail "Enter the email address you'd like to redirect the terminated user's mail to"
    $RedirectTo = $Passed

    Write-Host ("Attempting to set mailbox redirection rule for " + $User + "...") -ForegroundColor Cyan

    Try {
        New-TransportRule -Name ($User + " > " + $RedirectTo) -SentTo $User -RedirectMessageTo $RedirectTo | Out-Null
        Write-Host ("Set up mail redirection rule successfully.`nMail sent to " + $User + " will be redirected to " + $RedirectTo + ".") -ForegroundColor Green
    } Catch {
        Write-Warning ("Couldn't set up mail redirection rule for " + $User + ".")
    }
}

#--CHANGE PASSWORD--
If ((Read-Host "Change password? (Y/N)") -eq "y") {
    Write-Host "`nPreparing to change password..." -ForegroundColor Cyan

    Try {
        Do {
            If ($Error[0].Exception -like '*choose a strong password*') {
                Write-Warning "Password wasn't complex enough.`nMust contain 8 to 16 characters, and at least one number or symbol."
                Write-Host "Try again. " -ForegroundColor Yellow -NoNewline
            }
            $Error.Clear()
            Do {
                $NewPassword = Read-Host "Enter new password"
                $Confirmed = Read-Host -Prompt ("Is this correct? " + $NewPassword + " [Y/N]")
                If ($Confirmed -eq "n") { Write-Host "Try again. " -ForegroundColor Yellow -NoNewline }
            } Until ($Confirmed -eq "y")
            $GoodPass = $True
            Set-MsolUserPassword -UserPrincipalName $User -NewPassword $NewPassword -ForceChangePassword $false -ErrorAction SilentlyContinue
        } While ($Error[0].Exception -like '*choose a strong password*')
        Write-Host ("Password for " + $User + " changed successfully.") -ForegroundColor Green
    } Catch {
        Write-Warning "Couldn't change password."
    }
}

#--DISABLE USER--
If ((Read-Host "Disable user? (Y/N)") -eq "y") {
    Write-Host ("`nAttempting to disable " + $User + "...") -ForegroundColor Cyan

    Try {
        Set-MsolUser -UserPrincipalName $User -BlockCredential $true
        Write-Host ($User +  " successfully disabled.") -ForegroundColor Green
    } Catch {
        Write-Warning ("Couldn't disable " + $User + ".")
    }
}

#--REMOVE LICENSES--

If ((Read-Host "Remove licenses? (Y/N)") -eq "y") {
    Write-Host ("`nAttempting to remove licenses from " + $User + "...") -ForegroundColor Cyan
    Try {
        $MSOLSKU = (Get-MSOLUser -UserPrincipalName $User).Licenses.AccountSkuId
        Foreach ($SKU in $MSOLSKU) {
            Set-MsolUserLicense -UserPrincipalName $User -RemoveLicenses $SKU
        }
        Write-Host ("Licenses removed from " + $User + ".") -ForegroundColor Green
    } Catch {
        Write-Warning ("Couldn't remove licenses from " + $User + ".")
    }
}

#--EXIT EXCHANGE SHELL--
Get-PSSession | Remove-PSSession