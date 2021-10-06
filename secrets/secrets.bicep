@description('Specify Secret Name')
param secretname string = 'SecPass'

@description('Specify secure secretvalue')
@secure()
param secretvalue string

param keyvaultnamesuffix string = 'keyvault'
var keyvaultname = '${toLower(resourceGroup().name)}${keyvaultnamesuffix}'
resource keyvault 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = {
  name: keyvaultname
}

resource secrets 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
  name:secretname
  properties:{
    attributes:{
      enabled: true
      nbf:63800605009
      exp:1664918862
    }
    value:secretvalue
  }
  parent:keyvault
}
output name string = secrets.name

