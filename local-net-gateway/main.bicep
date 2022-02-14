module localNetwork 'local-network-gateway.bicep' = {
  name:'DeployLocalnetworkGateway'
  params: {
    gatewayNameSuffix:'rv340'//enter gateway name suffix
    addressPrefixes: [
      '10.0.1.0/24'
      '10.0.2.0/24'
      '10.0.3.0/24'
      '50.101.100.0/24'
    ]
    gatewayPublicIpAddress: ''//Specify PublicIpAddress CIDR
  }
}
output Name string = localNetwork.outputs.localnetworkName
