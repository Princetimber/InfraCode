param location string = resourceGroup().location
module connections 'vpn-connections.bicep' = {
  name: 'DeployVpnConnection'
  params:{
    location: location
    localnetgwNameSuffix: 'rv340'
    vnetgwNameSuffix: 'vpngateway'
    connectionName:'rv340-2-vpngateway'
    sharedKey:''
  }
}
