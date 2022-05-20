
# used to break monolithic source policies into the files as required per MS https://github.com/Azure/azure-policy/tree/master/1-contribution-guide

$policyFiles = @()
$policyFiles += Get-ChildItem -Path .\policies\SQL\*
$policyFiles += Get-ChildItem -Path .\policies\Compute\* 

$gh = "https://raw.githubusercontent.com/JohnDelisle/AzureHybridUsePolicyInitiative/main/policies/"

foreach ($policyFile in $policyFiles) {
    $policySource = Get-Content -Path "$($policyFile.FullName)\$($policyFile.Name).pd.json" | ConvertFrom-Json -Depth 99
    
    $policySource                       | ConvertTo-Json -Depth 99 | Out-File -Path "$($policyFile.FullName)\azurepolicy.json"
    $policySource.properties.parameters | ConvertTo-Json -Depth 99 | Out-File -Path "$($policyFile.FullName)\azurepolicy.parameters.json"
    $policySource.properties.policyRule | ConvertTo-Json -Depth 99 | Out-File -Path "$($policyFile.FullName)\azurepolicy.rules.json"

    # substitute GitHub URLs and other stuff into my README.md files.. I'm lazy
    $rawGhPolicy     = "$gh/$($policyFile.Parent.Name)/$($policyFile.Name)/azurepolicy.json"
    $rawGhParameters = "$gh/$($policyFile.Parent.Name)/$($policyFile.Name)/azurepolicy.parameters.json"
    $rawGhRules      = "$gh/$($policyFile.Parent.Name)/$($policyFile.Name)/azurepolicy.rules.json"

    $readme = Get-Content -Path .\template-README.md
    $readme = $readme.Replace("@policyName@",                       $policyFile.Name)
    $readme = $readme.Replace("@policyDisplayName@",                $policySource.properties.displayName)
    $readme = $readme.Replace("@policyDescription@",                $policySource.properties.description)
    $readme = $readme.Replace("@assignmentNonComplianceMessage@",   $policySource.properties.metadata.NonComplianceMessage)
    $readme = $readme.Replace("@rawGhPolicyEncoded@",               [System.Web.HTTPUtility]::UrlEncode($rawGhPolicy))
    $readme = $readme.Replace("@rawGhPolicy@",                      $rawGhPolicy)
    $readme = $readme.Replace("@rawGhParameters@",                  $rawGhParameters)
    $readme = $readme.Replace("@rawGhRules@",                       $rawGhRules)

    $readme | Out-File -Path "$($policyFile.FullName)\README.md"
}