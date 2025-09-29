# Define the registry path and value name
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
$valueName = "AdvertisingId"

# Generate a new random GUID for the Advertising ID
$newAdvertisingId = [guid]::NewGuid().ToString()

# Check if the registry key exists
if (-not (Test-Path $registryPath)) {
    Write-Host "Registry path does not exist. Creating it..." -ForegroundColor Yellow
    New-Item -Path $registryPath -Force | Out-Null
}

# Update the AdvertisingId value in the registry
try {
    Set-ItemProperty -Path $registryPath -Name $valueName -Value $newAdvertisingId
    Write-Host "Advertising ID updated successfully to: $newAdvertisingId" -ForegroundColor Green
} catch {
    Write-Host "Failed to update the Advertising ID. Error: $_" -ForegroundColor Red
}