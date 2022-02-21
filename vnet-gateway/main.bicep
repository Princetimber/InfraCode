param location string = resourceGroup().location
module vnetgw 'vnet-gateway.bicep' = {
  name: 'DeployVnetgateways'
  params:{
    location: location
    vnetGatewayNameSuffix: 'vpngateway'
    vnetNameSuffix: 'vnet'
    pubIpAddressname:'pubip'
  }
}
output Name string = vnetgw.outputs.vnetgwname
output Id string = vnetgw.outputs.vnetgwId
