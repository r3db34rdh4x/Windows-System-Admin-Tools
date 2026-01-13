# Function Documentation

Complete reference for all functions in the Windows System Administration Tools module.

## Table of Contents

- [Power Management Functions](#power-management-functions)
- [Network Control Functions](#network-control-functions)
- [Process Management Functions](#process-management-functions)
- [System Cleanup Functions](#system-cleanup-functions)
- [Privacy Functions](#privacy-functions)

---

## Power Management Functions

### Start-KeepAlive

Prevents the system from going to sleep by sending Shift+F15 key combination every 59 seconds.

**Syntax:**
```powershell
Start-KeepAlive
```

**Parameters:** None

**Examples:**
```powershell
Start-KeepAlive
# Press Ctrl+C to stop
```

**Notes:**
- Does not require administrator privileges
- Simulates user activity to prevent sleep/screensaver
- F15 is a safe key that doesn't interfere with most applications
- Must be manually stopped with Ctrl+C

---

### Restart-ComputerNow

Restarts the computer immediately without delay.

**Syntax:**
```powershell
Restart-ComputerNow
```

**Parameters:** None

**Examples:**
```powershell
Restart-ComputerNow
```

**Notes:**
- Requires administrator privileges
- Terminates Explorer before restart
- No confirmation prompt
- Use `Stop-ScheduledShutdown` to cancel if needed

---

### Restart-ComputerDelayed

Schedules a computer restart after a specified delay.

**Syntax:**
```powershell
Restart-ComputerDelayed [-Seconds <Int32>]
```

**Parameters:**
- `Seconds` (optional) - Delay in seconds before restart. Default: 30

**Examples:**
```powershell
Restart-ComputerDelayed
Restart-ComputerDelayed -Seconds 60
```

**Notes:**
- Requires administrator privileges
- Shows a countdown notification
- Can be cancelled with `Stop-ScheduledShutdown`

---

### Start-Hibernation

Hibernates the computer, saving current state to disk.

**Syntax:**
```powershell
Start-Hibernation
```

**Parameters:** None

**Examples:**
```powershell
Start-Hibernation
```

**Notes:**
- Requires administrator privileges
- Requires hibernation to be enabled on the system
- Saves RAM contents to hiberfil.sys
- Faster resume than full shutdown

---

### Stop-ComputerNow

Shuts down the computer immediately.

**Syntax:**
```powershell
Stop-ComputerNow
```

**Parameters:** None

**Examples:**
```powershell
Stop-ComputerNow
```

**Notes:**
- Requires administrator privileges
- No confirmation prompt
- Terminates Explorer before shutdown

---

### Stop-ScheduledShutdown

Cancels any pending shutdown or restart operation.

**Syntax:**
```powershell
Stop-ScheduledShutdown
```

**Parameters:** None

**Examples:**
```powershell
Stop-ScheduledShutdown
```

**Notes:**
- Requires administrator privileges
- Works for shutdowns scheduled with `/t` parameter
- Displays confirmation message

---

### Lock-ComputerScreen

Locks the computer screen, requiring password to unlock.

**Syntax:**
```powershell
Lock-ComputerScreen
```

**Parameters:** None

**Examples:**
```powershell
Lock-ComputerScreen
```

**Notes:**
- Does not require administrator privileges
- Equivalent to Win+L keyboard shortcut
- Immediate effect

---

## Network Control Functions

### Disable-WirelessAdapters

Disables all wireless network adapters including Wi-Fi and Bluetooth.

**Syntax:**
```powershell
Disable-WirelessAdapters
```

**Parameters:** None

**Examples:**
```powershell
Disable-WirelessAdapters
```

**Notes:**
- Requires administrator privileges
- Uses multiple detection methods for Windows 11 compatibility:
  - MediaType (802.11)
  - Interface description pattern matching
  - Adapter name pattern matching
- Displays each adapter being disabled
- Does not affect wired (Ethernet) connections

**Detection Methods:**
1. Checks for MediaType containing "802.11" (Wi-Fi standard)
2. Searches interface descriptions for "wireless", "wi-fi", "bluetooth"
3. Searches adapter names for "wi-fi", "wireless"

---

### Disable-AllNetworkAdapters

Disables ALL physical network adapters on the system.

**Syntax:**
```powershell
Disable-AllNetworkAdapters
```

**Parameters:** None

**Examples:**
```powershell
Disable-AllNetworkAdapters
```

**Notes:**
- Requires administrator privileges
- ⚠️ **WARNING**: This will disconnect ALL network connectivity
- Disables all physical adapters (Wi-Fi, Ethernet, etc.)
- Flushes DNS cache after disabling adapters
- Use `Enable-AllNetworkAdapters` to restore connectivity
- Only disables adapters that are currently "Up"

**Use Cases:**
- Emergency network disconnect
- Security testing
- Offline work mode
- Network troubleshooting

---

### Enable-AllNetworkAdapters

Re-enables all disabled network adapters.

**Syntax:**
```powershell
Enable-AllNetworkAdapters
```

**Parameters:** None

**Examples:**
```powershell
Enable-AllNetworkAdapters
```

**Notes:**
- Requires administrator privileges
- Enables all physical adapters with "Disabled" status
- Use after `Disable-AllNetworkAdapters` to restore connectivity
- Displays each adapter being enabled

---

### Set-AirplaneMode

Toggles Windows airplane mode on or off.

**Syntax:**
```powershell
Set-AirplaneMode -State <String>
```

**Parameters:**
- `State` (required) - Either "On" or "Off"

**Examples:**
```powershell
Set-AirplaneMode -State On
Set-AirplaneMode -State Off
```

**Notes:**
- Requires administrator privileges
- Uses PnP device management
- Affects all wireless radios (Wi-Fi, Bluetooth, Cellular)
- Windows 11 compatible implementation

---

## Process Management Functions

### Stop-PhoneLinkApp

Terminates the Windows Phone Link application and related processes.

**Syntax:**
```powershell
Stop-PhoneLinkApp
```

**Parameters:** None

**Examples:**
```powershell
Stop-PhoneLinkApp
```

**Notes:**
- Requires administrator privileges
- Terminates multiple related processes:
  - PhoneExperienceHost
  - YourPhone
  - PhoneExperience
- Silently continues if processes aren't running
- Windows 11 Phone Link compatible

---

### Stop-ApexLegends

Terminates Apex Legends game process and restarts Explorer.

**Syntax:**
```powershell
Stop-ApexLegends
```

**Parameters:** None

**Examples:**
```powershell
Stop-ApexLegends
```

**Notes:**
- Requires administrator privileges
- Force-terminates game processes:
  - r5apex.exe (main game process)
  - ApexLegends.exe
- Restarts Windows Explorer after termination
- Useful for closing unresponsive game instances

---

### Stop-UTorrentAds

Monitors and kills uTorrent advertisement processes in real-time.

**Syntax:**
```powershell
Stop-UTorrentAds
```

**Parameters:** None

**Examples:**
```powershell
Stop-UTorrentAds
# Press Ctrl+C to stop monitoring
```

**Notes:**
- Requires administrator privileges
- Runs continuously in a loop
- Checks every 2 seconds for "uTorrentie" processes
- Displays PID of each killed ad process
- Press Ctrl+C to stop monitoring
- Does not interfere with main uTorrent application

---

## System Cleanup Functions

### Clear-RecycleBinForced

Empties the Recycle Bin without confirmation.

**Syntax:**
```powershell
Clear-RecycleBinForced
```

**Parameters:** None

**Examples:**
```powershell
Clear-RecycleBinForced
```

**Notes:**
- Requires administrator privileges
- No confirmation prompt (use with caution)
- Permanently deletes all items in Recycle Bin
- Cannot be undone

---

## Privacy Functions

### Block-WindowsSearchTelemetry

Creates firewall rules to block Windows Search from sending telemetry data.

**Syntax:**
```powershell
Block-WindowsSearchTelemetry
```

**Parameters:** None

**Examples:**
```powershell
Block-WindowsSearchTelemetry
```

**Notes:**
- Requires administrator privileges
- Windows 11 compatible paths:
  - `SearchHost.exe` (Windows 11 Client CBS)
  - `SearchApp.exe` (Legacy path)
- Creates outbound firewall block rules
- Local search functionality remains intact
- Only blocks telemetry/cloud connections
- Rule names: "Block Windows Search Outbound - [executable]"

**What it blocks:**
- Telemetry data transmission
- Cloud search suggestions
- Search history sync

**What remains functional:**
- Local file search
- Start menu search
- Settings search

---

### Unblock-WindowsSearchTelemetry

Removes firewall rules created by Block-WindowsSearchTelemetry.

**Syntax:**
```powershell
Unblock-WindowsSearchTelemetry
```

**Parameters:** None

**Examples:**
```powershell
Unblock-WindowsSearchTelemetry
```

**Notes:**
- Requires administrator privileges
- Removes all firewall rules matching "Block Windows Search*"
- Restores default Windows Search behavior
- Re-enables cloud features and telemetry

---

## Quick Reference Table

| Function | Admin Required | Windows 11 | Destructive | Reversible |
|----------|----------------|------------|-------------|------------|
| Start-KeepAlive | No | Yes | No | Manual stop |
| Restart-ComputerNow | Yes | Yes | Yes | No |
| Restart-ComputerDelayed | Yes | Yes | Yes | Yes (Cancel) |
| Start-Hibernation | Yes | Yes | No | Resume |
| Stop-ComputerNow | Yes | Yes | Yes | No |
| Stop-ScheduledShutdown | Yes | Yes | No | N/A |
| Lock-ComputerScreen | No | Yes | No | Unlock |
| Disable-WirelessAdapters | Yes | Yes | No | Yes |
| Disable-AllNetworkAdapters | Yes | Yes | Yes | Yes |
| Enable-AllNetworkAdapters | Yes | Yes | No | N/A |
| Set-AirplaneMode | Yes | Yes | No | Toggle |
| Stop-PhoneLinkApp | Yes | Yes | No | Restart app |
| Stop-ApexLegends | Yes | Yes | No | Restart game |
| Stop-UTorrentAds | Yes | Yes | No | Manual stop |
| Clear-RecycleBinForced | Yes | Yes | Yes | No |
| Block-WindowsSearchTelemetry | Yes | Yes | No | Yes |
| Unblock-WindowsSearchTelemetry | Yes | Yes | No | N/A |

---

## Error Handling

All functions include try-catch error handling with descriptive error messages. Common errors:

### "Access Denied"
**Solution**: Run PowerShell as Administrator

### "Cannot find path"
**Solution**: Verify module is properly installed and imported

### "Adapter not found"
**Solution**: Use `Get-NetAdapter` to verify adapter names

### "Operation failed"
**Solution**: Check Windows Event Viewer for detailed error information

---

## Examples: Combining Functions

### Emergency Network Disconnect
```powershell
Import-Module .\modules\SystemControlFunctions.psm1
Disable-AllNetworkAdapters
Block-WindowsSearchTelemetry
```

### Secure Workstation Lock
```powershell
Lock-ComputerScreen
Disable-WirelessAdapters
```

### Clean Restart
```powershell
Clear-RecycleBinForced
Restart-ComputerDelayed -Seconds 60
```

### Network Reset
```powershell
Disable-AllNetworkAdapters
Start-Sleep -Seconds 5
Enable-AllNetworkAdapters
```
