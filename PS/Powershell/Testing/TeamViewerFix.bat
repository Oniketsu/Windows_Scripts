Net stop "TeamViewer">nul
net stop "TeamViewer_Service">nul
taskkill /FI "IMAGENAME eq TeamViewer*" /F
"c:\program files (x86)\TeamViewer\Version6\uninstall.exe" /s
"c:\program files (x86)\TeamViewer\Version7\uninstall.exe" /s
"c:\program files (x86)\TeamViewer\Version8\uninstall.exe" /s
"c:\program files (x86)\TeamViewer\Version9\uninstall.exe" /s
"c:\program files (x86)\TeamViewer\uninstall.exe" /s
"c:\program files (x86)\Take Control Viewer\uninstall.exe" /s
"c:\program files\teamviewer\Version6\uninstall.exe" /s
"c:\program files\teamviewer\Version7\uninstall.exe" /s
"c:\program files\teamviewer\Version8\uninstall.exe" /s
"c:\program files\teamviewer\Version9\uninstall.exe" /s
"c:\program files\teamviewer\Version10\uninstall.exe" /s
"c:\program files\teamviewer\Version11\uninstall.exe" /s
"c:\program files\teamviewer\uninstall.exe" /s
"c:\program files\Take Control Viewer\uninstall.exe" /s
rd "c:\program files\teamviewer" /S /Q
rd "c:\program files (x86)\teamviewer" /S /Q
rd "c:\program files\Take Control Viewer" /S /Q
rd "c:\program files (x86)\Take Control Viewer" /S /Q
reg delete HKLM\SOFTWARE\teamviewer /f
reg delete HKLM\SOFTWARE\WOW6432NODE\teamviewer /f
sc delete teamviewer
sc delete teamviewer_service