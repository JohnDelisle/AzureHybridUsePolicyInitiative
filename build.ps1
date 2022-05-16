

$policies += Get-ChildItem -Path .\policies\SQL\* 
$policies += Get-ChildItem -Path .\policies\Compute\* 

foreach ($policy in $policies) {
    $policy = Get-Content -Path "$($policy.Name)\$($policy.Name).json"
    $parameters = ($policy | ConvertFrom-Json).parameters | ConvertTo-Json
    $rules = ($policy | ConvertFrom-Json).policyRule | ConvertTo-Json

    $policy | Out-File -Path "$($policy.Name)\azurepolicy.json"
    $parameters | Out-File -Path "$($policy.Name)\azurepolicy.parameters.json"
    $rules | Out-File -Path "$($policy.Name)\azurepolicy.rules.json"
}