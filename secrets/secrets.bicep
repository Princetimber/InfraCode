@description('Specify Secret Name')
param secretname string

@description('Specify secure secretvalue')
@secure()
param secretvalue string

param exp int
param nbf int
param keyvaultnamesuffix string = 'keystore'

var keyvaultname = '${toLower(resourceGroup().name)}${keyvaultnamesuffix}'
resource keyvault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name:keyvaultname
}
resource secrets 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  name: secretname
  properties: {
    attributes:{
      enabled:true
       exp: exp// not actual values
       nbf: nbf//not actual values
    }
    value:secretvalue
  }
  parent:keyvault
}
output name string = secrets.name
