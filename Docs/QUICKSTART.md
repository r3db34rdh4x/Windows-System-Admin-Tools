# Quick Start Guide

Get started with Windows System Administration Tools in 5 minutes.

## Step 1: Extract Files

Extract the repository to a permanent location, for example:
```
C:\Tools\Windows-System-Admin-Tools\
```

## Step 2: Launch the Tool

### Option A: Using the Launcher (Recommended)

1. Navigate to the `launchers` folder
2. **Right-click** on `Launch-SystemControl.bat`
3. Select **"Run as administrator"**

That's it! You'll see an interactive menu.

### Option B: Using PowerShell Directly

```powershell
# Open PowerShell as Administrator
cd "C:\Tools\Windows-System-Admin-Tools\scripts"
.\SystemControlMenu.ps1
```

## Step 3: Select Functions

### Single Function
Type a number and press Enter:
```
Selection: 8
```
This will disable wireless adapters.

### Multiple Functions
Enter comma-separated numbers:
```
Selection: 8,16
```
This will disable wireless adapters AND empty the recycle bin.

## Common Use Cases

### Quickly Disable Wi-Fi
```
Launch menu → Enter: 8
```

### Prepare for Restart
```
Launch menu → Enter: 16,3
```
(Empties recycle bin, then restarts in 30 seconds)

### Emergency Network Disconnect
```
Launch menu → Enter: 9
```
**Warning**: Disconnects ALL network connectivity!

### Keep System Awake During Long Task
```
Launch menu → Enter: 1
```
Press Ctrl+C when done.

## Using Quick Actions (Command Line)

For automation or quick access, use QuickActions:

```powershell
# Open PowerShell as Administrator
cd "C:\Tools\Windows-System-Admin-Tools\scripts"

# Disable Wi-Fi
.\QuickActions.ps1 -Action DisableWifi

# List all network adapters
.\QuickActions.ps1 -Action ListNetworkAdapters

# Re-enable all network
.\QuickActions.ps1 -Action EnableAllNetwork
```

## Standalone Scripts

Some tasks have dedicated scripts:

### Keep System Awake (No Admin Needed)
```powershell
cd "C:\Tools\Windows-System-Admin-Tools\scripts"
.\KeepAlive.ps1
```

### Quick Restart (Admin Required)
Double-click: `launchers\ImmediateRestart.bat`

### Delayed Restart (Admin Required)
Double-click: `launchers\DelayedRestart.bat`

### Hibernate (Admin Required)
Double-click: `launchers\Hibernate.bat`

## Creating Desktop Shortcuts

### For the Main Menu

1. Right-click on `launchers\Launch-SystemControl.bat`
2. Select **"Send to" → "Desktop (create shortcut)"**
3. Right-click the new shortcut → **Properties**
4. Click **Advanced** → Check **"Run as administrator"** → OK
5. Optionally change the icon

Now you can launch the tool from your desktop!

### For Quick Actions

Create a shortcut with:
```
Target: powershell.exe -ExecutionPolicy Bypass -File "C:\Tools\Windows-System-Admin-Tools\scripts\QuickActions.ps1" -Action DisableWifi
Start in: C:\Tools\Windows-System-Admin-Tools\scripts
```

## Troubleshooting

### "This app has been blocked by your administrator"
Right-click the batch file → Properties → Check "Unblock" → Apply

### "Execution policy" error
The batch launchers handle this automatically. If running PowerShell directly:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### "Access Denied"
You must run as Administrator for most functions. Right-click → "Run as administrator"

### Network function doesn't work
Check your adapter names:
```powershell
Get-NetAdapter -Physical | Format-Table Name, Status, MediaType
```

## Security Notes

⚠️ **These tools require admin rights** - they make system-level changes

⚠️ **Network disable functions** - Will disconnect you from the network

⚠️ **Restart/Shutdown functions** - Have minimal or no delay

Always save your work before using power management functions!

## Next Steps

- Read the [Full README](../README.md) for complete feature list
- Review [Function Documentation](FUNCTIONS.md) for detailed usage
- Check [CHANGELOG](../CHANGELOG.md) for version history

## Getting Help

### List available Quick Actions
```powershell
Get-Help .\QuickActions.ps1 -Parameter Action
```

### Get help on a specific function
```powershell
Import-Module ..\modules\SystemControlFunctions.psm1
Get-Help Disable-WirelessAdapters -Full
```

### View all available functions in the module
```powershell
Import-Module ..\modules\SystemControlFunctions.psm1
Get-Command -Module SystemControlFunctions
```

---

**You're all set!** Start with the interactive menu to explore all features.
