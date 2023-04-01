#####################################################################
# Author:       Michael J Conway
# Email:        michael.j.conway18.ctr@army.mil
# Version:      4.1
# Date:         31 Mar 23
# Description:  Script for shutting down and clearing Teams cache
# Usage:        Execute script from PowerShell ISE
# ToDo:         
# Changes:      Added functionality to backup the config file and restore
#               after deleting the cache.
#               Changed path to Desktop to be a variable based on the
#               environment setting for the Desktop folder.
#               Added logic for waiting and checking to make sure process
#               was killed.
#####################################################################

#Get Desktop path to be used later
$desktop = [environment]::GetFolderPath("Desktop")

$runningApps = (Get-Process | Where-Object { $_.MainWindowTitle })
while ($runningApps.ProcessName -eq "Teams"){
    Stop-Process -Name Teams -Force
    Write-host sleeping
    Start-Sleep -Seconds 10   
    $runningApps = (Get-Process | Where-Object { $_.MainWindowTitle })
}

if(Test-Path -Path $env:APPDATA\Microsoft\Teams){
    #Copies the config to your desktop to restore once finished deleting all files.
    if (Test-Path $env:APPDATA\Microsoft\Teams\desktop-config.json){
        Copy-Item -Path $env:APPDATA\Microsoft\Teams\desktop-config.json -Destination $desktop
        #Pause before moving on
        Write-host sleeping
        Start-Sleep -Seconds 10
    }
    Remove-Item $env:APPDATA\Microsoft\Teams -Recurse
}

#Looks for saved config file and copies it back to the cache store
if(Test-Path -Path $desktop\desktop-config.json){
    Copy-Item -Path $desktop\desktop-config.json -Destination $env:APPDATA\Microsoft\Teams
    Start-Sleep -Seconds 10
}
Start-Process $env:USERPROFILE\AppData\Local\Microsoft\Teams\current\Teams.exe