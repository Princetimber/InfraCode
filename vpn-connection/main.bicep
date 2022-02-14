module connections 'vpn-connections.bicep' = {
  name: 'DeployVpnConnection'
  params:{
    localnetgwNameSuffix: 'rv340'
    vnetgwNameSuffix: 'vpngateway'
    connectionName:'rv340-2-vpngateway'
    sharedKey:''
  }
}
