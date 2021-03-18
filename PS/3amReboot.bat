@echo off 
set /a tm=97200-%TIME:~0,2%*3600-%TIME:~3,2%*60-%TIME:~6,2% 
shutdown /r /d p:2:2 /t %tm%