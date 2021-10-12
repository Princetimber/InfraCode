param keyvaultNameSuffix string = 'keyVault'
var vaultName = '${toLower(resourceGroup().name)}${keyvaultNameSuffix}'
resource vault 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = {
  name:vaultName
}
module domainController 'dc.bicep' = {
  name: 'provisionDomainControllerVM'
  params: {
    adminPassword: vault.getSecret('SecPass')
    adminUsername:'localadmin'
    virtualmachineCount:2
    virtualMachineExtensionCustomScriptUri:'https://raw.githubusercontent.com/Princetimber/InfraCode/main/multi-dc-vm/config.ps1'//Enter Uri for Github Raw Script
  }
}
