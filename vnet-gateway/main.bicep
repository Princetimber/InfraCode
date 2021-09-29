module vnetgw 'vnet-gateway.bicep' = {
  name: 'DeployVnetgateways'
}
output Name string = vnetgw.outputs.vnetgwname
output Id string = vnetgw.outputs.vnetgwId
