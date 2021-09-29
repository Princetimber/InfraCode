@description('specify dnszone name')
param privateDnsZonename string = 'fountview.co.uk'
param registrationEnabled bool = true

@description('specify virtualnetwork name suffix')
param vnetNameSuffix string = 'vnet'
var vnetName = '${toLower(resourceGroup().name)}${vnetNameSuffix}'
resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name: vnetName
}
var vnetId = vnet.id

resource privatednszone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name:privateDnsZonename
  location: 'Global'
  tags:{
    DisplayName:'Dns Zone'
  }
}
resource virtualNetworkLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name:'${privatednszone.name}/${privatednszone.name}-Link'
  location:'Global'
  properties:{
    registrationEnabled:registrationEnabled
    virtualNetwork:{
      id:vnetId
    }
  }
}
output dnszonename string = privatednszone.name
