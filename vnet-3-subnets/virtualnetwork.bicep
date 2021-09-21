param nsgSuffix string = 'nsg'
param natgwSuffix string = 'natgw'
param vnetnameSuffix string = 'vnet'
param vnetSettings object = {
  name:'${toLower(resourceGroup().name)}${vnetnameSuffix}'
  location: resourceGroup().location
  addressPrefixes:[
    {
      name:'IpAddressPrefix'
      addressPrefix:'10.0.0.0/16'//specify virtualNetworks IpAddress Range
    }
  ]
}
param subnets array = [
    {
      name:'gatewaySubnet'
      addressPrefix:'10.0.0.0/27'//specify gatewaySubnet IpAddress Range

    }
    {
      name:'subnet1'
      addressPrefix:'10.1.1.0/24'//specify subnet1 IpAddress Range
    }
    {
      name:'subnet2'
      addressPrefix:'10.1.2.0/24'//specify subnet2 IpAddress Range
    }

]
var subnetSetttings =[for subnet in subnets:{
  name: subnet.name
  properties:{
    addressPrefix:subnet.addressPrefix
    natGateway:{
      id:natgwId
    }
    networkSecurityGroup:{
      id:nsgId
    }
    serviceEndpoints:[
      {
        service:'Microsoft.storage'
      }
      {
        service:'Microsoft.KeyVault'
      }
      {
        service:'Microsoft.AzureActiveDirectory'
      }
    ]

  }
}]
var nsgname = '${toLower(resourceGroup().name)}${nsgSuffix}'
resource nsg 'Microsoft.Network/networkSecurityGroups@2021-02-01' existing = {
  name:nsgname
}
var nsgId = nsg.id
var natgwname = '${toLower(resourceGroup().name)}${natgwSuffix}'
resource natgw 'Microsoft.Network/natGateways@2021-02-01' existing = {
  name:natgwname
}
var natgwId = natgw.id
resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name:vnetSettings.name
  location:vnetSettings.location
  tags:{
    displayName:'Virtual Network'
  }
  properties:{
    addressSpace:{
      addressPrefixes:vnetSettings.addressPrefixes
    }
    subnets:subnetSetttings
    enableDdosProtection: false
    enableVmProtection:false
  }
}
