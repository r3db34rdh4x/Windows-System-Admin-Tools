<#
.SYNOPSIS
    Keep system awake by sending Shift+F15 periodically
.DESCRIPTION
    Prevents Windows from going to sleep or activating screensaver
    by sending Shift+F15 key combination every 59 seconds.
    Press Ctrl+C to stop.
.NOTES
    Does not require administrator privileges
#>

Write-Host "Keep-Alive Script Started" -ForegroundColor Green
Write-Host "Sending Shift+F15 every 59 seconds to prevent sleep..." -ForegroundColor Cyan
Write-Host "Press Ctrl+C to stop.`n" -ForegroundColor Yellow

$wsh = New-Object -ComObject WScript.Shell

try {
    $counter = 0
    while ($true) {
        $wsh.SendKeys('+{F15}')
        $counter++
        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Key sent ($counter)" -ForegroundColor Gray
        Start-Sleep -Seconds 59
    }
}
finally {
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($wsh) | Out-Null
    Write-Host "`nKeep-Alive stopped." -ForegroundColor Yellow
}
