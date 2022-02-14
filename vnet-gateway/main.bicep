module vnetgw 'vnet-gateway.bicep' = {
  name: 'DeployVnetgateways'
  params:{
    vnetGatewayNameSuffix: 'vpngateway'
    vnetNameSuffix: 'vnet'
    pubIpAddressname:'pubip'
  }
}
output Name string = vnetgw.outputs.vnetgwname
output Id string = vnetgw.outputs.vnetgwId
