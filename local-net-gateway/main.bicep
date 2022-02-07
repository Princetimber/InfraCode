module localNetwork 'local-network-gateway.bicep' = {
  name:'DeployLocalnetworkGateway'
  params: {
    gatewayNameSuffix:''//enter gateway name suffix
    addressPrefixes: [
      '10.0.1.0/24'
      '10.0.2.0/24'
      '10.0.3.0/24'
      '50.101.100.0/24'
    ]
    gatewayPublicIpAddress: '62.31.74.157/32'//Specify PublicIpAddress CIDR
  }
}
output Name string = localNetwork.outputs.localnetworkName
