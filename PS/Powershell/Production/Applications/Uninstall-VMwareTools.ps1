$regpath = "HKLM:\Software\Microsoft\Windows\CurrentVersion\uninstall"
Get-childItem $regpath | %  {
$keypath = $_.pschildname
$key = Get-Itemproperty $regpath\$keypath
if ($key.DisplayName -match "VMware Tools") {
$VMwareToolsGUID = $keypath
}
MsiExec.exe /x $VMwareToolsGUID  /qn /norestart 
shutdown -s -t 120 -f 
}