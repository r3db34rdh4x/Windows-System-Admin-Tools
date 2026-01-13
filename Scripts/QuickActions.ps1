#Requires -RunAsAdministrator

<#
.SYNOPSIS
    Quick action scripts for common tasks
.DESCRIPTION
    Individual functions that can be called directly from command line
    Example: .\QuickActions.ps1 -Action DisableWifi
#>

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet(
        'DisableWifi',
        'EnableWifi',
        'DisableAllNetwork',
        'EnableAllNetwork',
        'EmptyRecycleBin',
        'LockScreen',
        'KillPhoneLink',
        'ListNetworkAdapters'
    )]
    [string]$Action
)

# Import the module
$modulePath = Join-Path $PSScriptRoot "..\modules\SystemControlFunctions.psm1"
Import-Module $modulePath -Force

# Execute the requested action
switch ($Action) {
    'DisableWifi' {
        Write-Host "Disabling wireless adapters..." -ForegroundColor Yellow
        Disable-WirelessAdapters
    }
    'EnableWifi' {
        Write-Host "Enabling wireless adapters..." -ForegroundColor Green
        Enable-AllNetworkAdapters
    }
    'DisableAllNetwork' {
        Write-Host "Disabling all network adapters..." -ForegroundColor Red
        Disable-AllNetworkAdapters
    }
    'EnableAllNetwork' {
        Write-Host "Enabling all network adapters..." -ForegroundColor Green
        Enable-AllNetworkAdapters
    }
    'EmptyRecycleBin' {
        Write-Host "Emptying Recycle Bin..." -ForegroundColor Yellow
        Clear-RecycleBinForced
    }
    'LockScreen' {
        Write-Host "Locking screen..." -ForegroundColor Yellow
        Lock-ComputerScreen
    }
    'KillPhoneLink' {
        Write-Host "Terminating Phone Link..." -ForegroundColor Yellow
        Stop-PhoneLinkApp
    }
    'ListNetworkAdapters' {
        Write-Host "`nPhysical Network Adapters:" -ForegroundColor Cyan
        Get-NetAdapter -Physical | Format-Table Name, Status, LinkSpeed, MediaType, InterfaceDescription -AutoSize
    }
}

Write-Host "`nAction completed." -ForegroundColor Green
