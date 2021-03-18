::Switch to IE as defualt browser
::edited - 2/28/2017 - 2.0

::change the .htm file extension association
reg add "HKCU\Software\Classes\.htm" /t REG_SZ /d "htmlfile" /ve /f

::change the .html file extension association 
reg add "HKCU\Software\Classes\.html" /t REG_SZ /d "htmlfile" /ve /f

::change the program set to open http shell
reg add "HKCU\Software\Classes\http\shell\open\command" /t REG_SZ /d "\"C:\Program Files\Internet Explorer\IEXPLORE.EXE\" -nohome" /ve /f

::change the program to open ftp shell
reg add "HKCU\Software\Classes\ftp\shell\open\command" /t REG_SZ /d "\"C:\Program Files\Internet Explorer\IEXPLORE.EXE\" %%1" /ve /f

:: change the program to open https shell
reg add "HKCU\Software\Classes\https\shell\open\command" /t REG_SZ /d "\"C:\Program Files\Internet Explorer\IEXPLORE.EXE\" -nohome" /ve /f

::associate the http class
reg delete "HKCU\Software\Classes\http\DefaultIcon" /ve /f
reg add "HKCU\Software\Classes\http\DefaultIcon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\url.dll,0" /ve /f

::associate the ftp class
reg delete "HKCU\Software\Classes\ftp\DefaultIcon" /ve /f
reg add "HKCU\Software\Classes\ftp\DefaultIcon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\url.dll,0" /ve /f

::associate the https class
reg delete "HKCU\Software\Classes\https\DefaultIcon" /ve /f
reg add "HKCU\Software\Classes\https\DefaultIcon" /t REG_EXPAND_SZ /d "%%SystemRoot%%\system32\url.dll,0" /ve /f

::change the StartMenuInternet key
reg delete "HKCU\Software\Clients\StartMenuInternet" /ve /ve /f
reg add "HKLM\Software\Clients\StartMenuInternet" /t REG_SZ /d "IEXPLORE.EXE" /ve /f





:: ddeexec keys
reg add "HKCU\Software\Classes\http\shell\open\ddeexec" /t REG_SZ /d "\"%%1\",,-1,0,,,," /ve /f
reg add "HKCU\Software\Classes\ftp\shell\open\ddeexec" /t REG_SZ /d "\"%%1\",,-1,0,,,," /ve /f
reg add "HKCU\Software\Classes\https\shell\open\ddeexec" /t REG_SZ /d "\"%%1\",,-1,0,,,," /ve /f

:: ddeexec app keys
reg add "HKCR\HTTP\shell\open\ddeexec\Application" /t REG_SZ /d "IExplore" /ve /f
reg add "HKCR\HTTPS\shell\open\ddeexec\Application" /t REG_SZ /d "IExplore" /ve /f
reg add "HKCR\FTP\shell\open\ddeexec\Application" /t REG_SZ /d "IExplore" /ve /f
reg add "HKCR\htmlfile\shell\open\ddeexec\Application" /t REG_SZ /d "IExplore" /ve /f
reg add "HKCR\htmlfile\shell\opennew\ddeexec\Application" /t REG_SZ /d "IExplore" /ve /f
reg add "HKCR\mhtmlfile\shell\open\ddeexec\Application" /t REG_SZ /d "IExplore" /ve /f
reg add "HKCR\mhtmlfile\shell\opennew\ddeexec\Application" /t REG_SZ /d "IExplore" /ve /f

:: ifexec keys
reg add "HKLM\SOFTWARE\Classes\ftp\shell\open\ddeexec\ifExec" /t REG_SZ /d "*" /ve /f