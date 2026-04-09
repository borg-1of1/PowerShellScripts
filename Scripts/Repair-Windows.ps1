# ================================================
# Windows 11 FULL Repair + Update Reset Script
# Optimized for your recurring post-update lockup issue
# Includes: CHKDSK → DISM → SFC → Windows Update Component Reset → Cleanup
# Run this in an elevated (Administrator) PowerShell window
# ================================================

# Safety checks
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "ERROR: Please run this script as Administrator!" -ForegroundColor Red
    Write-Host "Right-click PowerShell → Run as administrator" -ForegroundColor Yellow
    pause
    exit
}

# Start logging (useful for troubleshooting future lockups)
$logPath = "C:\RepairLog_$(Get-Date -Format 'yyyy-MM-dd_HH-mm').txt"
Start-Transcript -Path $logPath -Append
Write-Host "Repair log started: $logPath" -ForegroundColor Cyan

Write-Host "`nStarting FULL Windows 11 Repair + Update Reset..." -ForegroundColor Cyan
Write-Host "This is designed for systems that lock up after updates.`n" -ForegroundColor White

# Step 1: CHKDSK (disk errors can corrupt updates)
Write-Host "`nStep 1: CHKDSK scan on C: (online scan first)..." -ForegroundColor Yellow
chkdsk C: /scan

# Optional full repair on next reboot (uncomment if you want to force it):
# Write-Host "Scheduling full CHKDSK repair for next reboot..." -ForegroundColor Yellow
# chkdsk C: /f /r

Write-Host "CHKDSK completed." -ForegroundColor Green

# Step 2: DISM (repairs the Windows image/component store — critical for update problems)
Write-Host "`nStep 2: DISM Health Checks & Repair (requires internet)..." -ForegroundColor Yellow
Write-Host "   → CheckHealth" -ForegroundColor Gray
DISM /Online /Cleanup-Image /CheckHealth

Write-Host "   → ScanHealth" -ForegroundColor Gray
DISM /Online /Cleanup-Image /ScanHealth

Write-Host "   → RestoreHealth (this downloads fresh files — can take 15-40 mins)..." -ForegroundColor Gray
DISM /Online /Cleanup-Image /RestoreHealth

Write-Host "DISM completed." -ForegroundColor Green

# Step 3: SFC (fixes protected system files using the repaired image)
Write-Host "`nStep 3: SFC /scannow (5-15 minutes)..." -ForegroundColor Yellow
sfc /scannow

Write-Host "SFC completed." -ForegroundColor Green

# Step 4: Windows Update Component Reset (this is the KEY step for your recurring update lockups)
# It clears corrupted update cache that often causes post-reboot freezes
Write-Host "`nStep 4: Resetting Windows Update components (clears bad update cache)..." -ForegroundColor Yellow

$UpdateServices = @("wuauserv", "cryptSvc", "bits", "msiserver")

Write-Host "   Stopping services..." -ForegroundColor Gray
foreach ($svc in $UpdateServices) {
    Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
}

Write-Host "   Renaming update folders (old copies kept for safety)..." -ForegroundColor Gray
$SDPath = "$env:windir\SoftwareDistribution"
$CatPath = "$env:windir\System32\catroot2"

if (Test-Path $SDPath) { Rename-Item -Path $SDPath -NewName "SoftwareDistribution.old" -Force -ErrorAction SilentlyContinue }
if (Test-Path $CatPath) { Rename-Item -Path $CatPath -NewName "catroot2.old" -Force -ErrorAction SilentlyContinue }

Write-Host "   Restarting services..." -ForegroundColor Gray
foreach ($svc in $UpdateServices) {
    Start-Service -Name $svc -ErrorAction SilentlyContinue
}

Write-Host "Windows Update reset completed. Windows will recreate clean folders on next update check." -ForegroundColor Green

# Step 5: Final cleanup
Write-Host "`nStep 5: Component cleanup (frees disk space)..." -ForegroundColor Yellow
DISM /Online /Cleanup-Image /StartComponentCleanup

Write-Host "`nALL REPAIR STEPS COMPLETED!" -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan

# Show recent updates so you can identify the problematic KB
Write-Host "`nRecent Windows Updates (last 5 installed):" -ForegroundColor White
Get-HotFix | Sort-Object InstalledOn -Descending | Select-Object -First 5 | Format-Table -AutoSize HotFixID, InstalledOn, Description

Write-Host "`nLog saved to: $logPath" -ForegroundColor Cyan
Write-Host "Recommendations for your lockup issue:" -ForegroundColor White
Write-Host "1. Reboot NOW."
Write-Host "2. After reboot, go to Settings → Windows Update → Check for updates."
Write-Host "3. If it locks up again, note the exact KB number from the list above (or Update history), then roll back that update."
Write-Host "4. To permanently block a bad update, download Microsoft's 'Show or hide updates' troubleshooter (search online for 'wushowhide.diagcab')."

Stop-Transcript

# Reboot prompt
$reboot = Read-Host "`nRestart computer now? (Y/N - recommended)"
if ($reboot -eq 'Y' -or $reboot -eq 'y') {
    Write-Host "Restarting in 15 seconds..." -ForegroundColor Red
    Start-Sleep -Seconds 15
    Restart-Computer -Force
} else {
    Write-Host "Remember to reboot manually before checking for updates again." -ForegroundColor Yellow
}