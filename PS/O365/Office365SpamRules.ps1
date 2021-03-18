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
$CanContinue = $False
$RuleName = "Spam Filtering" #Name of rule in Office 365
$SubjectOrBodyArray = New-Object System.Collections.ArrayList
$SenderAddressArray = New-Object System.Collections.ArrayList
$ErrorActionPreference = "SilentlyContinue"

#--FUNCTIONS--
Function Couldnt-Read {
    Write-Host "Couldn't read your input. Please try again.`n" -ForegroundColor Yellow
    Start-Sleep -m 200
    Pause
}

Function Check-Loop($RuleText, $Array) {
    cls
    Write-Host "Add rule for ""$RuleText""?"
    Start-Sleep -m 100
    Write-Host "[Y] Yes  [N] No : " -ForegroundColor Magenta -NoNewline
    $Confirm = Read-Host
    If ($Confirm -eq "Y"){
        Do {
            $CanContinue = $False
            Write-Host "`nProvide rule parameters."
            Write-Host "$RuleText`: " -ForegroundColor Magenta -NoNewline
            $Array.Add((Read-Host))
            cls 
            Start-Sleep -m 200
            Write-Host "Current rules:" -ForegroundColor Cyan
            $Array
            Write-Host "`nAny more rules to add for ""$RuleText""?" -ForegroundColor White
            Write-Host "[Y] Yes  [N] No : " -ForegroundColor Magenta -NoNewline
            $Confirm = Read-Host
            If ($Confirm -eq "N") {
                $CanContinue = $true
                Start-Sleep -Milliseconds 250
            } ElseIf ($Confirm -ne "Y") {
                Couldnt-Read
            } ElseIf ($Confirm -eq "Y") {
                Start-Sleep -Milliseconds 250
            }
        } While ($CanContinue -eq $False)
    } ElseIf ($Confirm -ne "N") {
        Write-Host $CouldntRead -ForegroundColor Yellow
    }   
}

cls

#--CHECK FOR MSONLINE MODULE--
If (!(Get-Module -ListAvailable -Name "MSOnline")) {
    Write-Host "Getting MSOnline module..." -ForegroundColor Cyan
    Install-Module MsOnline -Force
    Write-Host "Installed MSOnline module." -ForegroundColor Green
} Else { Write-Host "MSOnline module present." -ForegroundColor Green }

#--SUBJECT OR BODY CONTAINS--
Check-Loop "Subject or body contains" $SubjectOrBodyArray

#--SENDER ADDRESS CONTAINS--
Check-Loop "Sender address contains" $SenderAddressArray

#--CHECK BOTH ARRAYS FOR CONTENT--
If (($SubjectOrBodyArray.Count -eq 0) -and ($SenderAddressArray.Count -eq 0)) {
	Write-Host "No new rules to add to this tenant." -ForegroundColor Green
	Start-Sleep -s 1
} Else {
	#--LOOP--
	Do {
        cls
		$CanContinue = $False
		#--GET CREDENTIALS--
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

		#--CHECK FOR EXISTING SUBJECT/BODY RULE--
		$RuleContent = Get-TransportRule -Identity "$RuleName - Subject/Body"

		If ($RuleContent -ne $null) { #If rule exists...
			#--CHECK EXISTING RULE'S CONTENTS AND REMOVE REDUNDANCIES--
			$SubjSameItems = Compare-Object -ReferenceObject $RuleContent.SubjectOrBodyContainsWords -DifferenceObject $SubjectOrBodyArray -ExcludeDifferent -IncludeEqual
			$SubjDiffItems = Compare-Object -ReferenceObject $RuleContent.SubjectOrBodyContainsWords -DifferenceObject $SubjectOrBodyArray
			If ($($SubjSameItems.InputObject).Count -gt 0) {
				Foreach ($SubjSameItem in ($SubjSameItems.InputObject)) {
					$SubjectOrBodyArray.Remove($SubjSameItem)
				}
			}

			#--CREATE COLLECTION FROM REMAINING CONTENT--
			If ($SubjectOrBodyArray.Count -gt 0) {
				$SubjectOrBodyColl = $RuleContent.SubjectOrBodyContainsWords
				Foreach ($Item in $SubjectOrBodyArray) {
					$SubjectOrBodyColl += $Item
				}
				
				#--CREATE COMMAND TO ADD TO EXISTING RULE--
				$Command = 'Set-TransportRule -Identity $RuleName -DeleteMessage $true -SubjectOrBodyContainsWords $SubjectOrBodyColl'
			
				#--RUN COMMAND AND ADD TO EXISTING RULE--
				Invoke-Expression -Command $Command | Out-Null
                Write-Host "Revised existing ""subject/body text"" rule." -ForegroundColor Green
			} Else {
				Write-Host "No new ""subject/body"" content to add to this tenant." -ForegroundColor Green
                Start-Sleep 1
			}
		} Else { #If rule doesn't exist...
			#--CREATE COLLECTION FROM REMAINING CONTENT--
			If ($SubjectOrBodyArray.Count -gt 0) {
				$SubjectOrBodyColl = @()
				Foreach ($Item in $SubjectOrBodyArray) {
					$SubjectOrBodyColl += $Item
				}
			}
			
			#--CREATE COMMAND TO CREATE NEW RULE--
			$Command = ('New-TransportRule -Name "' + $RuleName + ' - Subject/Body" -SubjectOrBodyContainsWords $SubjectOrBodyColl -DeleteMessage $true')

			#--RUN COMMAND AND CREATE NEW RULE
			Invoke-Expression -Command $Command | Out-Null
            Write-Host "Created new ""subject/body text"" rule." -ForegroundColor Green
		}
		
		#--CHECK FOR EXISTING SENDER ADDRESS RULE--
		$RuleContent = Get-TransportRule -Identity "$RuleName - Sender Address"

		If ($RuleContent -ne $null) { #If rule exists...
			#--CHECK EXISTING RULE'S CONTENTS AND REMOVE REDUNDANCIES--
			$SenderSameItems = Compare-Object -ReferenceObject $RuleContent.FromAddressContainsWords -DifferenceObject $SenderAddressArray -ExcludeDifferent -IncludeEqual
			$SenderDiffItems = Compare-Object -ReferenceObject $RuleContent.FromAddressContainsWords -DifferenceObject $SenderAddressArray
			If ($($SenderSameItems.InputObject).Count -gt 0) {
				Foreach ($SenderSameItem in ($SenderSameItems.InputObject)) {
					$SenderAddressArray.Remove($SenderSameItem)
				}
			}

			#--CREATE COLLECTION FROM REMAINING CONTENT--
			If ($SenderAddressArray.Count -gt 0) {
				$SenderAddressColl = $RuleContent.FromAddressContainsWords
				Foreach ($Item in $SenderAddressColl) {
					$SenderAddressColl += $Item
				}

				#--CREATE COMMAND TO ADD TO EXISTING RULE--
				$Command = 'Set-TransportRule -Identity $RuleName -DeleteMessage $true -SenderAddressContainsWords $SenderAddressColl'

				#--RUN COMMAND AND ADD TO EXISTING RULE--
				Invoke-Expression -Command $Command | Out-Null
                Write-Host "Revised existing ""sender address"" rule." -ForegroundColor Green
			} Else {
				Write-Host "No new ""sender address"" content to add to this tenant." -ForegroundColor Green
                Start-Sleep 1
			}
		} Else { #If rule doesn't exist...
			#--CREATE COLLECTION FROM REMAINING CONTENT--
			If ($SenderAddressArray.Count -gt 0) {
				$SenderAddressColl = @()
				Foreach ($Item in $SenderAddressArray) {
					$SenderAddressColl += $Item
				}
			}

			#--CREATE COMMAND TO CREATE NEW RULE--
			$Command = ('New-TransportRule -Name "' + $RuleName + ' - Sender Address" -DeleteMessage $true -FromAddressContainsWords $SenderAddressColl')

			#--RUN COMMAND AND CREATE NEW RULE--
			Invoke-Expression -Command $Command | Out-Null
            Write-Host "Created new ""sender address"" rule." -ForegroundColor Green
		}
		
		#--EXIT EXCHANGE SHELL--
		Get-PSSession | Remove-PSSession

		Write-Host "`nAny more tenants to apply rules to?" -ForegroundColor White
		Write-Host "[Y] Yes  [N] No : " -ForegroundColor Magenta -NoNewline
		$Confirm = Read-Host
		If ($Confirm -eq "N") {
			$CanContinue = $true
			Start-Sleep -Milliseconds 250
		} ElseIf ($Confirm -ne "Y") {
			Couldnt-Read
		} ElseIf ($Confirm -eq "Y") {
			Start-Sleep -Milliseconds 250
		}
	} While ($CanContinue -eq $False)
}