param nsgNameSuffix string = 'nsg'
param sourceAddressPrefixes array
param destinationAddressPrefix string
param location string = resourceGroup().location
var nsgname = '${toLower(resourceGroup().name)}${nsgNameSuffix}'
var allowRdpInbound = '${nsgname}/Allow_Rdp_Inbound'
var allowWinRMInbound = '${nsgname}/Allow_WinRM_Inbound'
var allowHttpsInbound = '${nsgname}/Allow_https_Inbound'
var allowSSHInbound = '${nsgname}/Allow_SSH_Inbound'
var allowhttpInbound = '${nsgname}/Allow_http_inbound'
var allowWinRMOutbound= '${nsgname}/Allow_WinRM_Outbound'

resource nsg 'Microsoft.Network/networkSecurityGroups@2021-02-01' ={
  name:nsgname
  location:location
  tags:{
    DisplayName:'NetworkSecurityGroups'
  }
  properties:{
    securityRules:[
      {
        name:'Allow_Rdp_Inbound'
        properties:{
          access:'Allow'
          description:'Allow_Rdp_Inbound'
          direction:'Inbound'
          priority: 201
          protocol:'Tcp'
          sourceAddressPrefixes: sourceAddressPrefixes
          sourcePortRange:'*'
          destinationAddressPrefix:'VirtualNetwork'
          destinationPortRange: '3360-3400'
        }
      }
      {
        name:'Allow_WinRM_Inbound'
        properties:{
          access:'Allow'
          description:'Allow_WinRM_Inbound'
          direction:'Inbound'
          priority:202
          protocol:'Tcp'
          sourceAddressPrefixes: sourceAddressPrefixes
          sourcePortRange: '*'
          destinationAddressPrefix:'VirtualNetwork'
          destinationPortRange:'5970-6000'
        }
      }
      {
        name:'Allow_https_Inbound'
        properties:{
          access: 'Allow'
          direction: 'Inbound'
          priority:203
          protocol: 'Tcp'
          description:'Allow_https_Inbound'
          sourceAddressPrefix:'*'
          sourcePortRange: '*'
          destinationAddressPrefix:'VirtualNetwork'
          destinationPortRange:'443'
        }
      }
      {
        name:'Allow_SSH_Inbound'
        properties:{
          access: 'Allow'
          description:'Allow_SSH_inbound'
          direction: 'Inbound'
          protocol: 'Tcp'
          priority:204
          sourceAddressPrefixes: sourceAddressPrefixes
          sourcePortRange:'*'
          destinationAddressPrefix:'VirtualNetwork'
          destinationPortRange:'22'

        }
      }
      {
        name:'Allow_http_inbound'
        properties:{
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          priority:205
          sourceAddressPrefix:'*'
          sourcePortRange:'*'
          destinationAddressPrefix:'VirtualNetwork'
          destinationPortRange:'80'
        }
      }
      {
        name:'Allow_WinRM_Outbound'
        properties:{
          access: 'Allow'
          direction: 'Outbound'
          protocol: 'Tcp'
          priority: 301
          sourceAddressPrefix:'VirtualNetwork'
          sourcePortRange:'*'
          destinationAddressPrefix:destinationAddressPrefix
          destinationPortRange:'5970-6000'
        }
      }
    ]
  }
}
resource allowRdpInbound_rule 'Microsoft.Network/networkSecurityGroups/securityRules@2021-02-01'= {
  name:allowRdpInbound
  properties:{
    access: 'Allow'
    direction: 'Inbound'
    protocol: 'Tcp'
    description:'Allow_Rdp_Inbound'
    priority:201
    sourceAddressPrefixes:sourceAddressPrefixes
    sourcePortRange:'*'
    destinationAddressPrefix:'VirtualNetwork'
    destinationPortRange:'3360-3400'
  }
  dependsOn:[
    nsg
  ]
}
resource allowWinRMInbound_rule 'Microsoft.Network/networkSecurityGroups/securityRules@2021-02-01' = {
  name:allowWinRMInbound
  dependsOn:[
    nsg
  ]
  properties:{
    access: 'Allow'
    description:'Allow_WinRM_Inbound'
    direction: 'Inbound'
    protocol: 'Tcp'
    priority:202
    sourceAddressPrefixes: sourceAddressPrefixes
    sourcePortRange:'*'
    destinationAddressPrefix:'VirtualNetwork'
    destinationPortRange:'5970-6000'
  }
}
resource allowhttpsInbound_rule 'Microsoft.Network/networkSecurityGroups/securityRules@2021-02-01'={
  name:allowHttpsInbound
 dependsOn:[
   nsg
 ]
  properties:{
     access: 'Allow'
     description:'Allow_Https_Inbound'
     direction: 'Inbound'
     priority:203
     protocol: 'Tcp'
     sourceAddressPrefix:'*'
     sourcePortRange:'*'
     destinationAddressPrefix:'VirtualNetwork'
     destinationPortRange:'443'
  }
}
resource allowSSHInbound_rule 'Microsoft.Network/networkSecurityGroups/securityRules@2021-02-01'= {
  name:allowSSHInbound
  dependsOn:[
    nsg
  ]
  properties:{
    access: 'Allow'
    description:'Allow_SSH_Inbound'
    direction: 'Inbound'
    priority:204
    protocol: 'Tcp'
    sourceAddressPrefixes: sourceAddressPrefixes
    sourcePortRange: '*'
    destinationAddressPrefix:'VirtualNetwork'
    destinationPortRange: '22'

  }
}
resource allowhttpInbound_rule 'Microsoft.Network/networkSecurityGroups/securityRules@2021-02-01'= {
  name:allowhttpInbound
  dependsOn:[
    nsg
  ]
  properties:{
    access: 'Allow'
    direction: 'Inbound'
    protocol: 'Tcp'
    priority:205
    description:'Allow_http_Inbound'
    sourceAddressPrefix:'*'
    sourcePortRange: '*'
    destinationAddressPrefix:'VirtualNetwork'
    destinationPortRange:'80'
  }
}
resource allowWinRMOutbound_rule 'Microsoft.Network/networkSecurityGroups/securityRules@2021-02-01'= {
  name:allowWinRMOutbound
  dependsOn:[
    nsg
  ]
  properties:{
    access: 'Allow'
    direction: 'Outbound'
    protocol: 'Tcp'
    priority:301
    sourceAddressPrefix:'VirtualNetwork'
    sourcePortRange:'*'
    destinationAddressPrefix:destinationAddressPrefix
    destinationPortRange:'5970-6000'
  }
}
output nsgname string = nsg.name
output nsgId string = nsg.id
