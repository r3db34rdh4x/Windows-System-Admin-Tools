@echo off
REM Windows System Admin Tools Launcher
REM Launches the main system control menu with elevated privileges

color 0A
title Windows System Admin Tools

REM Check for admin rights
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo ERROR: Administrator privileges required!
    echo Right-click this file and select "Run as administrator"
    echo.
    pause
    exit /b 1
)

REM Get the directory where this batch file is located
cd /D "%~dp0"

REM Navigate to scripts directory
cd ..\scripts

REM Launch the PowerShell menu with execution policy bypass
echo Starting Windows System Admin Tools...
echo.
powershell.exe -ExecutionPolicy Bypass -NoProfile -File ".\SystemControlMenu.ps1"

REM Check if PowerShell script exited with error
if %errorLevel% neq 0 (
    echo.
    echo An error occurred while running the script.
    pause
)
