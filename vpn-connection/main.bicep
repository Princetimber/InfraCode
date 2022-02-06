module connections 'vpn-connections.bicep' = {
  name: 'DeployVpnConnection'
  params:{
    localnetgwNameSuffix: 'localnetgw'
    vnetgwNameSuffix: 'vnetgw'
    connectionName:'cloud2vpn'
    sharedKey:''
  }
}
