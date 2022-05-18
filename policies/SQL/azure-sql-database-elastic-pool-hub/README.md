# 



## Azure Policy Docs

See Microsoft documentation for background and use of Azure Policy samples [docs.microsoft.com](https://docs.microsoft.com/en-us/azure/governance/policy/samples/), including this policy.

## Try with Azure portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3a%2f%2fraw.githubusercontent.com%2fJohnDelisle%2fAzureHybridUsePolicyInitiative%2fmain%2fpolicies%2f%2fSQL%2fazure-sql-database-elastic-pool-hub%2fazurepolicy.json)

## Try with Azure PowerShell

````powershell
# Create the Policy Definition (Subscription scope)
$policyDefinition = New-AzPolicyDefinition -Name 'azure-sql-database-elastic-pool-hub' -DisplayName '' -description '' -Policy 'https://raw.githubusercontent.com/JohnDelisle/AzureHybridUsePolicyInitiative/main/policies//SQL/azure-sql-database-elastic-pool-hub/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/JohnDelisle/AzureHybridUsePolicyInitiative/main/policies//SQL/azure-sql-database-elastic-pool-hub/azurepolicy.parameters.json' -Mode All

# Set the Policy Parameter (JSON format) to meet your needs.
# "AuditIfNotExists" -- Audit and report on resources that are non-compliant
# "DeployIfNotExists" -- Automatically fix resources that are non-compliant
# "Disabled" -- Disable policy
$policyParameters = '{ "effect": { "value": "AuditIfNotExists" } }'

# Set the scope to a resource group; may also be a subscription or management group
$scope = Get-AzResourceGroup -Name 'YourResourceGroup' 

# Create the Policy Assignment
$policyAssignment = New-AzPolicyAssignment -Name 'azure-sql-database-elastic-pool-hub-assignment' -DisplayName ' Assignment' -Scope $scope.ResourceId -PolicyDefinition $policyDefinition -PolicyParameter $policyParameters -IdentityType SystemAssigned -Location 'LocationForSystemAssignmedManagedIdentity'

# Create a Role Assignment
# Grants the System Assigned Managed Identity (created duing Policy Assignement) with the RBAC Role (specified in the policy) to the Scope (specified in $scope above).
# This enables Azure Policy to make changes to resources when the "DeployIfNotExists" effect is used.
$roleAssignment = $policyDefinition.Properties.PolicyRule.then.details.roleDefinitionIds | ForEach-Object { New-AzRoleAssignment -PrincipalId $policyAssignment.Identity.PrincipalId -Scope $scope.ResourceId -RoleDefinitionId $_.Split('/')[-1] }

````

## Try with Azure CLI

```cli
# Create the Policy Definition (Subscription scope)
policyDefinition=$(az policy definition create --name 'azure-sql-database-elastic-pool-hub' --display-name '' --description '' --rules 'https://raw.githubusercontent.com/JohnDelisle/AzureHybridUsePolicyInitiative/main/policies//SQL/azure-sql-database-elastic-pool-hub/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/JohnDelisle/AzureHybridUsePolicyInitiative/main/policies//SQL/azure-sql-database-elastic-pool-hub/azurepolicy.parameters.json' --mode All)

# Set the Policy Parameter (JSON format)
# "AuditIfNotExists" -- Audit and report on resources that are non-compliant
# "DeployIfNotExists" -- Automatically fix resources that are non-compliant
# "Disabled" -- Disable policy
policyParameters='{ "effect": { "value": "AuditIfNotExists" } }'

# Set the scope to a resource group; may also be a subscription or management group
scope=$(az group show --name 'YourResourceGroup')

# Create the Policy Assignment
policyAssignment=$(az policy assignment create --name 'azure-sql-database-elastic-pool-hub-assignment' --display-name ' Assignment' --scope `echo $scope | jq '.id' -r` --policy `echo $definition | jq '.name' -r` --params "$policyparam")

# Create a Role Assignment
# Grants the System Assigned Managed Identity (created duing Policy Assignement) with the RBAC Role (specified in the policy) to the Scope (specified in $scope above).
# This enables Azure Policy to make changes to resources when the "DeployIfNotExists" effect is used.
spId=$(echo $policyAssignment | jq '.Identity.PrincipalId' -r)
scopeId=$(echo $scope | jq '.id' -r)
for roleId in $(echo $policyDefinition | jq '.Properties.PolicyRule.then.details.roleDefinitionIds' -r); do
    az role assignment create --assignee $spId --role $roleId --scope $scopeId
done

```
