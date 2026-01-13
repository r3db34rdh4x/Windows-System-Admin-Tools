# Windows System Admin Tools - PowerShell Module
# Compatible with Windows 11
# Requires Administrator privileges for most functions

#Requires -RunAsAdministrator

# ============================================================================
# SYSTEM POWER FUNCTIONS
# ============================================================================

function Start-KeepAlive {
    <#
    .SYNOPSIS
    Prevents system sleep by sending Shift+F15 key combination periodically.
    .DESCRIPTION
    Sends Shift+F15 every 59 seconds to keep the system awake.
    Press Ctrl+C to stop.
    #>
    [CmdletBinding()]
    param()

    Write-Host "Keep-Alive started. Press Ctrl+C to stop." -ForegroundColor Green
    $wsh = New-Object -ComObject WScript.Shell
    try {
        while ($true) {
            $wsh.SendKeys('+{F15}')
            Start-Sleep -Seconds 59
        }
    }
    finally {
        [System.Runtime.Interopservices.Marshal]::ReleaseComObject($wsh) | Out-Null
    }
}

function Restart-ComputerNow {
    <#
    .SYNOPSIS
    Restarts the computer immediately.
    #>
    [CmdletBinding()]
    param()

    Write-Host "Restarting computer immediately..." -ForegroundColor Yellow
    Stop-Process -Name explorer -ErrorAction SilentlyContinue
    Start-Process -FilePath "shutdown.exe" -ArgumentList "/r /t 0" -NoNewWindow
}

function Restart-ComputerDelayed {
    <#
    .SYNOPSIS
    Restarts the computer after 30 seconds.
    #>
    [CmdletBinding()]
    param(
        [int]$Seconds = 30
    )

    Write-Host "Restarting computer in $Seconds seconds..." -ForegroundColor Yellow
    Stop-Process -Name explorer -ErrorAction SilentlyContinue
    Start-Process -FilePath "shutdown.exe" -ArgumentList "/r /t $Seconds" -NoNewWindow
}

function Start-Hibernation {
    <#
    .SYNOPSIS
    Hibernates the computer.
    #>
    [CmdletBinding()]
    param()

    Write-Host "Hibernating computer..." -ForegroundColor Yellow
    Stop-Process -Name explorer -ErrorAction SilentlyContinue
    Start-Process -FilePath "shutdown.exe" -ArgumentList "/h" -NoNewWindow
}

function Stop-ComputerNow {
    <#
    .SYNOPSIS
    Shuts down the computer immediately.
    #>
    [CmdletBinding()]
    param()

    Write-Host "Shutting down computer immediately..." -ForegroundColor Yellow
    Stop-Process -Name explorer -ErrorAction SilentlyContinue
    Start-Process -FilePath "shutdown.exe" -ArgumentList "/s /t 0" -NoNewWindow
}

function Stop-ScheduledShutdown {
    <#
    .SYNOPSIS
    Cancels any pending shutdown or restart.
    #>
    [CmdletBinding()]
    param()

    Write-Host "Cancelling pending shutdown/restart..." -ForegroundColor Green
    Start-Process -FilePath "shutdown.exe" -ArgumentList "/a" -NoNewWindow
}

function Lock-ComputerScreen {
    <#
    .SYNOPSIS
    Locks the computer screen.
    #>
    [CmdletBinding()]
    param()

    Write-Host "Locking screen..." -ForegroundColor Yellow
    rundll32.exe user32.dll,LockWorkStation
}

# ============================================================================
# NETWORK CONTROL FUNCTIONS - Windows 11 Compatible
# ============================================================================

function Disable-WirelessAdapters {
    <#
    .SYNOPSIS
    Disables all wireless network adapters (Wi-Fi, Bluetooth, etc.).
    .DESCRIPTION
    Uses multiple detection methods to identify and disable wireless adapters.
    Compatible with Windows 11 naming conventions.
    #>
    [CmdletBinding()]
    param()

    Write-Host "Disabling wireless adapters..." -ForegroundColor Yellow

    try {
        # Method 1: Disable adapters by MediaType (802.11 for wireless)
        $wirelessAdapters = Get-NetAdapter -Physical | Where-Object {
            $_.MediaType -like "*802.11*" -or
            $_.InterfaceDescription -like "*wireless*" -or
            $_.InterfaceDescription -like "*wi-fi*" -or
            $_.InterfaceDescription -like "*bluetooth*" -or
            $_.Name -like "*wi-fi*" -or
            $_.Name -like "*wireless*"
        }

        if ($wirelessAdapters) {
            foreach ($adapter in $wirelessAdapters) {
                Write-Host "Disabling: $($adapter.Name) - $($adapter.InterfaceDescription)" -ForegroundColor Cyan
                Disable-NetAdapter -Name $adapter.Name -Confirm:$false -ErrorAction Stop
            }
            Write-Host "Wireless adapters disabled successfully." -ForegroundColor Green
        }
        else {
            Write-Host "No wireless adapters found." -ForegroundColor Yellow
        }
    }
    catch {
        Write-Error "Failed to disable wireless adapters: $_"
    }
}

function Disable-AllNetworkAdapters {
    <#
    .SYNOPSIS
    Disables all network adapters on the system.
    .DESCRIPTION
    Disables all physical network adapters. Use with caution - this will disconnect
    all network connectivity including ethernet, Wi-Fi, and other connections.
    #>
    [CmdletBinding()]
    param()

    Write-Host "WARNING: Disabling ALL network adapters..." -ForegroundColor Red
    Write-Host "This will disconnect all network connectivity." -ForegroundColor Red

    try {
        # Get all physical network adapters that are currently up
        $adapters = Get-NetAdapter -Physical | Where-Object { $_.Status -eq "Up" }

        if ($adapters) {
            foreach ($adapter in $adapters) {
                Write-Host "Disabling: $($adapter.Name) - $($adapter.InterfaceDescription)" -ForegroundColor Cyan
                Disable-NetAdapter -Name $adapter.Name -Confirm:$false -ErrorAction Stop
            }

            # Flush DNS cache
            Write-Host "Flushing DNS cache..." -ForegroundColor Cyan
            ipconfig /flushdns | Out-Null

            Write-Host "All network adapters disabled successfully." -ForegroundColor Green
        }
        else {
            Write-Host "No active network adapters found." -ForegroundColor Yellow
        }
    }
    catch {
        Write-Error "Failed to disable network adapters: $_"
    }
}

function Enable-AllNetworkAdapters {
    <#
    .SYNOPSIS
    Re-enables all network adapters.
    .DESCRIPTION
    Enables all physical network adapters that were previously disabled.
    #>
    [CmdletBinding()]
    param()

    Write-Host "Enabling all network adapters..." -ForegroundColor Green

    try {
        $adapters = Get-NetAdapter -Physical | Where-Object { $_.Status -eq "Disabled" }

        if ($adapters) {
            foreach ($adapter in $adapters) {
                Write-Host "Enabling: $($adapter.Name) - $($adapter.InterfaceDescription)" -ForegroundColor Cyan
                Enable-NetAdapter -Name $adapter.Name -Confirm:$false -ErrorAction Stop
            }
            Write-Host "All network adapters enabled successfully." -ForegroundColor Green
        }
        else {
            Write-Host "No disabled network adapters found." -ForegroundColor Yellow
        }
    }
    catch {
        Write-Error "Failed to enable network adapters: $_"
    }
}

function Set-AirplaneMode {
    <#
    .SYNOPSIS
    Toggles airplane mode on or off.
    .DESCRIPTION
    Uses Windows 11 radio management to enable/disable airplane mode.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("On", "Off")]
        [string]$State
    )

    Write-Host "Setting Airplane Mode to: $State" -ForegroundColor Yellow

    try {
        if ($State -eq "On") {
            # Turn on airplane mode by disabling all radios
            Get-PnpDevice -Class Net | Where-Object {
                $_.FriendlyName -like "*wireless*" -or
                $_.FriendlyName -like "*wi-fi*" -or
                $_.FriendlyName -like "*bluetooth*"
            } | Disable-PnpDevice -Confirm:$false

            Write-Host "Airplane mode enabled." -ForegroundColor Green
        }
        else {
            # Turn off airplane mode by enabling all radios
            Get-PnpDevice -Class Net | Where-Object {
                ($_.FriendlyName -like "*wireless*" -or
                 $_.FriendlyName -like "*wi-fi*" -or
                 $_.FriendlyName -like "*bluetooth*") -and
                $_.Status -eq "Error"
            } | Enable-PnpDevice -Confirm:$false

            Write-Host "Airplane mode disabled." -ForegroundColor Green
        }
    }
    catch {
        Write-Error "Failed to set airplane mode: $_"
    }
}

# ============================================================================
# PROCESS MANAGEMENT FUNCTIONS
# ============================================================================

function Stop-PhoneLinkApp {
    <#
    .SYNOPSIS
    Terminates the Windows Phone Link application.
    .DESCRIPTION
    Stops PhoneExperienceHost and related Phone Link processes in Windows 11.
    #>
    [CmdletBinding()]
    param()

    Write-Host "Stopping Phone Link application..." -ForegroundColor Yellow

    $processes = @("PhoneExperienceHost", "YourPhone", "PhoneExperience")
    foreach ($proc in $processes) {
        try {
            Stop-Process -Name $proc -Force -ErrorAction SilentlyContinue
            Write-Host "Stopped: $proc" -ForegroundColor Cyan
        }
        catch {
            # Process may not be running
        }
    }
    Write-Host "Phone Link processes terminated." -ForegroundColor Green
}

function Stop-ApexLegends {
    <#
    .SYNOPSIS
    Terminates Apex Legends game process.
    #>
    [CmdletBinding()]
    param()

    Write-Host "Terminating Apex Legends..." -ForegroundColor Yellow

    try {
        Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
        Stop-Process -Name r5apex -Force -ErrorAction SilentlyContinue
        Stop-Process -Name ApexLegends -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 1
        Start-Process explorer.exe
        Write-Host "Apex Legends terminated successfully." -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to terminate Apex Legends: $_"
    }
}

function Stop-UTorrentAds {
    <#
    .SYNOPSIS
    Monitors and kills uTorrent advertisement processes.
    .DESCRIPTION
    Runs continuously to detect and terminate uTorrent ad processes.
    Press Ctrl+C to stop monitoring.
    #>
    [CmdletBinding()]
    param()

    Write-Host "Monitoring uTorrent ad processes. Press Ctrl+C to stop." -ForegroundColor Green

    try {
        while ($true) {
            $ads = Get-Process -Name "uTorrentie" -ErrorAction SilentlyContinue
            if ($ads) {
                foreach ($ad in $ads) {
                    Stop-Process -Id $ad.Id -Force
                    Write-Host "Killed uTorrent ad process (PID: $($ad.Id))" -ForegroundColor Cyan
                }
            }
            Start-Sleep -Seconds 2
        }
    }
    catch {
        Write-Host "Stopped monitoring uTorrent ads." -ForegroundColor Yellow
    }
}

# ============================================================================
# SYSTEM CLEANUP FUNCTIONS
# ============================================================================

function Clear-RecycleBinForced {
    <#
    .SYNOPSIS
    Empties the Recycle Bin without confirmation.
    #>
    [CmdletBinding()]
    param()

    Write-Host "Emptying Recycle Bin..." -ForegroundColor Yellow
    try {
        Clear-RecycleBin -Force -ErrorAction Stop
        Write-Host "Recycle Bin emptied successfully." -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to empty Recycle Bin: $_"
    }
}

# ============================================================================
# WINDOWS 11 SPECIFIC FUNCTIONS
# ============================================================================

function Block-WindowsSearchTelemetry {
    <#
    .SYNOPSIS
    Blocks Windows Search telemetry through firewall rules.
    .DESCRIPTION
    Creates firewall rules to block Windows Search from sending telemetry data
    while maintaining local search functionality. Windows 11 compatible.
    #>
    [CmdletBinding()]
    param()

    Write-Host "Configuring Windows Search firewall rules..." -ForegroundColor Yellow

    try {
        # Windows 11 Search paths
        $searchPaths = @(
            "$env:SystemRoot\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\SearchHost.exe",
            "$env:SystemRoot\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy\SearchApp.exe"
        )

        foreach ($path in $searchPaths) {
            if (Test-Path $path) {
                # Block outbound connections
                $ruleName = "Block Windows Search Outbound - $(Split-Path $path -Leaf)"

                # Remove existing rule if present
                Remove-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue

                New-NetFirewallRule -DisplayName $ruleName `
                    -Direction Outbound `
                    -Program $path `
                    -Action Block `
                    -Profile Any `
                    -ErrorAction Stop | Out-Null

                Write-Host "Created rule: $ruleName" -ForegroundColor Cyan
            }
        }

        Write-Host "Windows Search telemetry blocked successfully." -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to configure Windows Search firewall rules: $_"
    }
}

function Unblock-WindowsSearchTelemetry {
    <#
    .SYNOPSIS
    Removes firewall rules blocking Windows Search.
    #>
    [CmdletBinding()]
    param()

    Write-Host "Removing Windows Search firewall rules..." -ForegroundColor Yellow

    try {
        Get-NetFirewallRule -DisplayName "Block Windows Search*" -ErrorAction SilentlyContinue |
            Remove-NetFirewallRule

        Write-Host "Windows Search firewall rules removed." -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to remove Windows Search firewall rules: $_"
    }
}

# ============================================================================
# EXPORT MODULE FUNCTIONS
# ============================================================================

Export-ModuleMember -Function @(
    'Start-KeepAlive',
    'Restart-ComputerNow',
    'Restart-ComputerDelayed',
    'Start-Hibernation',
    'Stop-ComputerNow',
    'Stop-ScheduledShutdown',
    'Lock-ComputerScreen',
    'Disable-WirelessAdapters',
    'Disable-AllNetworkAdapters',
    'Enable-AllNetworkAdapters',
    'Set-AirplaneMode',
    'Stop-PhoneLinkApp',
    'Stop-ApexLegends',
    'Stop-UTorrentAds',
    'Clear-RecycleBinForced',
    'Block-WindowsSearchTelemetry',
    'Unblock-WindowsSearchTelemetry'
)
