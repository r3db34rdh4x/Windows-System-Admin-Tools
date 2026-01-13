# Changelog

All notable changes to Windows System Administration Tools will be documented in this file.

## [2.0.0] - 2025-01-13

### Major Rewrite for Windows 11 Compatibility

#### Added
- Modular PowerShell architecture with separate module file (`SystemControlFunctions.psm1`)
- Interactive menu system with multi-selection support
- Quick Actions script for command-line usage
- Comprehensive help documentation for all functions
- Airplane mode toggle functionality
- Enhanced network adapter detection methods
- Proper error handling throughout all functions
- GitHub-ready project structure
- Complete function documentation (`docs/FUNCTIONS.md`)
- MIT License
- .gitignore file for version control

#### Changed
- **Network Functions** - Complete rewrite for Windows 11
  - `Disable-WirelessAdapters`: Now uses multiple detection methods (MediaType, InterfaceDescription, Name patterns)
  - `Disable-AllNetworkAdapters`: Improved to work with Windows 11 network stack
  - `Enable-AllNetworkAdapters`: Better status detection and feedback
  - Added new `Set-AirplaneMode` function for airplane mode control

- **Removed Cortana Functions** - No longer applicable in Windows 11
  - Removed `cortanaMuerto` (Cortana is now a separate app)
  - Removed `kissAliveCortana`
  - Removed `effSearch` (old implementation)

- **Updated Windows Search Privacy**
  - `Block-WindowsSearchTelemetry`: Updated paths for Windows 11 (`SearchHost.exe`)
  - `Unblock-WindowsSearchTelemetry`: Updated to match new rule names

- **Process Management**
  - `Stop-PhoneLinkApp`: Updated for Windows 11 Phone Link (formerly "Your Phone")
  - `Stop-ApexLegends`: Fixed PowerShell syntax errors
  - `Stop-UTorrentAds`: Improved error handling

- **Naming Conventions**
  - Renamed all functions to use proper PowerShell verb-noun format
  - `Windows-Keepalive-F15` → `Start-KeepAlive`
  - `Restart-Immediately` → `Restart-ComputerNow`
  - `Restart-After30Seconds` → `Restart-ComputerDelayed`
  - `Hibernate-Computer` → `Start-Hibernation`
  - `Shutdown-Immediately` → `Stop-ComputerNow`
  - `Cancel-ShutdownRestart` → `Stop-ScheduledShutdown`
  - `Lock-Screen` → `Lock-ComputerScreen`
  - `EmptyRecycle` → `Clear-RecycleBinForced`
  - `ShutdownWifi` → `Disable-WirelessAdapters`
  - `DisableAllNetworking` → `Disable-AllNetworkAdapters`
  - `ResumeAllNetworking` → `Enable-AllNetworkAdapters`
  - `Kill-PhoneExperienceHost` → `Stop-PhoneLinkApp`
  - `KillApex` → `Stop-ApexLegends`
  - `killuTorrentAds` → `Stop-UTorrentAds`

#### Improved
- PowerShell syntax consistency across all functions
- User feedback with colored console output
- Error messages are more descriptive
- Admin rights checking in launchers
- Module export declarations
- Code organization and readability
- Comment-based help for all functions

#### Fixed
- Network adapter detection issues on Windows 11
- PowerShell syntax errors in various functions
- Missing error handling in critical operations
- Hardcoded network interface names
- Incorrect paths for Windows 11 system apps

#### Removed
- Deprecated Cortana blocking functions (not applicable to Windows 11)
- Hardcoded network interface names
- Redundant netsh commands in network functions

---

## [1.0.0] - Original Version

### Features
- Basic switch-case menu system
- Power management functions (restart, shutdown, hibernate)
- Simple network disable functions
- Process termination utilities
- Cortana blocking (Windows 10)
- Windows Search blocking
- uTorrent ad blocker

### Known Issues (Fixed in 2.0)
- Network functions used hardcoded interface names ("Ethernet", "Wi-Fi")
- Wireless adapter detection not reliable on Windows 11
- Cortana paths no longer valid in Windows 11
- Inconsistent PowerShell syntax
- No error handling
- No help documentation
- Mixed verb naming conventions
