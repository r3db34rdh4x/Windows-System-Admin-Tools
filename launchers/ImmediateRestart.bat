@echo off
REM Immediately restart the computer
color 0C
echo.
echo ========================================
echo     IMMEDIATE RESTART
echo ========================================
echo.
echo This will restart your computer NOW!
echo.
pause

taskkill /F /IM explorer.exe >nul 2>&1
shutdown /r /t 0
