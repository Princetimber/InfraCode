module vaults 'keyvault.bicep' = {
  name: 'DeployKeyVault'
  params: {
    objectId: ''//Specify AAD user ObjectId
    pubIpAddress: ''//specify Public Ipaddress that can access keyvault
  }
}
