@description('specify virtual network gateway name suffix')
param vnetGatewayNameSuffix string = 'vnetgw'

@description('Specify PublicIpAddress name')
param pubIpAddressname string = 'PubIp'

@description('specify default resource location')
param location string = resourceGroup().location

@description('specify virtualNetwork name suffix')
param vnetNameSuffix string = 'vnet'

var vnetName = '${toLower(resourceGroup().name)}${vnetNameSuffix}'
var vnetgwname = '${toLower(resourceGroup().name)}${vnetGatewayNameSuffix}'
resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name: vnetName
}
var vnetid = vnet.id
var subnetId = '${vnetid}/Subnets/GatewaySubnet'

resource PublicIpAddress 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name:pubIpAddressname
  location:location
  sku:{
    name:'Basic'
    tier:'Regional'
  }
  properties:{
    idleTimeoutInMinutes:4
    publicIPAddressVersion:'IPv4'
    publicIPAllocationMethod:'Dynamic'
  }
}
resource vnetgateway 'Microsoft.Network/virtualNetworkGateways@2021-02-01' = {
  name:vnetgwname
  location:location
  tags:{
    DisplayName:'VirtualNetworkGateways'
  }
  properties:{
    sku:{
      name: 'VpnGw2'
      tier:'VpnGw2'
    }
    gatewayType:'Vpn'
    ipConfigurations:[
      {
        id:PublicIpAddress.id
        name:PublicIpAddress.name
        properties:{
          publicIPAddress:{
            id:PublicIpAddress.id
          }
          subnet:{
            id:subnetId
          }
          privateIPAllocationMethod:'Dynamic'
        }
      }
    ]
    vpnGatewayGeneration:'Generation2'
    vpnType:'RouteBased'
  }
}
output vnetgwId string = vnetgateway.id
output vnetgwname string = vnetgateway.name
