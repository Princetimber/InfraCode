module vnetgw 'vnet-gateway.bicep' = {
  name: 'DeployVnetgateways'
  params:{
    vnetGatewayNameSuffix: 'vnetgw'
    vnetNameSuffix: 'vnet'
    pubIpAddressname:'pubip'
  }
}
output Name string = vnetgw.outputs.vnetgwname
output Id string = vnetgw.outputs.vnetgwId
