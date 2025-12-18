# This is the final, production version of the Excel conversion script.
# It uses the explicit parameter name 'ConditionValue' as specified by the error message.

function Convert-FromCsvToExcel {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$CsvPath,

        [Parameter(Mandatory = $true)]
        [string]$ExcelPath
    )

    if (-not (Get-Module -ListAvailable -Name ImportExcel)) {
        throw "The 'ImportExcel' module is required. Please install it by running: Install-Module -Name ImportExcel -Scope CurrentUser"
    }
    if (-not (Test-Path -Path $CsvPath)) {
        Write-Warning "The source CSV file was not found at: $CsvPath. A new one may not have been generated if no new emails were found."
        return # Exit gracefully if there's no CSV to convert.
    }

    try {
        # --- THIS IS THE DEFINITIVE CORRECTION ---
        # We are now using the explicit parameter name 'ConditionValue' that the error message specified.
        $ConditionalFormat = @{
            RuleType = 'ContainsText'
            ConditionValue = 'High' # This is the correct parameter for your version.
            BackgroundColor = 'IndianRed'
        }
        # --- END OF CORRECTION ---
        
        # Import the CSV and export it to a formatted Excel file
        Import-Csv -Path $CsvPath | Export-Excel -Path $ExcelPath `
            -WorksheetName "Incident Log" `
            -AutoSize `
            -TableName "IncidentData" `
            -TableStyle Medium6 `
            -FreezeTopRow `
            -ConditionalFormat $ConditionalFormat
            
        Write-Host "Successfully converted CSV to a highlighted Excel report at: $ExcelPath" -ForegroundColor Green
    }
    catch {
        Write-Error "An error occurred during the Excel conversion: $_.ToString()"
        throw
    }
}
