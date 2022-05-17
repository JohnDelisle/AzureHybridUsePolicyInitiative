# Hybrid Use Benefit (HUB) for SQL Database Elastic Pool

This policy assists with the governance of Azure Hybrid Use Benefit on Azure SQL Database in Elastic Pools.

## Azure Policy Docs

See Microsoft documentation for background and use of Azure Policy samples [docs.microsoft.com](https://docs.microsoft.com/en-us/azure/governance/policy/samples/), including this policy.

## Try with Azure portal

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/?#blade/Microsoft_Azure_Policy/CreatePolicyDefinitionBlade/uri/https%3a%2f%2fraw.githubusercontent.com%2fJohnDelisle%2fAzureHybridUsePolicyInitiative%2fmain%2fpolicies%2f%2fSQL%2fazure-sql-database-elastic-pool-hub%2fazurepolicy.json)

## Try with Azure PowerShell

````powershell
# Create the Policy Definition (Subscription scope)
$definition = New-AzPolicyDefinition -Name 'azure-sql-database-elastic-pool-hub' -DisplayName 'Hybrid Use Benefit (HUB) for SQL Database Elastic Pool' -description 'This policy assists with the governance of Azure Hybrid Use Benefit on Azure SQL Database in Elastic Pools.' -Policy 'https://raw.githubusercontent.com/JohnDelisle/AzureHybridUsePolicyInitiative/main/policies//SQL/azure-sql-database-elastic-pool-hub/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/JohnDelisle/AzureHybridUsePolicyInitiative/main/policies//SQL/azure-sql-database-elastic-pool-hub/azurepolicy.parameters.json' -Mode All

# Set the scope to a resource group; may also be a subscription or management group
$scope = Get-AzResourceGroup -Name 'YourResourceGroup'

# Set the Policy Parameter (JSON format)
$policyparam = '{ "effect": { "value": "Audit" } }'

# Create the Policy Assignment
$assignment = New-AzPolicyAssignment -Name 'azure-sql-database-elastic-pool-hub-assignment' -DisplayName 'Hybrid Use Benefit (HUB) for SQL Database Elastic Pool Assignment' -Scope $scope.ResourceId -PolicyDefinition $definition -PolicyParameter $policyparam
````

## Try with Azure CLI

```cli
# Create the Policy Definition (Subscription scope)
definition=$(az policy definition create --name 'azure-sql-database-elastic-pool-hub' --display-name 'Hybrid Use Benefit (HUB) for SQL Database Elastic Pool' --description 'This policy assists with the governance of Azure Hybrid Use Benefit on Azure SQL Database in Elastic Pools.' --rules 'https://raw.githubusercontent.com/JohnDelisle/AzureHybridUsePolicyInitiative/main/policies//SQL/azure-sql-database-elastic-pool-hub/azurepolicy.rules.json' --params 'https://raw.githubusercontent.com/JohnDelisle/AzureHybridUsePolicyInitiative/main/policies//SQL/azure-sql-database-elastic-pool-hub/azurepolicy.parameters.json' --mode All)

# Set the scope to a resource group; may also be a subscription or management group
scope=$(az group show --name 'YourResourceGroup')

# Set the Policy Parameter (JSON format)
policyparam='{ "effect": { "value": "Audit" } }'

# Create the Policy Assignment
assignment=$(az policy assignment create --name 'azure-sql-database-elastic-pool-hub-assignment' --display-name 'Hybrid Use Benefit (HUB) for SQL Database Elastic Pool Assignment' --scope `echo $scope | jq '.id' -r` --policy `echo $definition | jq '.name' -r` --params "$policyparam")
```
