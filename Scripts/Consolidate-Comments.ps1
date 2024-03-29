<#
.SYNOPSIS
    Consolidates multiple CRM files into one CRM file.

.DESCRIPTION
    Before running this script, ensure that all files you wish to consolidate are located int he same directory 
    and that there is no existing file already in the destination directory with the same name.  Use of this script
    is at your own risk.
    
.EXAMPLE
     .\Consolidate-Comments.ps1 

.INPUTS
    String

.OUTPUTS
    PSCustomObject

.NOTES
    Author: Gareth Jayne 
    Date:   5/19/20 (Original) 
    Modifications: Michael Conway
    Date:   6/8/21  

.CHANGES
    
#>

# This represents the path you want the results file to be saved to.  You can change this to the location of your choice.
$destinationPath = "C:\Users\micha\OneDrive - Torch Technologies, Inc\FLRAA\DSRs\"

# This sets the file name and is in the format yyyy-mm-dd_DSR.xlsx - DO NOT CHANGE
$dailyFileName = (Get-Date -Format yyyy'-'MM'-'dd) + "_DSR.xlsx"
$results = $destinationPath+ $dailyFileName

# This is the directory for where you will be placing the daily DSRs.  You can change this.
$sourceFilesPath = "C:\Users\micha\OneDrive - Torch Technologies, Inc\FLRAA\DSRs\Individual Reports"

# Launch Excel, and make it do as its told (supress confirmations)
# Excel.Visable needs to be set to true for propper execution
$Excel = New-Object -ComObject Excel.Application
$Excel.Visible = $true  
$Excel.DisplayAlerts = $False

$files = Get-ChildItem -Path $sourceFilesPath

# Create a new Excel instance 
$dest = $Excel.Workbooks.Add()
#$row =
foreach ($file in $files)
{
    $source = $Excel.Workbooks.Open($file.FullName,$true,$true)
    If(($Dest.ActiveSheet.UsedRange.Count -eq 1) -and ([String]::IsNullOrEmpty($Dest.ActiveSheet.Range("A1").Value2)))
    { 
        #If there is only 1 used cell and it is blank select A1 - This grabs the column headings so that a preexisting spreadsheet does not need to be created
        [void]$source.ActiveSheet.Range("A1","F$(($Source.ActiveSheet.UsedRange.Rows|Select-Object -Last 1).Row)").Copy()
        [void]$Dest.Activate()
        [void]$Dest.ActiveSheet.Range("A1").Select()
    }
    Else
    { 
        #If there is data go to the next empty row and select Column A
        [void]$source.ActiveSheet.Range("A2","F$(($Source.ActiveSheet.UsedRange.Rows|Select-Object -Last 1).Row)").Copy()
        [void]$Dest.Activate()
        [void]$Dest.ActiveSheet.Range("A$(($Dest.ActiveSheet.UsedRange.Rows|Select-Object -last 1).row+1)").Select()
    }
    [void]$Dest.ActiveSheet.Paste()
    $Source.Close()
}
$dest.SaveAs("$results")
$dest.close()
$Excel.Quit()