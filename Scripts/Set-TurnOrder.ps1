<#
.SYNOPSIS
    Returns Player order and benefits for a turn supporting the Cheese Stands Alone EDH varient.

.DESCRIPTION
    This script generates a random turn order for a specified number of players in a game, along with a benefit and condition for the turn.
    The benefit and condition are randomly selected from predefined options.    

    
.EXAMPLE
    Set-TurnOrder.ps1 -numPlayers 4

.INPUTS
    String

.OUTPUTS
    PSCustomObject

.NOTES
    Author: Mike Conway 
    Date:   7/10/23 (Original)   
#>
param(
    [Parameter(Mandatory=$true)]
    [Int32]$numPlayers = 4
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
    Get-Random -Minimum 1 -Maximum $numPlayers
}

function Get-PlayerOrder{
    param(       
        [int]$numPlayers = 4
    )
    $result = @()    
    $players = @(1..$numPlayers)
    while ($result.Count -lt $numPlayers) {
        $randomIndex = Get-Random -Minimum 0 -Maximum $players.Count
        $result += $players[$randomIndex]
        $players = $players | Where-Object { $_ -ne $players[$randomIndex] } # Remove the selected player from the list
        
    }       
    
    return $result
}
function Get-Benefit{
    $resultNumb = get-number
    $result = switch ($resultNumb){
        1 {"+1/+1"}
        2 {"+1/+0"}
        3 {"+0/+1"}
        4 {"creatures you control have hexproof"}
        5 {"creatures you control have vigilance"}
        6 {"creatures you control have trample"}
        7 {"creatures you control have menace"}
        8 {"creatures you control have lifelink"}
        9 {"creatures you control have deathtouch"}
        10 {"creatures you control have indestructible"} 
        11 {"creatures you control have reach"}
        12 {"creatures you control have flying"}
        13 {"creatures you control have haste"}
        14 {"creatures you control have protection from black"}
        15 {"creatures you control have protection from red"}   
        16 {"creatures you control have protection from white"}
        17 {"creatures you control have protection from green"}
        18 {"creatures you control have protection from blue"}
        19 {"creatures you control have protection from artifacts"}
        20 {"creatures you control have protection from multicolored"}
        21 {"creatures you control have protection from colorless"}
        22 {"creatures you control have protection from enchantments"}
        23 {"creatures you control have protection from planeswalkers"}
        24 {"creatures you control have protection from instants"}
        25 {"creatures you control have protection from sorceries"}
        26 {"creatures you control have protection from abilities"}
        27 {"creatures you control have protection from spells"}
        28 {"creatures you control have protection from combat damage"}
        29 {"creatures you control have shroud"}
        Default{
            "No Words for this"
        }  
    }
    return $result
}

function Get-Condition{
    $resultNumb = get-number
    $result = switch ($resultNumb){
        1 {"Until end of turn"}
        2 {"Unitl a new Cheese is chosen"}
        3 {"Until your next upkeep"}
        4 {"Until your next draw step"}
        5 {"Until your next end step"}       
                
        Default{
            "No Words for this"
        }        
    }
    return $result
}

$order = @(Get-PlayerOrder -numPlayers $numPlayers)
$word2 = Get-Benefit -numPlayers "29"
$word3 = Get-Condition -numPlayers "5"
Write-Output "Player order is: $($order -join ', ')"
Write-Output "The benefit is: $word2"
Write-Output "The condition is: $word3"

