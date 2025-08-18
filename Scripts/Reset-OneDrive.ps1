# Reset OneDrive
$onedrivePath = "$env:LOCALAPPDATA\Microsoft\OneDrive\onedrive.exe"
if (Test-Path $onedrivePath) {
    Start-Process $onedrivePath -ArgumentList "/reset"
} else {
    $onedrivePath = "C:\Program Files\Microsoft OneDrive\onedrive.exe"
    if (Test-Path $onedrivePath) {
        Start-Process $onedrivePath -ArgumentList "/reset"
    } else {
        $onedrivePath = "C:\Program Files (x86)\Microsoft OneDrive\onedrive.exe"
        if (Test-Path $onedrivePath) {
        Start-Process $onedrivePath -ArgumentList "/reset"
        } else {
            Write-Host "OneDrive executable not found."
        }
    }
}