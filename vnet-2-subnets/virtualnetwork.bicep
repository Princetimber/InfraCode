param nsgSuffix string = 'nsg'
param natgwSuffix string = 'natgw'
param vnetnameSuffix string
param vnetSettings object = {
  name:'${toLower(resourceGroup().name)}${vnetnameSuffix}'
  location: resourceGroup().location
  addressPrefixes:[
    //specify virtualNetworks IpAddress Range
  ]
}
param subnets array = [
    {
      name:'subnet1'
      addressPrefix:''//specify subnet1 IpAddress Range
    }
    {
      name:'subnet2'
      addressPrefix:''//specify subnet2 IpAddress Range
    }

]
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
    subnets:[for subnet in subnets: {
      name:subnet.name
      properties:{
        addressPrefix:subnet.addressPrefix
        networkSecurityGroup:{
          id:nsgId
        }
        natGateway:{
          id:natgwId
        }
        serviceEndpoints:[
          {
            service:'Microsoft.storage'
          }
          {
            service:'Microsoft.keyvault'
          }
          {
            service:'Microsoft.AzureActiveDirectory'
          }
        ]
      }
    }]
    enableDdosProtection: false
    enableVmProtection:false
  }
}
output networkname string = vnet.name
output networkId string = vnet.id
