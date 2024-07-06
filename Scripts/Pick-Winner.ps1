<#
.SYNOPSIS
    Returns a randomly selected faction member

.DESCRIPTION
    Gerneates 1 random number matched to a faction member name in <faction member list>.  
    
.EXAMPLE
    pick-winner

.INPUTS
    String

.OUTPUTS
    PSCustomObject

.NOTES
    Author: Mike Conway 
    Date:   7/6/24 (Original) 
    Future Work:    Make menu driven so that it can pick from multiple lists 
                    Integrate Torn API to pull list of faction members
#>

function get-number{
    Get-Random -Minimum 1 -Maximum 10
}

function Get-RaceParticipant{
    $resultNumb = get-number
    
    $result = switch ($resultNumb){
        1 {"Telerion"}
        2 {"Halt"}
        3 {"so_like_juan"}
        4 {"WideEyes_Fred"}
        5 {"Prince254"}
        6 {"Mozi"}
        7 {"RandyDandy"}
        8 {"Ran3_"}
        9 {"Borg1of1"}
        10 {"eosar"}  
        Default{
            "No members in this list"
        }         
    }
    return $result
}


$winner = Get-RaceParticipant
Write-Output ("The winner of 1 xanax is {0}!"-f $winner)