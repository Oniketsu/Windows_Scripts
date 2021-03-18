
rem add user to local administrator group
NET LOCALGROUP Administrators "SWK-0371\test" /ADD

rem sleep for a number of seconds
TIMEOUT /T 15

rem remove the user
NET LOCALGROUP Administrators "SWK-0371\test" /del