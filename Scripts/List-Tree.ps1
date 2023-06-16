<#
.SYNOPSIS
    Get list of files and folders in a directory
.DESCRIPTION
    Gets a list of files and folders in a directory to a given depth.  
    Depending on the depth and size of drive can take time to execute.
    The script will prompt for a starting directory and depth if not 
    provided as command line arguments.

.PARAMETER directory
    This is the directory that you wish to gather information from.
.PARAMETER depth
    This is the desired depth that you wish to traverse.  Default value is 2
    
.EXAMPLE
     
.EXAMPLE
     
.EXAMPLE
     
.INPUTS
    String, int

.OUTPUTS
    PSCustomObject

.NOTES
    Author: Mike Conway 
    Date:   6/16/23 (Original)   
#>

[CmdletBinding()] 
param(
    [Parameter(Mandatory)] 
    [string]$directory, # restricts the input to a string value and sets the starting directory else defaults to where command is run from
    [Parameter]
    [int]$depth = 2 # Sets the depth to traverse or defualts to 2 levels    
)

if(Test-Path -Path "$env:USERPROFILE\Desktop\treeList.txt"){
    $treeList = Get-Item -Path "$env:USERPROFILE\Desktop\treeList.txt"     
}
else{
    $treeList = New-Item -Path "$env:USERPROFILE\Desktop\treeList.txt"
}

Get-ChildItem -Path $directory -Depth $depth | Add-Content $treeList