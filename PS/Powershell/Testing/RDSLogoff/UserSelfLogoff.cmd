
@echo off
echo.
echo  This will logoff all of your Citrix sessions.
echo  Press Ctrl-C to cancel, or
echo.
echo.
pause

c:\admin\tslogoff\tslogoff %username% /DISC
c:\admin\tslogoff\tslogoff %username%

