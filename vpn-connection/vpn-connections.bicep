@description('Specify connection shared key')
param sharedKey string

@description('specify vpn connection name')
param connectionName string

param location string = resourceGroup().location
param vnetgwNameSuffix string
param localnetgwNameSuffix string 
var vnetgwName = '${toLower(resourceGroup().name)}${vnetgwNameSuffix}'
var localNetgwname = '${toLower(resourceGroup().name)}${localnetgwNameSuffix}'
resource vnetgw 'Microsoft.Network/virtualNetworkGateways@2021-02-01' existing = {
  name: vnetgwName
}
var vnetgwId = vnetgw.id
resource localnetgw 'Microsoft.Network/localNetworkGateways@2021-02-01' existing = {
  name: localNetgwname
}
var locNetgwId = localnetgw.id

resource vpnconnections 'Microsoft.Network/connections@2021-02-01' = {
  name: connectionName
  location:location
  properties:{
    connectionType:'IPsec'
    connectionProtocol:'IKEv2'
    sharedKey:sharedKey
    virtualNetworkGateway1:{
      id:vnetgwId
      properties:{
        sku:{
          name:'VpnGw2'
          tier:'VpnGw2'
        }
        gatewayType: 'Vpn'
        vpnType:'RouteBased'
      }
    }
    localNetworkGateway2:{
      id:locNetgwId
      location:location
      properties:{
        gatewayIpAddress:localnetgw.properties.gatewayIpAddress
        localNetworkAddressSpace:{
          addressPrefixes:localnetgw.properties.localNetworkAddressSpace.addressPrefixes
        }
      }
    }
    enableBgp:false
    useLocalAzureIpAddress:false
    routingWeight:0
  }
}
output connectionName string = vpnconnections.name
