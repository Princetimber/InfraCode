module gatewaySubnet 'gatewaysubnet.bicep' = {
  name: 'gatewaysubnetdeploy'
  params:{
    name: 'gatewaysubnetdeploy'
    addressPrefix:'50.171.103/27'
  }
}
