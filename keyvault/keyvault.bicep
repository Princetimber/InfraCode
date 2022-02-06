param suffix string
param vnetsuffix string
param objectId string //AAD User objectId
param pubIpAddress string //Specify Public ipaddress space
param location string = resourceGroup().location
param tenantId string = subscription().tenantId
var vnetName = '${toLower(resourceGroup().name)}${vnetsuffix}'
var vaultname = '${toLower(resourceGroup().name)}${suffix}'
resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name: vnetName
}
var Id = vnet.id
var gatewaySubnetId = '${Id}/subnets/GatewaySubnet'
var subnet1Id = '${Id}/subnets/subnet1'
var subnet2Id = '${Id}/subnets/subnet2'

resource keyvaults 'Microsoft.KeyVault/vaults@2021-06-01-preview' = {
  name:vaultname
  location:location
  tags:{
    DisplayName:'KeyVaults'
  }
  properties:{
    enabledForDeployment: true
    enabledForDiskEncryption: true
    enabledForTemplateDeployment: true
    enablePurgeProtection: true
    enableRbacAuthorization: false
    enableSoftDelete: true
    provisioningState: 'Succeeded'
    sku:{
      name:  'standard'
      family: 'A'
    }
    tenantId:tenantId
    softDeleteRetentionInDays:30
    accessPolicies:[
      {
        objectId: objectId
        permissions: {
          certificates:[
            'all'
          ]
          keys:[
            'all'
          ]
          secrets:[
            'all'
          ]
          storage:[
            'all'
          ]
        }
        tenantId:tenantId
      }
    ]
    networkAcls:{
      bypass:'AzureServices'
      defaultAction:'Deny'
      ipRules:[
        {
          value:pubIpAddress
        }
      ]
      virtualNetworkRules:[
        {
          id:gatewaySubnetId
        }
        {
          id:subnet1Id
        }
        {
          id:subnet2Id
        }
      ]
    }
  }
}
output keyvaultname string = keyvaults.name
output vaultId string = keyvaults.id
output vaultUri string = keyvaults.properties.vaultUri
