 <#
.SYNOPSIS
    Installs the Roar Agent via the Continuum RMM.

.DESCRIPTION
    Provides a paramaterized script that lets you install the Roar Agent based on the specific setup you want.

.PARAMETER RoarUrl
  The Roar url for your instance, e.g. us1.app.liongard.com
  
  $RoarUrl = 'xxxxx.app.liongard.com'

.PARAMETER RoarAccessKey
  The Roar API access key generated from Roar
  
  $RoarAccessKey = "xxxxxx"

.PARAMETER RoarAccessSecret
  The Roar API secret generated from Roar
  
  $RoarAccessSecret = "xxxxxx"

.PARAMETER RoarSvcUsername
  The username of the Roar service account to use associate the service with, i.e. "Run As"

  $RoarSvcUsername = "DOMAIN\RoarSvcAccount"

.PARAMETER RoarSvcPassword
  The password of the Roar service account to use associate the service with, i.e. "Run As"

  $RoarSvcPassword = "xxxxxx"

.PARAMETER UseSiteName
    Default to False. If set it will associate the agent to the Environment which matches the site name. Change this to $True if and only if the Roar Environment names EXACTLY MATCH the Continuum Site names. We recommend you model Roar environment names after your Continuum site names as they are easy to change and Continuum is not.
NOTE: The Continuum agent does not produce the 'SITENAME' registry key for ~30 minutes after initial Continuum agent installation. You will need to run this script after the Continuum agent has properly registered and the registry key for the site name is populated if you use this feature.

    $UseSiteName= "$True"

.PARAMETER Environment
    If you want to manually specify the Environment in Roar to associate the agent with.

    $Environment = "Liongard"

.NOTES
    Version: 1.0.0
    Author: Addison Caldwell (i.e. Powershell Scripter Guru)
    Date: 09/05/2019
#>
$X64 = 64
$X86 = 32
$InstallerName = "RoarAgent.msi"
$DownloadURL = "https://d2qy4ywchsni6t.cloudfront.net/" + $InstallerName
$InstallerPath = Join-Path $Env:TMP $InstallerName
$DebugLog = Join-Path $Env:TMP RoarDebug.log
$MsiLog = Join-Path $Env:TMP install.log


<#
Edit the following parameters to include your Roar URL, Access Key and Secret, (optionally) the Username and Password to a Service Account, and (optionally) the name of the Environment that you would like this Agent to be associated to in Roar
#>

$RoarURL = 'swktech.app.liongard.com'
$RoarAccessKey = "a3e4ced5dce5d7cbf7a3"
$RoarAccessSecret = "e5707d99243e7a73bd4abf608ba5e960afb247e114a64043809b8c6309fe2b74"
$RoarSvcUsername = "DOMAIN\RoarSvcAccount"
$RoarSvcPassword = "xxxxxx"
$Environment = "xxxxxx" 


function Get-TimeStamp {
    return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)   
}
function Get-WindowsArchitecture {
    If ($env:ProgramW6432) {
        $WindowsArchitecture = $X64
    } Else {
        $WindowsArchitecture = $X86
    }
    return $WindowsArchitecture
}
function Get-ContinuumKeyPath {
    $WindowsArchitecture = Get-WindowsArchitecture
    If ($WindowsArchitecture -eq $X86) {
        $ContinuumKeyPath = "HKLM:\SOFTWARE\SAAZOD"
    } ElseIf ($WindowsArchitecture -eq $X64) {
        $ContinuumKeyPath = "HKLM:\SOFTWARE\WOW6432Node\SAAZOD"
    } Else {
        $ArchitectureError = "Failed to determine the Windows Architecture. Received $WindowsArchitecure."
        Add-Content $DebugLog "$(Get-TimeStamp) $ArchitectureError"
        throw $ArchitectureError
    }
    return $ContinuumKeyPath
}
function Get-ContinuumKeyObject {
    $ContinuumKeyPath = Get-ContinuumKeyPath
    If ( ! (Test-Path $ContinuumKeyPath)) {
        $ContinuumRegistryError = "The expected Continuum registry key $ContinuumKeyPath did not exist."
        Add-Content $DebugLog "$(Get-TimeStamp) $ContinuumRegistryError"
        throw $ContinuumRegistryError
    }
    
    $ContinuumKeyObject = Get-ItemProperty $ContinuumKeyPath
    
    If ( ! ($ContinuumKeyObject)) {
        $ContinuumRegistryError = "The Continuum registry key was empty."
        Add-Content $DebugLog "$(Get-TimeStamp) $ContinuumRegistryError"
        throw $ContinuumRegistryError
    }
    return $ContinuumKeyObject
}
function Get-SiteCode {
    $ContinuumValueName = "SiteCode"
    $ContinuumKeyObject = Get-ContinuumKeyObject
    If ( ! (Get-Member -inputobject $ContinuumKeyObject -name $ContinuumValueName -Membertype Properties)) {
        $ContinuumKeyPath = Get-ContinuumKeyPath
        $ContinuumRegistryError = ("The expected Continuum registry value $ContinuumValueName did not exist within " +
                                   "$ContinuumKeyPath")
        Add-Content $DebugLog "$(Get-TimeStamp) $ContinuumRegistryError"
        throw $ContinuumRegistryError
    }
    $SiteCode = $ContinuumKeyObject.$ContinuumValueName
    return $SiteCode
}

function Get-SiteName {
    $ContinuumValueName = "SITENAME"
    $ContinuumKeyObject = Get-ContinuumKeyObject
    If ( ! (Get-Member -inputobject $ContinuumKeyObject -name $ContinuumValueName -Membertype Properties)) {
        $ContinuumKeyPath = Get-ContinuumKeyPath
        $ContinuumRegistryError = ("The expected Continuum registry value $ContinuumValueName did not exist within " +
                                   "$ContinuumKeyPath")
        Add-Content $DebugLog "$(Get-TimeStamp) $ContinuumRegistryError"
        throw $ContinuumRegistryError
    }
    $SiteName = $ContinuumKeyObject.$ContinuumValueName
    return $SiteName
}
function Get-Installer {
    $WebClient = New-Object System.Net.WebClient
    try {
        $WebClient.DownloadFile($DownloadURL, $InstallerPath)
    } catch {
        Add-Content $DebugLog "$(Get-TimeStamp) $_.Exception.Message"
    }
    If ( ! (Test-Path $InstallerPath)) {
        $DownloadError = "Failed to download the Roar Agent Installer from $DownloadURL"
        Add-Content $DebugLog "$(Get-TimeStamp) $DownloadError"
        throw $DownloadError
    }
}

# Generate the agent name here. We use Continuum SiteCode + Name of the computer to ensure uniqueness
function Get-AgentName {
    $SiteCode = Get-SiteCode
    $AgentName = $SiteCode + "-" + $env:computername
    return $AgentName
}

function Install-Roar {
    $AgentName = Get-AgentName
    If ( ! (Test-Path $InstallerPath)) {
        $InstallerError = "The installer was unexpectedly removed from $InstallerPath"
        Add-Content $DebugLog "$(Get-TimeStamp) $InstallerError"
        throw $InstallerError
    }
   
    $RoarArgs = "ROARURL=" + $RoarURL + " ROARACCESSKEY=" + $RoarAccessKey + " ROARACCESSSECRET=" + $RoarAccessSecret + " ROARAGENTNAME=" + "`"$AgentName`""
    If ($RoarSvcUsername -and $RoarSvcUsername.Length -gt 0) {
    	$RoarArgs += " ROARAGENTSERVICEACCOUNT=" + "`"$RoarSvcUsername`"" + " ROARAGENTSERVICEPASSWORD=" + "`"$RoarSvcPassword`""
    }
    
    If ($UseSiteName) {
      $SiteName = Get-SiteName
      $RoarArgs += " ROARENVIRONMENT=" + "`"$SiteName`""
    } ElseIf ($Environment) {
    	$RoarArgs += " ROARENVIRONMENT=" + "`"$Environment`""
    }

    $InstallArgs = @(
        "/i"
        "`"$InstallerPath`""
        $RoarArgs
        "/qn"
        "/L*V"
        "`"$MsiLog`""
        "/norestart"
    )

    Start-Process msiexec.exe -ArgumentList $InstallArgs -Wait -PassThru
}
function main {
    If (!(Get-Service "Roar Agent" -ErrorAction SilentlyContinue)) {
    	Get-Installer # Download the MSI
      Install-Roar # Install the MSI
    }
}
main