param natgatewayNamesuffix string
param location string = resourceGroup().location
param pubIpNameSuffix string
var pubIpName = '${toLower(resourceGroup().name)}${pubIpNameSuffix}'
var natgatewayName = '${toLower(resourceGroup().name)}${natgatewayNamesuffix}'
resource pubIp 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name:pubIpName
  location: location
  sku:{
    name:'Standard'
  }
  properties:{
    publicIPAddressVersion:'IPv4'
    publicIPAllocationMethod:'Static'
    idleTimeoutInMinutes: 4
  }
}
resource natgateways 'Microsoft.Network/natGateways@2021-02-01' = {
  name:natgatewayName
  location: location
  sku:{
    name:'Standard'
  }
  tags:{
    DisplayName:'Natgateways'
  }
  properties:{
    idleTimeoutInMinutes:4
    publicIpAddresses:[
      {
        id:pubIp.id
      }
    ]
  }
}
output natgatewayId string = natgateways.id
output natgatewayname string = natgateways.name
