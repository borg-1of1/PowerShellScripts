<#
.SYNOPSIS
    quick script for listing installed applications on a system

.DESCRIPTION
    Script queries HKLM registry hive to get list of instaled software.  Then writes list based on 
    Unique Display Names to a csv file created on the user's desktop.


.PARAMETER 
    
 
.OUTPUT 
    Writes list of installed applications to a CVS file.
       
.EXAMPLE
    To use this script, call it with a MyUPN argument like so:
    

.NOTES
    AUTHOR: Mike Conway
    LAST UPDATE: 26 Aug 2022
    INTENDED AUDIENCE: FLRAA Engineers to get a list of software to build a list for EISD to create a master
    Engineer software list that can be used for all Engineer Laptop builds.

    CHANGES:
#>

#Get Desktop path to be used later
$desktop = [environment]::GetFolderPath("Desktop")

#Get installed software
$installed = Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate
$installed += Get-ItemProperty HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate

#Write results to file on Desktop
$installed | ?{$_.DisplayName -ne $null} | Sort-Object -Property DisplayName -Unique | Export-Csv "$desktop\Installed.csv" -Encoding UTF8