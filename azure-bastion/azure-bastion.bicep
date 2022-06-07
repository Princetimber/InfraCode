param vnetNameSuffix string = 'vnet'
param location string = resourceGroup().location
var vnetName = '${toLower(resourceGroup().name)}${vnetNameSuffix}'
resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name:vnetName
}
param bastionSubnet object = {
  name:'azureBastionSubnet'
  subnet:[
    {
      name:'azureBastionSubnet'
      addressPrefix:'10.0.1.0/26' // specify bastion IpAddress Range
    }
  ]
}
resource bastionsubnet 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' = {
  name:bastionSubnet.name
  properties:{
    addressPrefix:bastionSubnet.addressPrefix
  }
  parent:vnet
}
resource pubIp 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name:'PubIpAddress'
  location:location
  properties:{
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod:'Static'
    idleTimeoutInMinutes: 4
  }
  sku:{
    name:'Standard'
  }
}

resource bastion 'Microsoft.Network/bastionHosts@2021-02-01' = {
  name:'${vnet.name}-bastion'
  location:location
  properties:{
    ipConfigurations:[
      {
        name:'IpConfigurations'
        properties:{
          publicIPAddress:{
            id:pubIp.id
          }
          subnet:{
            id:bastionSubnet.id
          }
        }
      }
    ]
  }
  sku:{
    name:'Standard'
  }
}
