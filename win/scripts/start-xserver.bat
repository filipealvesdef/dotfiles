@echo off
tasklist /FI "ImageName eq vcxsrv.exe" 2>NUL | find /I /N "vcxsrv.exe" >NUL
if "%ERRORLEVEL%"=="1" start /b vcxsrv.exe -screen 0 2560x1440@2 -nodecoration -wgl -ac
