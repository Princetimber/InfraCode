$nbf = [long](get-Date -Date ((Get-Date).ToUniversalTime()) -UFormat %s)
$exp = [long](get-Date -Date ((Get-Date).AddDays(365).ToUniversalTime()) -UFormat %s)