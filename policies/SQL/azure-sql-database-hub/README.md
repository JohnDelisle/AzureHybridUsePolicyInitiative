# 



## Azure Policy Docs

See Microsoft documentation for background and use of Azure Policy samples [docs.microsoft.com](https://docs.microsoft.com/en-us/azure/governance/policy/samples/), including this policy.

## Try with Azure portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3a%2f%2fraw.githubusercontent.com%2fJohnDelisle%2fAzureHybridUsePolicyInitiative%2fmain%2fpolicies%2f%2fSQL%2fazure-sql-database-hub%2fazurepolicy.json)

## Try with Azure PowerShell

````powershell
# Create the Policy Definition (Subscription scope)
$policyDefinition = New-AzPolicyDefinition -Name 'azure-sql-database-hub' -DisplayName '' -description '' -Policy 'https://raw.githubusercontent.com/JohnDelisle/AzureHybridUsePolicyInitiative/main/policies//SQL/azure-sql-database-hub/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/JohnDelisle/AzureHybridUsePolicyInitiative/main/policies//SQL/azure-sql-database-hub/azurepolicy.parameters.json' -Mode All

# Set the Policy Parameter (JSON format) to meet your needs.
# "AuditIfNotExists" -- Audit and report on resources that are non-compliant
# "DeployIfNotExists" -- Automatically fix resources that are non-compliant
# "Disabled" -- Disable policy
$policyParameters = '{ "effect": { "value": "AuditIfNotExists" } }'

# Set the scope to a resource group; may also be a subscription or management group
$scope = Get-AzResourceGroup -Name 'YourResourceGroup' 

# Create the Policy Assignment
$spLocation = 'YourLocationForSystemAssignmedManagedIdentity'
$policyAssignment = New-AzPolicyAssignment -Name 'azure-sql-database-hub-assignment' -DisplayName ' Assignment' -Scope $scope.ResourceId -PolicyDefinition $policyDefinition -PolicyParameter $policyParameters -IdentityType SystemAssigned -Location $spLocation

# Create a Role Assignment
# Grants the System Assigned Managed Identity (created duing Policy Assignement) with the RBAC Role (specified in the policy) to the Scope (specified in $scope above), 
# enabling Azure Policy to make changes to resources when the "DeployIfNotExists" effect is used.
$roleAssignment = New-AzRoleAssignment -PrincipalId $policyAssignment.Identity.PrincipalId -Scope $scope.ResourceId -RoleDefinitionId $policyDefinition.Properties.PolicyRule.then.details.roleDefinitionIds[0].Split('/')[-1]

````

## Try with Azure CLI

```bash
# Create the Policy Definition (Subscription scope)
policyDefinition=$(az policy definition create --name 'azure-sql-database-hub' --display-name '' --description '' --rules 'https://raw.githubusercontent.com/JohnDelisle/AzureHybridUsePolicyInitiative/main/policies//SQL/azure-sql-database-hub/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/JohnDelisle/AzureHybridUsePolicyInitiative/main/policies//SQL/azure-sql-database-hub/azurepolicy.parameters.json' --mode All)

# Set the Policy Parameter (JSON format)
# "AuditIfNotExists" -- Audit and report on resources that are non-compliant
# "DeployIfNotExists" -- Automatically fix resources that are non-compliant
# "Disabled" -- Disable policy
policyParameters='{ "effect": { "value": "AuditIfNotExists" } }'

# Set the scope to a resource group; may also be a subscription or management group
scope=$(az group show --name 'YourResourceGroup')

# Create the Policy Assignment
# In addition to the creating the Policy Assignment, this creates and grants a System Assigned Managed Identity with the RBAC Role (specified in the policy) to the Scope (specified in $scope above),
# enabling Azure Policy to make changes to resources when the "DeployIfNotExists" effect is used.
spLocation='YourLocationForSystemAssignmedManagedIdentity'
scopeId=$(echo $scope | jq '.id' -r)
roleId=$(echo $policyDefinition | jq '.policyRule.then.details.roleDefinitionIds[0]' -r | awk -F\/ '{print $NF}')
policyDefinitionName=$(echo $policyDefinition | jq '.name' -r)
scopeId=$(echo $scope | jq '.id' -r)
policyAssignment=$(az policy assignment create --name 'azure-sql-database-hub-assignment' --display-name ' Assignment' --scope "$scopeId" --policy "$policyDefinitionName" --params "$policyParameters" --mi-system-assigned --location "$spLocation" --identity-scope "$scopeId" --role "$roleId")

```
