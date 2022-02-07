param name string 
param addressPrefix string
param serviceEndpoints array = [
  {
    Service:'Microsoft.Storage'
  }
  {
    service:'Microsoft.keyvault'
  }
  {
    service:'Microsoft.AzureActiveDirectory'
  }
]
param suffix string = 'vnet'
var vnetname = '${toLower(resourceGroup().name)}${suffix}'
resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name: vnetname
}
resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' = {
  name:name
  parent:vnet
  properties:{
    addressPrefix: addressPrefix
    serviceEndpoints:serviceEndpoints
  }
}
