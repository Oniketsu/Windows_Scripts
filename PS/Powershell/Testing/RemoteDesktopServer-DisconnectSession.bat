@ECHO OFF
::http://community.spiceworks.com/how_to/show/873

:WinVersion
cls
echo ## Definig Windows Version
ver>"%temp%\ver.tmp"
find /i "6.0" "%temp%\ver.tmp">nul
if %ERRORLEVEL% EQU 0 goto ADMIN
find /i "6.1" "%temp%\ver.tmp">nul
if %ERRORLEVEL% EQU 0 goto ADMIN

:MENU1
title Choose Server
cls
echo Enter Server name, IP address, or Q to quit.
echo.
set input=Z

:: Prompt for Install
Set /P input=
if /I %input% EQU Q goto END
if /I %input% EQU Z goto MENU1
set server=%input%
goto USERS

:USERS
title Users on %SERVER%
cls
qwinsta /server:%SERVER%
echo.
echo Type Session ID to disconnect session
echo Type R to refresh user list
echo Type P to choose another server
echo Type Q to quit
echo.
set input=R

:: Prompt for Install
Set /P input=
if /I %input% EQU Q goto END
if /I %input% EQU R goto USERS
if /I %input% EQU P goto MENU1
set session=%input%
goto DISCON

:DISCON
title Disconnecting User
cls
reset session %session% /server:%server%
echo Log off in process
echo .
goto USERS

:ADMIN
cls
if /I %CD% EQU %systemroot%\system32 goto MENU1
goto ERR1

:ERR1
title Error
cls
echo This program requires Administrative Rights to run!
echo.
pause
goto END

:END
exit

Found on Spiceworks: https://community.spiceworks.com/scripts/show/190-disconnect-terminal-services-session-remotely?utm_source=copy_paste&utm_campaign=growth