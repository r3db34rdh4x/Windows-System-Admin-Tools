@echo off
REM Restart computer after 30 seconds
color 0E
echo.
echo ========================================
echo     DELAYED RESTART (30 seconds)
echo ========================================
echo.
echo Computer will restart in 30 seconds...
echo Run "shutdown /a" to cancel.
echo.

taskkill /F /IM explorer.exe >nul 2>&1
shutdown /r /t 30
echo.
echo Restart scheduled. Close this window or wait...
timeout /t 30
