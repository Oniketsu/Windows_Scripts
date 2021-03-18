Add-Type-AssemblyNameSystem.Windows.Forms

echo $LastBootUpTime
$LastBootUpTime = Get-WmiObject win32_operatingsystem
$Uptime = ((Get-Date) - ($LastBootUpTime.ConvertToDateTime($LastBootUpTime.LastBootUpTime))).Days
[System.Windows.MessageBox]::Show('Would you like to restart?','Reboot request','YesNoCancel','Error')
[System.Windows.MessageBox]::Show('Would you like to Shutdown?','Shutdown Request','YesNoPostpone','Error')

$msgBoxInput = [System.Windows.MessageBox]::Show('Would you like to Shutdown?','Shutdown Request','YesNoCancel','Error')
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

