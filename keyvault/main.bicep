module vaults 'keyvault.bicep' = {
  name: 'DeployKeyVault'
  params: {
    suffix:'keyvault'
    vnetsuffix: 'vnet'
    objectId: ''//Specify AAD user ObjectId
    pubIpAddress: '62.31.74.157'//specify Public Ipaddress that can access keyvault
  }
}
