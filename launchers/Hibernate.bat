@echo off
REM Hibernate the computer
color 0B
echo.
echo ========================================
echo     HIBERNATE COMPUTER
echo ========================================
echo.
echo Hibernating computer...
echo.

taskkill /F /IM explorer.exe >nul 2>&1
shutdown /h
