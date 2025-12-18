# This is the final version of the master script.
# It now uses the corrected base name "WeeklyIncidentDetails" for output files.

[CmdletBinding()]
param (
    # Specifies how many weeks back to generate the report for.
    # 0 = The most recent Friday's week (default).
    # 1 = The week before that, and so on.
    [Parameter(Mandatory = $false)]
    [int]$WeeksBack = 0
)

try {
    # --- Configuration Section ---
    $rootPath = "C:\Users\<my_directory>\OneDrive\Documents\EmailAnalysis"
    $scriptsFolderName  = "Scripts"
    $outlookFolderPath  = "\\my_email\Inbox\DC3 DCISE Reports"

    # --- Dynamic Path and Filename Generation ---
    # Calculate the target Friday to use for the filenames.
    $Today = (Get-Date).Date
    $DaysToSubtractForThisWeek = ($Today.DayOfWeek.value__ + 2) % 7
    $TotalDaysToSubtract = $DaysToSubtractForThisWeek + ($WeeksBack * 7)
    $TargetFriday = $Today.AddDays(-$TotalDaysToSubtract)
    $fileDateStamp = $TargetFriday.ToString("yyyy-MM-dd")

    $scriptsPath        = Join-Path -Path $rootPath -ChildPath $scriptsFolderName
    $reportsPath        = Join-Path -Path $rootPath -ChildPath "Reports"
    $attachmentPath     = Join-Path -Path $reportsPath -ChildPath "Temp"
    $consolidateScriptPath = Join-Path -Path $scriptsPath -ChildPath "Consolidate-And-Analyze-Reports.ps1"
    $convertScriptPath     = Join-Path -Path $scriptsPath -ChildPath "Convert-CsvToExcel.ps1"
    
    # --- THIS IS THE CORRECTED BLOCK ---
    # The base filenames have been updated to your specification.
    $csvOutputFileName  = "WeeklyIncidentDetails_$($fileDateStamp).csv"
    $excelOutputFileName= "WeeklyIncidentDetails_$($fileDateStamp).xlsx"
    # --- END OF CORRECTION ---

    $csvOutputPath      = Join-Path -Path $reportsPath -ChildPath $csvOutputFileName
    $excelOutputPath    = Join-Path -Path $reportsPath -ChildPath $excelOutputFileName

    # --- Pre-flight Checks ---
    if (-not (Test-Path $consolidateScriptPath)) { throw "Required script not found: $consolidateScriptPath" }
    if (-not (Test-Path $convertScriptPath)) { throw "Required script not found: $convertScriptPath" }
    if (-not (Test-Path -Path (Join-Path $rootPath "Config"))) { throw "Config folder not found." }
    New-Item -Path $reportsPath -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
    New-Item -Path $attachmentPath -ItemType Directory -ErrorAction SilentlyContinue | Out-Null

    # --- Step 1: Execute Data Extraction and Analysis ---
    Write-Host "Step 1: Starting data extraction from Outlook..." -ForegroundColor Green
    & $consolidateScriptPath -RootPath $rootPath `
                             -OutlookFolderPath $outlookFolderPath `
                             -SummaryCsvPath $csvOutputPath `
                             -WeeksBack $WeeksBack
                             
    # --- Step 2: Convert CSV to Formatted Excel ---
    if (Test-Path $csvOutputPath) {
        Write-Host "Step 2: Starting conversion from CSV to highlighted Excel..." -ForegroundColor Green
        . $convertScriptPath
        Convert-FromCsvToExcel -CsvPath $csvOutputPath -ExcelPath $excelOutputPath
    } else {
        Write-Warning "Analysis script ran, but no new CSV file was created. This is expected if no new emails were found."
    }

    Write-Host "`nProcess finished." -ForegroundColor Cyan
}
catch {
    Write-Error "A critical error occurred in the master script: $_.ToString()"
    throw
}

