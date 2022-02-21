param location string = resourceGroup().location
module vaults 'keyvault.bicep' = {
  name: 'DeployKeyVault'
  params: {
    location: location
    suffix:''
    vnetsuffix: 'vnet'
    objectId: ''//Specify AAD user ObjectId
    pubIpAddress: ''//specify Public Ipaddress that can access keyvault
  }
}
