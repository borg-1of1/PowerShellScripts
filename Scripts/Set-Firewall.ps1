<#
.SYNOPSIS
    Sets firewall rules for inbound conenctions in support of a given application.

.DESCRIPTION
    Creates firewall rules.
    
.EXAMPLE
     .\Set-Firewall.ps1 

.INPUTS
    String

.OUTPUTS
    PSCustomObject

.NOTES
    Author: M. Conway 
    Date:   3/30/21 
     

.CHANGES
    
#>

New-NetFirewallRule -DisplayName "Manage Engine Control Ports" -Direction inbound -LocalPort 8444,8032,8443,8031,8027,8383 -Protocol TCP -Action Allow 