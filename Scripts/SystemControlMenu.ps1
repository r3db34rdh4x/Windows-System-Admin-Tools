#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Windows System Administration Control Menu
.DESCRIPTION
    Interactive menu for common Windows 11 system administration tasks.
    Requires Administrator privileges.
.NOTES
    Version: 2.0
    Compatible with: Windows 11
#>

# Import the system control functions module
$modulePath = Join-Path $PSScriptRoot "..\modules\SystemControlFunctions.psm1"
Import-Module $modulePath -Force

# Set console properties
$Host.UI.RawUI.WindowTitle = "Windows System Admin Tools"
$Host.UI.RawUI.BackgroundColor = "Black"
$Host.UI.RawUI.ForegroundColor = "Green"
Clear-Host

function Show-Menu {
    Clear-Host
    Write-Host "============================================================================" -ForegroundColor Cyan
    Write-Host "               WINDOWS SYSTEM ADMINISTRATION TOOLS" -ForegroundColor Green
    Write-Host "                      Windows 11 Compatible" -ForegroundColor Yellow
    Write-Host "============================================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "POWER MANAGEMENT" -ForegroundColor Yellow
    Write-Host "  1.  Keep System Awake (Shift+F15 loop)" -ForegroundColor White
    Write-Host "  2.  Restart Computer Immediately" -ForegroundColor White
    Write-Host "  3.  Restart Computer (30 second delay)" -ForegroundColor White
    Write-Host "  4.  Hibernate Computer" -ForegroundColor White
    Write-Host "  5.  Shutdown Computer Immediately" -ForegroundColor White
    Write-Host "  6.  Cancel Pending Shutdown/Restart" -ForegroundColor White
    Write-Host "  7.  Lock Screen" -ForegroundColor White
    Write-Host ""
    Write-Host "NETWORK CONTROL" -ForegroundColor Yellow
    Write-Host "  8.  Disable Wireless Adapters (Wi-Fi/Bluetooth)" -ForegroundColor White
    Write-Host "  9.  Disable ALL Network Adapters" -ForegroundColor White
    Write-Host "  10. Enable ALL Network Adapters" -ForegroundColor White
    Write-Host "  11. Turn Airplane Mode ON" -ForegroundColor White
    Write-Host "  12. Turn Airplane Mode OFF" -ForegroundColor White
    Write-Host ""
    Write-Host "PROCESS MANAGEMENT" -ForegroundColor Yellow
    Write-Host "  13. Kill Phone Link App" -ForegroundColor White
    Write-Host "  14. Kill Apex Legends" -ForegroundColor White
    Write-Host "  15. Monitor and Kill uTorrent Ads" -ForegroundColor White
    Write-Host ""
    Write-Host "SYSTEM CLEANUP & PRIVACY" -ForegroundColor Yellow
    Write-Host "  16. Empty Recycle Bin" -ForegroundColor White
    Write-Host "  17. Block Windows Search Telemetry" -ForegroundColor White
    Write-Host "  18. Unblock Windows Search Telemetry" -ForegroundColor White
    Write-Host ""
    Write-Host "  0.  Exit" -ForegroundColor Red
    Write-Host ""
    Write-Host "============================================================================" -ForegroundColor Cyan
    Write-Host ""
}

function Invoke-SelectedFunction {
    param([string]$Selection)

    switch ($Selection) {
        "1" {
            Write-Host "`nStarting Keep-Alive function..." -ForegroundColor Green
            Start-KeepAlive
        }
        "2" {
            Write-Host "`nInitiating immediate restart..." -ForegroundColor Yellow
            Restart-ComputerNow
        }
        "3" {
            Write-Host "`nScheduling restart in 30 seconds..." -ForegroundColor Yellow
            Restart-ComputerDelayed -Seconds 30
        }
        "4" {
            Write-Host "`nInitiating hibernation..." -ForegroundColor Yellow
            Start-Hibernation
        }
        "5" {
            Write-Host "`nInitiating immediate shutdown..." -ForegroundColor Yellow
            Stop-ComputerNow
        }
        "6" {
            Write-Host "`nCancelling pending shutdown/restart..." -ForegroundColor Green
            Stop-ScheduledShutdown
        }
        "7" {
            Write-Host "`nLocking screen..." -ForegroundColor Yellow
            Lock-ComputerScreen
        }
        "8" {
            Write-Host "`nDisabling wireless adapters..." -ForegroundColor Yellow
            Disable-WirelessAdapters
        }
        "9" {
            Write-Host "`nWARNING: This will disable ALL network connectivity!" -ForegroundColor Red
            $confirm = Read-Host "Type 'YES' to confirm"
            if ($confirm -eq "YES") {
                Disable-AllNetworkAdapters
            } else {
                Write-Host "Operation cancelled." -ForegroundColor Yellow
            }
        }
        "10" {
            Write-Host "`nEnabling all network adapters..." -ForegroundColor Green
            Enable-AllNetworkAdapters
        }
        "11" {
            Write-Host "`nEnabling Airplane Mode..." -ForegroundColor Yellow
            Set-AirplaneMode -State On
        }
        "12" {
            Write-Host "`nDisabling Airplane Mode..." -ForegroundColor Green
            Set-AirplaneMode -State Off
        }
        "13" {
            Write-Host "`nTerminating Phone Link application..." -ForegroundColor Yellow
            Stop-PhoneLinkApp
        }
        "14" {
            Write-Host "`nTerminating Apex Legends..." -ForegroundColor Yellow
            Stop-ApexLegends
        }
        "15" {
            Write-Host "`nStarting uTorrent ad monitoring..." -ForegroundColor Green
            Stop-UTorrentAds
        }
        "16" {
            Write-Host "`nEmptying Recycle Bin..." -ForegroundColor Yellow
            Clear-RecycleBinForced
        }
        "17" {
            Write-Host "`nBlocking Windows Search telemetry..." -ForegroundColor Yellow
            Block-WindowsSearchTelemetry
        }
        "18" {
            Write-Host "`nUnblocking Windows Search telemetry..." -ForegroundColor Green
            Unblock-WindowsSearchTelemetry
        }
        "0" {
            Write-Host "`nExiting..." -ForegroundColor Yellow
            exit
        }
        default {
            Write-Host "`nInvalid selection: $Selection" -ForegroundColor Red
        }
    }
}

# Main loop
do {
    Show-Menu

    # Prompt for single or multiple selections
    Write-Host "Enter option number(s):" -ForegroundColor Cyan -NoNewline
    Write-Host " (comma-separated for multiple, e.g., '8,16')" -ForegroundColor Gray
    $userInput = Read-Host "Selection"

    if ($userInput -eq "0") {
        Write-Host "`nExiting..." -ForegroundColor Yellow
        break
    }

    # Parse input - handle both single and comma-separated values
    $selections = $userInput.Split(',') | ForEach-Object { $_.Trim() }

    # Execute selected functions
    foreach ($selection in $selections) {
        try {
            Invoke-SelectedFunction -Selection $selection
        }
        catch {
            Write-Host "`nError executing function: $_" -ForegroundColor Red
        }
    }

    Write-Host "`n`nPress any key to return to menu..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

} while ($true)
