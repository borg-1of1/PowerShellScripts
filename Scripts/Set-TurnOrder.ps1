<#
.SYNOPSIS
    Returns and insult int he Shakespearian style

.DESCRIPTION
    Gerneates 3 random numbers between 1 and 10.  It then slects a word based off of those numbers and displays a string in the format "Thou <list 1 word>, <List 2 Word>, <list 3 word>!"
    
.EXAMPLE
    create-insult

.INPUTS
    String

.OUTPUTS
    PSCustomObject

.NOTES
    Author: Mike Conway 
    Date:   7/10/23 (Original)   
#>
param(
    [Parameter(Mandatory=$false)]
    [int]$numPlayers = 4
)
if($numPlayers -lt 2){
    Write-Error "You must have at least 2 players to set a turn order"
    return
}
if($numPlayers -gt 6){
    Write-Error "You cannot have more than 10 players in a turn order"
    return
}



function get-number{
    Get-Random -Minimum 1 -Maximum 10
}

function Get-FirstWord{
    $resultNumb = get-number
    
    $result = switch ($resultNumb){
        1 {"goatish"}
        2 {"mangled"}
        3 {"puny"}
        4 {"roguish"}
        5 {"reeky"}
        6 {"saucy"}
        7 {"weedy"}
        8 {"yeasty"}
        9 {"villanous"}
        10 {"gleeking"}  
        Default{
            "No Words for this"
        }         
    }
    return $result
}
function Get-SecondWord{
    $resultNumb = get-number
    $result = switch ($resultNumb){
        1 {"beef-witted"}
        2 {"clay-brained"}
        3 {"elf-skinned"}
        4 {"hedge-born"}
        5 {"milk-livered"}
        6 {"fly-bitten"}
        7 {"rump-fed"}
        8 {"toad-spotted"}
        9 {"weather-bitten"}
        10 {"fool-born"} 
        Default{
            "No Words for this"
        }  
    }
    return $result
}

function Get-ThirdWord{
    $resultNumb = get-number
    $result = switch ($resultNumb){
        1 {"barnacle"}
        2 {"boar-pig"}
        3 {"bum-bailey"}
        4 {"clotpole"}
        5 {"foot-licker"}
        6 {"horn-beast"}
        7 {"maggot-pie"}
        8 {"malt-worm"}
        9 {"pumpion"}
        10 {"whey-face"}        
        Default{
            "No Words for this"
        }        
    }
    return $result
}

$word1 = Get-FirstWord
$word2 = Get-SecondWord
$word3 = Get-ThirdWord
Write-Output ("Thou {0}, {1}, {2}!"-f $word1,$word2,$word3)