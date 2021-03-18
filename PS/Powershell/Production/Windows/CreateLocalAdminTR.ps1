# SWK Tech - Create local admin account
# requires -runasadministrator
# requires -install or -uninstall to run
# Set script params
param([switch]$install, [switch]$uninstall)

 # Global Vars
Write-Host "Preparing User account details.."

$localAcc = "swkadmin"
$localAccPass = "qpj^nUyB9MG1iIXPE%Cqw" # password needs to be complex depending on System Preferences
$localAccGroup = "Administrators"
$localAccDescript = "Swk Local Admin"
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
$name = "swkadmin"
$value = "0"

 # Functions

Function addUser($userName, $pass, $descript)
{
    try
    {
        Write-Host "Creating User account.."
        $compName = $env:COMPUTERNAME
        $cn = [ADSI]"WinNT://$compName"
        $user = $cn.Create('User',$userName)
        $user.SetPassword($pass)
        $user.setinfo()
        $user.description = $descript
        $user.SetInfo()
    }
    catch
    {
        $_
    }
}

Function addToGroup($userName, $userGroup)
{
    try
    {
        Write-Host "Adding User to the Admin group.."
        $group = [ADSI]"WinNT://$env:COMPUTERNAME/$userGroup,group"
        $group.Add("WinNT://$env:COMPUTERNAME/$userName,user")
    }
    catch
    {
        $_
    }
}

Function rmUser($userName)
{
    try
    {
        Write-Host "Removing User account.."
        $compName = $env:COMPUTERNAME
        $cn = [ADSI]"WinNT://$compName"
        $user = $cn.Delete("User", $userName)
    }
    catch
    {
        $_
    }
}

Function hideUser ($registryPath, $name, $value)
{
    try
    {
      New-Item -Path "$registryPath" -Name SpecialAccounts -Force | Out-Null
      New-Item -Path "$registryPath\SpecialAccounts" -Name UserList -Force | Out-Null
      New-ItemProperty -Path "$registryPath\SpecialAccounts\UserList" -Name $localAcc -Value 0 -PropertyType DWord -Force | Out-Null
    }
  catch
  {
      $_
  }
}

 # Main

if ($install)
{
    addUser $localAcc $localAccPass $localAccDescript
    addToGroup $localAcc $localAccGroup
    hideUser $registryPath $name $value
}
elseif ($uninstall)
{
    rmUser $localAcc
}
