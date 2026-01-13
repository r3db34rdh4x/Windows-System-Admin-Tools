# Windows System Administration Tools

A collection of PowerShell scripts and batch files for common Windows 11 system administration tasks. These tools provide quick access to power management, network control, process management, and system cleanup functions.

## Features

### Power Management
- Keep system awake (anti-sleep using Shift+F15)
- Restart computer (immediate or delayed)
- Hibernate system
- Shutdown computer
- Cancel pending shutdowns
- Lock screen

### Network Control (Windows 11 Compatible)
- Disable/enable wireless adapters (Wi-Fi, Bluetooth)
- Disable/enable all network adapters
- Airplane mode control
- Improved adapter detection for Windows 11

### Process Management
- Terminate Phone Link application
- Kill Apex Legends game process
- Monitor and terminate uTorrent ad processes

### System Cleanup & Privacy
- Empty Recycle Bin
- Block/unblock Windows Search telemetry

## Installation

1. Clone or download this repository
2. Extract to a folder of your choice (e.g., `C:\Tools\Windows-System-Admin-Tools`)
3. **Important**: Most functions require Administrator privileges

## Usage

### Option 1: Interactive Menu (Recommended)

Right-click `launchers\Launch-SystemControl.bat` and select **"Run as administrator"**

This launches an interactive menu where you can:
- Select single options by entering a number
- Execute multiple functions by entering comma-separated numbers (e.g., `8,16`)

### Option 2: Quick Actions

For command-line usage, use the QuickActions script:

```powershell
# Examples (run PowerShell as Administrator):
.\scripts\QuickActions.ps1 -Action DisableWifi
.\scripts\QuickActions.ps1 -Action EnableAllNetwork
.\scripts\QuickActions.ps1 -Action ListNetworkAdapters
.\scripts\QuickActions.ps1 -Action EmptyRecycleBin
```

Available actions:
- `DisableWifi` - Disable all wireless adapters
- `EnableWifi` - Enable wireless adapters
- `DisableAllNetwork` - Disable all network adapters
- `EnableAllNetwork` - Enable all network adapters
- `EmptyRecycleBin` - Empty Recycle Bin
- `LockScreen` - Lock the screen
- `KillPhoneLink` - Terminate Phone Link app
- `ListNetworkAdapters` - Show all network adapters

### Option 3: Standalone Scripts

Individual scripts can be run directly:

- `scripts\KeepAlive.ps1` - Prevent system sleep (no admin required)
- `launchers\ImmediateRestart.bat` - Restart now
- `launchers\DelayedRestart.bat` - Restart in 30 seconds
- `launchers\Hibernate.bat` - Hibernate system

### Option 4: Import PowerShell Module

Import the module to use functions in your own scripts:

```powershell
Import-Module ".\modules\SystemControlFunctions.psm1"

# Then call functions directly:
Disable-WirelessAdapters
Enable-AllNetworkAdapters
Clear-RecycleBinForced
```

## Requirements

- **Operating System**: Windows 11 (also compatible with Windows 10)
- **PowerShell**: Version 5.1 or higher
- **Privileges**: Administrator rights required for most functions
- **Execution Policy**: Scripts use `-ExecutionPolicy Bypass` when launched via batch files

## Project Structure

```
Windows-System-Admin-Tools/
├── launchers/              # Batch file launchers
│   ├── Launch-SystemControl.bat
│   ├── ImmediateRestart.bat
│   ├── DelayedRestart.bat
│   └── Hibernate.bat
├── scripts/                # PowerShell scripts
│   ├── SystemControlMenu.ps1
│   ├── QuickActions.ps1
│   └── KeepAlive.ps1
├── modules/                # PowerShell modules
│   └── SystemControlFunctions.psm1
├── docs/                   # Documentation
│   └── FUNCTIONS.md
└── README.md
```

## Windows 11 Improvements

This updated version includes the following Windows 11 compatibility improvements:

### Enhanced Network Adapter Detection
- Uses multiple detection methods (MediaType, InterfaceDescription, Name patterns)
- Properly identifies 802.11 wireless adapters
- Compatible with Windows 11 adapter naming conventions
- Better handling of Bluetooth and other wireless technologies

### Updated Functions
- Removed deprecated Cortana blocking (Cortana is now a separate app in Windows 11)
- Updated Windows Search telemetry blocking for Windows 11 paths
- Improved Phone Link termination (updated process names)
- Added airplane mode toggle functionality
- Better error handling and user feedback

### Code Quality
- Proper PowerShell syntax and conventions
- Added comprehensive help documentation
- Modular design with reusable functions
- Improved error handling

## Safety Notes

⚠️ **Important Warnings:**

1. **Network Disabling**: The "Disable All Network Adapters" function will disconnect ALL network connectivity. Use with caution.
2. **Administrator Rights**: Most functions require elevated privileges. Always run as Administrator.
3. **System Restart**: Restart and shutdown functions will terminate your session immediately or after a short delay.
4. **Firewall Rules**: Privacy functions create Windows Firewall rules. Review them if you have custom firewall configurations.

## Troubleshooting

### "Cannot run script" or "Execution policy" error
The launcher batch files use `-ExecutionPolicy Bypass` to handle this. If running scripts directly:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### "Access Denied" errors
Ensure you're running PowerShell or batch files as Administrator (right-click > Run as administrator).

### Network adapter functions not working
Run the following to list your adapters:
```powershell
Get-NetAdapter -Physical | Format-Table Name, Status, MediaType, InterfaceDescription
```

## License

This project is provided as-is for personal and educational use. Use at your own risk.

## Disclaimer

These tools are intended for system administration of computers you own or have explicit authorization to manage. The author is not responsible for misuse or any damage caused by these tools.

## Contributing

Contributions, issues, and feature requests are welcome. Feel free to check the issues page or submit a pull request.

## Version History

### Version 2.0 (Current)
- Complete rewrite for Windows 11 compatibility
- Improved network adapter detection and management
- Modular PowerShell design
- Enhanced error handling
- Better user interface
- Updated all functions for modern Windows

### Version 1.0 (Legacy)
- Original switch-case script
- Basic Windows 10 functionality
