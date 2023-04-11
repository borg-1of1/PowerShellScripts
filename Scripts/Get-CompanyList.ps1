<#
.SYNOPSIS
    Extracts company names from multiple excel files and writes to a text file

.DESCRIPTION
    Script for extracting names of companies from provided excel files in order to generate just a single list of companies.

.PARAMETER sourceDirectory
    The name and path to the directory containing the source excel files.

.PARAMETER outFile
    The location and name for the resulting text file

.EXAMPLE
     /\Get-ComapnyNames.ps1 <some directory>, <some outFile>

.INPUTS
    String

.OUTPUTS
    PSCustomObject

.NOTES
    Author: Mike Conway 
    Date:   4/5/23 (Original)   
#>


#Specify the Sheet name
$SheetName = "Summary"
$FilePath = "$desktop\Material Summary.xlsx"

# Create an Object Excel.Application using Com interface
$objExcel = New-Object -ComObject Excel.Application
$objExcel.Visible = $false
# Open the Excel file and save it in $WorkBook
$WorkBook = $objExcel.Workbooks.Open($FilePath)
# Load the WorkSheet 'Sumary'
$WorkSheet = $WorkBook.sheets.item($SheetName)

$MyData = [System.Collections.Generic.List[string]]::new() #Potentially better performance than immutable array if you're running this on thousands of rows.
for($i = 2; $i -le $WorkSheet.UsedRange.Rows.Count; $i++) {
    ($Worksheet.Range("a$i").text) -match 'from (?<name>.+) in'
    $MyData.Add($Matches.name)
}

$MyData | Out-File $desktop\Outfile.txt