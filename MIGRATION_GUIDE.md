# Migration Guide: Version 1.0 to 2.0

This guide explains the changes from the original scripts to the new Windows 11 compatible version.

## Overview of Changes

The scripts have been completely rewritten with:
- **Windows 11 compatibility** as the primary focus
- **Modular architecture** for better maintainability
- **Improved network functions** that actually work on Windows 11
- **Proper PowerShell conventions** and error handling

## What Changed

### 1. Network Functions - The Big Fix

#### OLD (Version 1.0) - What Didn't Work:
```powershell
# ShutdownWifi - Unreliable pattern matching
function ShutdownWifi {
    Get-NetAdapter -Physical | Where-Object {$_.Name -match "Wi-Fi|Wireless"} | Disable-NetAdapter -Confirm:$false
}

# DisableAllNetworking - Hardcoded names that don't exist on all systems
function DisableAllNetworking {
    netsh int ip reset
    netsh int wins reset
    ipconfig /flushdns
    Get-NetAdapter | Disable-NetAdapter -Confirm:$false
    netsh interface set interface name="Ethernet" admin=disable  # Often fails!
    netsh interface set interface name="Wi-Fi" admin=disable      # Often fails!
}
```

**Problems:**
- Hardcoded interface names ("Ethernet", "Wi-Fi") that may not exist
- Pattern matching "Wi-Fi|Wireless" missed many adapters
- No error handling
- Redundant netsh commands

#### NEW (Version 2.0) - What Works:
```powershell
function Disable-WirelessAdapters {
    # Multiple detection methods for reliability
    $wirelessAdapters = Get-NetAdapter -Physical | Where-Object {
        $_.MediaType -like "*802.11*" -or                    # Wi-Fi standard
        $_.InterfaceDescription -like "*wireless*" -or        # Description check
        $_.InterfaceDescription -like "*wi-fi*" -or
        $_.InterfaceDescription -like "*bluetooth*" -or
        $_.Name -like "*wi-fi*" -or                          # Name check
        $_.Name -like "*wireless*"
    }

    foreach ($adapter in $wirelessAdapters) {
        Write-Host "Disabling: $($adapter.Name)" -ForegroundColor Cyan
        Disable-NetAdapter -Name $adapter.Name -Confirm:$false -ErrorAction Stop
    }
}

function Disable-AllNetworkAdapters {
    # No hardcoded names - works with any adapter
    $adapters = Get-NetAdapter -Physical | Where-Object { $_.Status -eq "Up" }

    foreach ($adapter in $adapters) {
        Write-Host "Disabling: $($adapter.Name)" -ForegroundColor Cyan
        Disable-NetAdapter -Name $adapter.Name -Confirm:$false -ErrorAction Stop
    }

    ipconfig /flushdns | Out-Null
}
```

**Improvements:**
- ✅ Works with ANY adapter name
- ✅ Multiple detection methods (MediaType, Description, Name)
- ✅ Proper error handling
- ✅ User feedback with colored output
- ✅ No hardcoded interface names

### 2. Removed Cortana Functions

#### What Was Removed (No Longer Valid in Windows 11):
```powershell
# cortanaMuerto - Path doesn't exist in Windows 11
$cortanaPath = "C:\Windows\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy\SearchUI.exe"

# kissAliveCortana - Unblocking function
# effSearch - Old search path
```

**Why Removed:**
- Cortana is now a separate app in Windows 11 (installed from Microsoft Store)
- The old path `Microsoft.Windows.Cortana_cw5n1h2txyewy` no longer exists
- Windows Search is now separate from Cortana

#### What Replaced It:
```powershell
function Block-WindowsSearchTelemetry {
    # Updated Windows 11 paths
    $searchPaths = @(
        "$env:SystemRoot\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\SearchHost.exe",
        "$env:SystemRoot\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy\SearchApp.exe"
    )

    foreach ($path in $searchPaths) {
        if (Test-Path $path) {
            New-NetFirewallRule -DisplayName "Block Windows Search Outbound - $(Split-Path $path -Leaf)" `
                -Direction Outbound -Program $path -Action Block -Profile Any
        }
    }
}
```

### 3. Function Name Changes

All functions now follow proper PowerShell naming conventions:

| Old Name | New Name | Reason |
|----------|----------|--------|
| `Windows-Keepalive-F15` | `Start-KeepAlive` | Proper Verb-Noun format |
| `Restart-Immediately` | `Restart-ComputerNow` | More descriptive |
| `Restart-After30Seconds` | `Restart-ComputerDelayed` | Flexible parameter |
| `Hibernate-Computer` | `Start-Hibernation` | Standard PowerShell verb |
| `Shutdown-Immediately` | `Stop-ComputerNow` | Consistent with Restart |
| `Cancel-ShutdownRestart` | `Stop-ScheduledShutdown` | Clearer purpose |
| `Lock-Screen` | `Lock-ComputerScreen` | More specific noun |
| `EmptyRecycle` | `Clear-RecycleBinForced` | Indicates no confirmation |
| `ShutdownWifi` | `Disable-WirelessAdapters` | More accurate description |
| `DisableAllNetworking` | `Disable-AllNetworkAdapters` | Clearer scope |
| `ResumeAllNetworking` | `Enable-AllNetworkAdapters` | Consistent verb |
| `Kill-PhoneExperienceHost` | `Stop-PhoneLinkApp` | Windows 11 name |
| `KillApex` | `Stop-ApexLegends` | Standard verb |
| `killuTorrentAds` | `Stop-UTorrentAds` | Consistent casing |

### 4. New Features Added

#### Airplane Mode Control
```powershell
Set-AirplaneMode -State On   # Enable airplane mode
Set-AirplaneMode -State Off  # Disable airplane mode
```

#### Module System
Functions are now in a reusable module:
```powershell
Import-Module .\modules\SystemControlFunctions.psm1
Get-Command -Module SystemControlFunctions
```

#### Quick Actions Script
Command-line interface for automation:
```powershell
.\QuickActions.ps1 -Action DisableWifi
.\QuickActions.ps1 -Action ListNetworkAdapters
```

#### Enhanced Menu System
- Multi-selection support (comma-separated)
- Color-coded output
- Better error messages
- Confirmation prompts for dangerous operations

### 5. Project Structure Changes

#### OLD Structure:
```
Local-PC-HackTrick-Scripts/
├── Windows-Hacker-Controls-SwitchCase.ps1
├── windows-hacker-controls-launcher.bat
├── (various other .bat files)
└── (no organization)
```

#### NEW Structure:
```
Windows-System-Admin-Tools/
├── launchers/              # Batch launchers
│   ├── Launch-SystemControl.bat
│   ├── ImmediateRestart.bat
│   ├── DelayedRestart.bat
│   └── Hibernate.bat
├── scripts/                # PowerShell scripts
│   ├── SystemControlMenu.ps1
│   ├── QuickActions.ps1
│   └── KeepAlive.ps1
├── modules/                # Reusable modules
│   └── SystemControlFunctions.psm1
├── docs/                   # Documentation
│   ├── FUNCTIONS.md
│   └── QUICKSTART.md
├── README.md
├── LICENSE
├── CHANGELOG.md
├── MIGRATION_GUIDE.md
└── .gitignore
```

## How to Use the New Version

### If you used the old switch-case script:

**OLD WAY:**
```batch
:: Run the launcher
windows-hacker-controls-launcher.bat

:: Select from menu
Enter the numbers: 10,11
```

**NEW WAY (Same concept, better execution):**
```batch
:: Run the new launcher
Launch-SystemControl.bat

:: Select from menu (comma-separated still works)
Enter option number(s): 8,16
```

### If you used individual functions:

**OLD WAY:**
```powershell
# Source the functions
. .\Windows-Hacker-Controls-SwitchCase.ps1

# Call function directly (wouldn't work due to switch-case structure)
ShutdownWifi
```

**NEW WAY:**
```powershell
# Import the module
Import-Module .\modules\SystemControlFunctions.psm1

# Call function directly (works perfectly)
Disable-WirelessAdapters

# Or use Quick Actions
.\scripts\QuickActions.ps1 -Action DisableWifi
```

## Testing Your Migration

### 1. Test Network Functions (Most Important)

```powershell
# List your adapters
Get-NetAdapter -Physical | Format-Table Name, Status, MediaType, InterfaceDescription

# Test wireless disable (should work now!)
Import-Module .\modules\SystemControlFunctions.psm1
Disable-WirelessAdapters

# Verify they're disabled
Get-NetAdapter -Physical | Where-Object {$_.Status -eq "Disabled"}

# Re-enable
Enable-AllNetworkAdapters
```

### 2. Test Other Functions

```powershell
# Test keep-alive (standalone script)
.\scripts\KeepAlive.ps1
# Press Ctrl+C after a few seconds

# Test recycle bin
Clear-RecycleBinForced

# Test Phone Link termination
Stop-PhoneLinkApp
```

### 3. Test the Menu System

```batch
# Run the launcher
launchers\Launch-SystemControl.bat

# Try single selection: 16 (Empty Recycle Bin)
# Try multiple selection: 8,16 (Disable Wi-Fi + Empty Recycle Bin)
```

## Backward Compatibility Notes

### What Works the Same:
- ✅ Basic functionality (restart, shutdown, hibernate, lock)
- ✅ Keep-alive script (now standalone)
- ✅ Process termination (Apex, Phone Link, uTorrent ads)
- ✅ Recycle bin clearing

### What Works Better:
- ✅ Network adapter disable/enable (no more hardcoded names!)
- ✅ Error handling (functions won't silently fail)
- ✅ User feedback (color-coded messages)

### What's Different:
- ⚠️ Function names changed (but functionality is the same)
- ⚠️ Cortana blocking removed (not applicable to Windows 11)
- ⚠️ Windows Search blocking updated (different paths)
- ⚠️ Must import module or use launcher (functions aren't global)

## Troubleshooting Migration

### "Function not found" error
**Old:** Functions were global after running the script
**New:** Must import the module first

```powershell
Import-Module .\modules\SystemControlFunctions.psm1
```

### Network functions still not working
Run diagnostics:
```powershell
# Check PowerShell version (need 5.1+)
$PSVersionTable.PSVersion

# Check adapter names
Get-NetAdapter -Physical | Format-List Name, Status, MediaType, InterfaceDescription

# Check permissions
net session  # Should not error if you're admin
```

### Old batch files don't work
The old launcher pointed to the old script. Update your shortcuts to use:
```
launchers\Launch-SystemControl.bat
```

## Recommended Next Steps

1. **Test the new network functions** - This is the biggest improvement
2. **Create desktop shortcuts** - See QUICKSTART.md
3. **Read FUNCTIONS.md** - Complete documentation for all functions
4. **Star the repo** - If you're using GitHub
5. **Report issues** - If you find bugs or have suggestions

## Questions?

### Why the complete rewrite?
The old version had fundamental issues that couldn't be fixed with small patches:
- Hardcoded network names
- No error handling
- Windows 11 incompatibilities
- Poor code organization

### Can I still use the old version?
You can, but it won't work reliably on Windows 11, especially the network functions.

### Will this work on Windows 10?
Yes! The new version is backward compatible with Windows 10 while adding Windows 11 support.

### Are there any breaking changes?
Only the function names changed. The functionality is the same or better.

---

**Welcome to Version 2.0!** The scripts you relied on are now better, faster, and actually work on Windows 11. 🚀
