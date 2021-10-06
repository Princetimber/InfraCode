module vnet 'virtualnetwork.bicep' = {
  name: 'vnetdeploy'
}
output vnet string = vnet.outputs.networkname
output Id string = vnet.outputs.networkId
