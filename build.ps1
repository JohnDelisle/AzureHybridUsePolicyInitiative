
# used to break monolithic source policies into the files required per MS https://github.com/Azure/azure-policy/tree/master/1-contribution-guide

$policies = @()
$policies += Get-ChildItem -Path .\policies\SQL\*
$policies += Get-ChildItem -Path .\policies\Compute\* 

$gh = "https://raw.githubusercontent.com/JohnDelisle/AzureHybridUsePolicyInitiative/main/policies/"

foreach ($policy in $policies) {
    $policySource = Get-Content -Path "$($policy.FullName)\$($policy.Name).json" | ConvertFrom-Json -Depth 99
    
    $policySource            | ConvertTo-Json -Depth 99 | Out-File -Path "$($policy.FullName)\azurepolicy.json"
    $policySource.parameters | ConvertTo-Json -Depth 99 | Out-File -Path "$($policy.FullName)\azurepolicy.parameters.json"
    $policySource.policyRule | ConvertTo-Json -Depth 99 | Out-File -Path "$($policy.FullName)\azurepolicy.rules.json"

    # substitute GitHub URLs and other stuff into my README.md files.. I'm lazy
    $rawGhPolicy     = "$gh/$($policy.Parent.Name)/$($policy.Name)/azurepolicy.json"
    $rawGhParameters = "$gh/$($policy.Parent.Name)/$($policy.Name)/azurepolicy.parameters.json"
    $rawGhRules      = "$gh/$($policy.Parent.Name)/$($policy.Name)/azurepolicy.rules.json"

    $readme = Get-Content -Path .\template-README.md
    $readme = $readme.Replace("@policyName@",           $policy.Name)
    $readme = $readme.Replace("@policyDisplayName@",    $policySource.displayName)
    $readme = $readme.Replace("@policyDescription@",    $policySource.description)
    $readme = $readme.Replace("@rawGhPolicyEncoded@",   [System.Web.HTTPUtility]::UrlEncode($rawGhPolicy))
    $readme = $readme.Replace("@rawGhPolicy@",          $rawGhPolicy)
    $readme = $readme.Replace("@rawGhParameters@",      $rawGhParameters)
    $readme = $readme.Replace("@rawGhRules@",           $rawGhRules)

    $readme | Out-File -Path "$($policy.FullName)\README.md"

}