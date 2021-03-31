<#
.SYNOPSIS
    Collects all information about Teams in an environment and exports to a CSV.

.DESCRIPTION
    Before running the script you need to make sure you run Connect-MicrosoftTeams and Connect-ExchangeOnline.
    Script is provided as is an no warenty is made.  Use at your own risk.
    
.EXAMPLE
     .\Get-TeamsInfo.ps1 

.INPUTS
    String

.OUTPUTS
    PSCustomObject

.NOTES
    Author: Gareth Jayne 
    Date:   5/19/20 (Original) 
    Modifications: Michael Conway
    Date:   2/12/21  

.CHANGES
    Added Where-Object to locate Teams with "FLRAA" in the DisplayName to limit the number of Teams returned by the Get-Team command.
#>

$AllTeamsInOrg = (Get-Team -User michael.j.conway18.ctr@cvr.mil | where-object {$_.DisplayName -like ("*FLRAA*")}).GroupID
$TeamList = @()

Write-Output "This may take a little bit of time... Please sit back, relax and enjoy some GIFs inside of Teams!"
Write-Host ""

Foreach ($Team in $AllTeamsInOrg)
{       
        $TeamGUID = $Team.ToString()
        #$TeamGroup = Get-UnifiedGroup -identity $Team.ToString()
        $TeamName = (Get-Team | ?{$_.GroupID -eq $Team}).DisplayName
        $TeamOwner = (Get-TeamUser -GroupId $Team | ?{$_.Role -eq 'Owner'}).User
        $TeamUserCount = ((Get-TeamUser -GroupId $Team).UserID).Count
        #$TeamGuest = (Get-UnifiedGroupLinks -LinkType Members -identity $Team | ?{$_.Name -match "#EXT#"}).Name
        #    if ($TeamGuest -eq $null)
        #    {
        #        $TeamGuest = "No Guests in Team"
        #    }
        $TeamChannels = (Get-TeamChannel -GroupId $Team).DisplayName
	$ChannelCount = (Get-TeamChannel -GroupId $Team).ID.Count
        $TeamList = $TeamList + [PSCustomObject]@{TeamName = $TeamName; TeamObjectID = $TeamGUID; TeamOwners = $TeamOwner -join ', '; TeamMemberCount = $TeamUserCount; NoOfChannels = $ChannelCount; ChannelNames = $TeamChannels -join ', '}
}

#######

$TestPath = test-path -path 'c:\temp'
if ($TestPath -ne $true) {New-Item -ItemType directory -Path 'c:\temp' | Out-Null
    write-Host  'Creating directory to write file to c:\temp. Your file is uploaded as TeamsDatav2.csv'}
else {Write-Host "Your file has been uploaded to c:\temp as 'TeamsDatav2.csv'"}
$TeamList | export-csv c:\temp\TeamsDatav2.csv -NoTypeInformation