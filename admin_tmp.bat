
rem add user to local administrator group
NET LOCALGROUP Administrators "%USERDOMAIN%\%USERNAME%" /ADD

rem log user off
shutdown -L

rem sleep for a number of seconds(In this case 30 min)
TIMEOUT /T 1800

rem remove the user
NET LOCALGROUP Administrators "%USERDOMAIN%\%USERNAME%" /del