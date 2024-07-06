$response = Invoke-WebRequest -Uri https://api.torn.com/faction/?selections="&"key=BJWrMGwOjuSMHvMd -UseBasicParsing
$factionInfo = $response | ConvertFrom-Json
foreach ($member in $factionInfo.members)
{    
    $memberInfo = Invoke-WebRequest -Uri https://api.torn.com/user/"$member"?selections="&"key=BJWrMGwOjuSMHvMd -UseBasicParsing
    $userInfo = $memberInfo.Content | ConvertFrom-Json
    $userInfo
}