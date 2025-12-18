# This version re-introduces the "Incident Narrative" field for testing.

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]$RootPath,
    [Parameter(Mandatory = $true)]
    [string]$OutlookFolderPath,
    [Parameter(Mandatory = $true)]
    [string]$SummaryCsvPath,
    [Parameter(Mandatory = $false)]
    [int]$WeeksBack = 0
)

try {
    # --- Setup and Path Derivation ---
    $ConfigDirectory = Join-Path $RootPath "Config"; $AttachmentPath = Join-Path $RootPath "Reports\Temp"
    $KeywordListPath = Join-Path $ConfigDirectory "HighImportanceKeywords.txt"; $CompanyListPath = Join-Path $ConfigDirectory "HighImportanceCompanies.txt"
    $HighImportanceKeywords = Get-Content $KeywordListPath -ErrorAction Stop; $HighImportanceCompanies = Get-Content $CompanyListPath -ErrorAction Stop

    # --- Outlook Connection and Navigation ---
    Add-Type -Assembly "Microsoft.Office.Interop.Outlook"; $Outlook = New-Object -ComObject Outlook.Application
    $Namespace = $Outlook.GetNamespace("MAPI"); $pathParts = $OutlookFolderPath -replace '^\\\\', '' -split '[\\/]', 2
    $mailboxName = $pathParts[0]; $folderPath = $pathParts[1]
    $store = $Namespace.Stores | Where-Object { $_.DisplayName -eq $mailboxName } | Select-Object -First 1
    if ($null -eq $store) { throw "Could not find mailbox store: $mailboxName" }
    $currentFolder = $store.GetRootFolder()
    foreach ($folderName in ($folderPath -split '[\\/]')) {
        $nextFolder = $currentFolder.Folders | Where-Object { $_.Name -eq $folderName.Trim() }
        if ($null -ne $nextFolder) { $currentFolder = $nextFolder }
        else { throw "Could not find subfolder: $folderName" }
    }
    $TargetFolder = $currentFolder

    # --- Filtering ---
    $Today = (Get-Date).Date; $DaysToSubtractForThisWeek = ($Today.DayOfWeek.value__ + 2) % 7
    $TotalDaysToSubtract = $DaysToSubtractForThisWeek + ($WeeksBack * 7)
    $TargetFriday = $Today.AddDays(-$TotalDaysToSubtract)
    $FilterStartDate = $TargetFriday.AddDays(-7); $FilterEndDate = $TargetFriday.AddDays(1)
    $DateFilter = "[ReceivedTime] >= '$($FilterStartDate.ToString("MM/dd/yyyy"))' AND [ReceivedTime] < '$($FilterEndDate.ToString("MM/dd/yyyy"))'"
    $ItemsInDateRange = $TargetFolder.Items.Restrict($DateFilter)
    $SubjectFilter = "@SQL=""urn:schemas:httpmail:subject"" LIKE '%ICF%'"
    $Emails = $ItemsInDateRange.Restrict($SubjectFilter)
    Write-Host "Found $($Emails.Count) emails that match all criteria (Date Window AND Subject contains 'ICF')." -ForegroundColor Cyan
    
    $ReportData = foreach ($Email in $Emails) {
        if ($Email.Attachments.Count -eq 0) { continue }
        $Attachment = $Email.Attachments | Where-Object { $_.FileName -like "*.txt" } | Select-Object -First 1
        if ($null -eq $Attachment) { continue }

        $TempFilePath = Join-Path $AttachmentPath -ChildPath ('{0}_{1}' -f (Get-Date -Format 'yyyyMMddHHmmss'), $Attachment.FileName)
        $Attachment.SaveAsFile($TempFilePath)
        $Content = Get-Content $TempFilePath | Out-String

        # --- UPDATED PARSING LOGIC ---
        # The Incident Narrative field has been added back in.
        $ICFNumber = if ($Content -match 'MIR ICF Submission #(.*?)\s') { $Matches[1].Trim() } else { "N/A" }
        $DateSubmitted = if ($Content -match 'Date Submitted: (.*?)\r?\n') { $Matches[1].Trim() } else { "N/A" }
        $CompanyName = if ($Content -match 'Company Name : (.*?)\r?\n') { $Matches[1].Trim() } else { "N/A" }
        $TypeOfIncident = if ($Content -match 'Type of Incident : (.*?)\r?\n') { ($Matches[1] -replace '[\[\]'']', '').Trim() } else { "N/A" }

        # This parsing is designed to be robust and clean up the text.
        $IncidentNarrative = if ($Content -match '(?s)\*\* Incident Narrative .*?:\s*\r?\n(.*?)(?=\r?\n\s*Known Advanced Persistent Threat \(APT\))') {
            # Replace newline characters with spaces and compress multiple spaces into one.
            ($Matches[1].Trim() -replace '(\r?\n)+', ' ' -replace '\s+', ' ').Trim()
        } else { "N/A" }

        $Importance = "Normal"; $Reason = ""
        foreach ($Keyword in $HighImportanceKeywords) { if ($Content -match $Keyword) { $Importance = "High"; $Reason = "Keyword Match: $Keyword"; break } }
        if ($Importance -ne "High") { foreach ($Company in $HighImportanceCompanies) { if ($Content -match $Company) { $Importance = "High"; $Reason = "Company Match: $Company"; break } } }
        # --- END OF PARSING ---
        
        # --- THIS IS THE CORRECTED OUTPUT OBJECT ---
        # The "Incident Narrative" has been added back.
        [PSCustomObject]@{
            "Date Received" = $Email.ReceivedTime.ToString("yyyy-MM-dd HH:mm")
            "Date Submitted" = $DateSubmitted
            "Subject" = $Email.Subject
            "ICF Number" = $ICFNumber
            "Company Name" = $CompanyName
            "Type of Incident" = $TypeOfIncident
            "Incident Narrative" = $IncidentNarrative
            "Importance" = $Importance
            "Reason for Importance" = $Reason
        }
        # --- END OF CORRECTION ---

        Remove-Item $TempFilePath
    }

    if ($ReportData) {
        $ReportData | Export-Csv -Path $SummaryCsvPath -NoTypeInformation
        Write-Host "Analysis complete. $($ReportData.Count) reports processed and saved to $SummaryCsvPath" -ForegroundColor Green
    } else {
        Write-Warning "No matching emails were found to process."
    }
}
catch { Write-Error "A critical error occurred: $_.ToString()"; throw }
finally { if ($Outlook) { [System.Runtime.InteropServices.Marshal]::ReleaseComObject($Outlook) | Out-Null }; [gc]::Collect(); [gc]::WaitForPendingFinalizers() }
