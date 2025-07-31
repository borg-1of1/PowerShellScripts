<#
.SYNOPSIS
    Sends periodic key press to a null console in order to keep system form showing idle.

.DESCRIPTION
    Starts a timer when the script starts and uses that timer to execute a loop. 
    Within the loop, a keystroke is periodically sent to a non-interactive shell.

.PARAMETER timespan
    Length of time for the script to execute.  This is of <Int32> and is in hours.

.EXAMPLE
     .\Send-KeyPress.ps1 -timespan 8

.EXAMPLE
     8 | .\Send-KeyPress.ps1

.INPUTS
    Int32

.OUTPUTS
    PSCustomObject

.NOTES
    Author: Mike Conway 
    Date:   2/24/22 (Original)   
#>

param(
    [Parameter(Mandatory)] 
    [Int32]$timespan # restricts the input to an Int32 value    
)

$dummyshell = New-Object -com "Wscript.shell"
$timeout = New-TimeSpan -Hours $timespan
$sw = [diagnostics.stopwatch]::StartNew()

while ($sw.Elapsed -lt $timeout){
    $dummyshell.Sendkeys(".") > null 
    Start-Sleep -Seconds 240
}

$sw.Stop()
#Exit