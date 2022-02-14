module vnet 'virtualnetwork.bicep' = {
  name: 'vnetdeploy'
  params:{
    vnetnameSuffix:''
  }
}
output vnet string = vnet.outputs.networkname
output Id string = vnet.outputs.networkId
