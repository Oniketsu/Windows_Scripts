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

Write-Host "Detecting Windows version..." -ForegroundColor Cyan

If (([System.Environment]::OSVersion.Version).Major -eq 6) { #--WIN7--

Write-Host "Windows 7 detected." -ForegroundColor Magenta

Write-Host "Stopping Windows Update service..." -ForegroundColor Cyan
Stop-Service -Name wuauserv -Force
Start-Sleep 10

Write-Host "Renaming the Software Distribution folder..." -ForegroundColor Cyan
If (Test-Path -Path $env:systemroot\SoftwareDistribution.bak -ErrorAction SilentlyContinue) {
    Remove-Item $env:systemroot\SoftwareDistribution.bak -Recurse -ErrorAction SilentlyContinue
}
Rename-Item $env:systemroot\SoftwareDistribution SoftwareDistribution.bak -ErrorAction SilentlyContinue

Write-Host "Renaming the Windows Update log..." -ForegroundColor Cyan
If (Test-Path -Path $env:systemroot\WindowsUpdate.log.bak -ErrorAction SilentlyContinue) {
    Remove-Item $env:systemroot\WindowsUpdate.log.bak -Recurse -ErrorAction SilentlyContinue
}
Rename-Item $env:systemroot\WindowsUpdate.log WindowsUpdate.log.bak -ErrorAction SilentlyContinue

Write-Host "Registering some DLLs..." -ForegroundColor Cyan
regsvr32.exe /s atl.dll
regsvr32.exe /s wuaueng.dll
regsvr32.exe /s wuaueng1.dll
regsvr32.exe /s wucltui.dll
regsvr32.exe /s wups.dll
regsvr32.exe /s wups2.dll
regsvr32.exe /s wuweb.dll

Write-Host "Starting Windows Update service..." -ForegroundColor Cyan
Start-Service -Name wuauserv
Start-Sleep 10

Write-Host "Process completed. Reboot computer for changes to take effect." -ForegroundColor Green
Start-Sleep 2


} Elseif (([System.Environment]::OSVersion.Version).Major -eq 10) { #--WIN10--

Write-Host "Windows 10 detected." -ForegroundColor Magenta

$arch = Get-WMIObject -Class Win32_Processor -ComputerName LocalHost | Select-Object AddressWidth

Write-Host "Stopping Windows Update services..." -ForegroundColor Cyan
Stop-Service -Name BITS -Force
Stop-Service -Name wuauserv -Force
Stop-Service -Name appidsvc -Force
Stop-Service -Name cryptsvc -Force
Start-Sleep 10

Write-Host "Removing QMGR data file..." -ForegroundColor Cyan
Remove-Item "$env:allusersprofile\Application Data\Microsoft\Network\Downloader\qmgr*.dat" -ErrorAction SilentlyContinue

Write-Host "Renaming the Software Distribution and CatRoot folders..." -ForegroundColor Cyan
If (Test-Path -Path $env:systemroot\SoftwareDistribution.bak -ErrorAction SilentlyContinue) {
    Remove-Item $env:systemroot\SoftwareDistribution.bak -Recurse -ErrorAction SilentlyContinue
}
Rename-Item $env:systemroot\SoftwareDistribution SoftwareDistribution.bak -ErrorAction SilentlyContinue

If (Test-Path -Path $env:systemroot\System32\Catroot2.bak -ErrorAction SilentlyContinue) {
    Remove-Item $env:systemroot\System32\Catroot2.bak -Recurse -ErrorAction SilentlyContinue
}
Rename-Item $env:systemroot\System32\Catroot2 catroot2.bak -ErrorAction SilentlyContinue

Write-Host "Renaming the Windows Update log..." -ForegroundColor Cyan
If (Test-Path -Path $env:systemroot\WindowsUpdate.log.bak -ErrorAction SilentlyContinue) {
    Remove-Item $env:systemroot\WindowsUpdate.log.bak -Recurse -ErrorAction SilentlyContinue
}
Rename-Item $env:systemroot\WindowsUpdate.log WindowsUpdate.log.bak -ErrorAction SilentlyContinue

Write-Host "Resetting the Windows Update Services to default settings..." -ForegroundColor Cyan
"sc.exe sdset bits D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)"
"sc.exe sdset wuauserv D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)"

Set-Location $env:systemroot\system32

Write-Host "Registering some DLLs..." -ForegroundColor Cyan
regsvr32.exe /s atl.dll
regsvr32.exe /s urlmon.dll
regsvr32.exe /s mshtml.dll
regsvr32.exe /s shdocvw.dll
regsvr32.exe /s browseui.dll
regsvr32.exe /s jscript.dll
regsvr32.exe /s vbscript.dll
regsvr32.exe /s scrrun.dll
regsvr32.exe /s msxml.dll
regsvr32.exe /s msxml3.dll
regsvr32.exe /s msxml6.dll
regsvr32.exe /s actxprxy.dll
regsvr32.exe /s softpub.dll
regsvr32.exe /s wintrust.dll
regsvr32.exe /s dssenh.dll
regsvr32.exe /s rsaenh.dll
regsvr32.exe /s gpkcsp.dll
regsvr32.exe /s sccbase.dll
regsvr32.exe /s slbcsp.dll
regsvr32.exe /s cryptdlg.dll
regsvr32.exe /s oleaut32.dll
regsvr32.exe /s ole32.dll
regsvr32.exe /s shell32.dll
regsvr32.exe /s initpki.dll
regsvr32.exe /s wuapi.dll
regsvr32.exe /s wuaueng.dll
regsvr32.exe /s wuaueng1.dll
regsvr32.exe /s wucltui.dll
regsvr32.exe /s wups.dll
regsvr32.exe /s wups2.dll
regsvr32.exe /s wuweb.dll
regsvr32.exe /s qmgr.dll
regsvr32.exe /s qmgrprxy.dll
regsvr32.exe /s wucltux.dll
regsvr32.exe /s muweb.dll
regsvr32.exe /s wuwebv.dll

Write-Host "Deleting WSUS client settings..." -ForegroundColor Cyan
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" /v AccountDomainSid /f
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" /v PingID /f
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" /v SusClientId /f

Write-Host "Resetting WinSock..." -ForegroundColor Cyan
netsh winsock reset
netsh winhttp reset proxy

Write-Host "Deleting all BITS jobs..." -ForegroundColor Cyan
Get-BitsTransfer | Remove-BitsTransfer

Write-Host "Attempting to install the Windows Update Agent..." -ForegroundColor Cyan
if($arch -eq 64){
    wusa Windows8-RT-KB2937636-x64 /quiet
}
else{
    wusa Windows8-RT-KB2937636-x86 /quiet
}

Write-Host "Starting Windows Update services..." -ForegroundColor Cyan
Start-Service -Name BITS
Start-Service -Name wuauserv
Start-Service -Name appidsvc
Start-Service -Name cryptsvc
Start-Sleep 10

Write-Host "Forcing discovery..." -ForegroundColor Cyan
wuauclt /resetauthorization /detectnow

Write-Host "Process completed. Reboot computer for changes to take effect." -ForegroundColor Green
Start-Sleep 2

}