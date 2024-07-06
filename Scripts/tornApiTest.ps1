$response = Invoke-WebRequest -Uri https://api.torn.com/faction/?selections="&"key= -UseBasicParsing
$factionInfo = $response | ConvertFrom-Json
foreach ($member in $factionInfo.members)
{    
    $memberInfo = Invoke-WebRequest -Uri https://api.torn.com/user/"$member"?selections="&"key= -UseBasicParsing
    $userInfo = $memberInfo.Content | ConvertFrom-Json
    $userInfo
}