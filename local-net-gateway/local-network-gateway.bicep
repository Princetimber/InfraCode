@description('Specify gateway Public IpAddress')
param gatewayPublicIpAddress string

@description('specify gateway name suffix')
param gatewayNameSuffix string

@description('specify resource location')
param location string = resourceGroup().location

@description('Specify LocalNetwork IpAddress Space')
param addressPrefixes array

var gatewayName = '${toLower(resourceGroup().name)}${gatewayNameSuffix}'
resource localNetworkGateway 'Microsoft.Network/localNetworkGateways@2021-02-01' = {
  name:gatewayName
  location:location
  tags:{
    DisplayName:'LocalNetwork Gateways'
  }
  properties:{
    gatewayIpAddress:gatewayPublicIpAddress
    localNetworkAddressSpace:{
      addressPrefixes:addressPrefixes
    }
  }
}
output localnetworkName string = localNetworkGateway.name
