@description('specify storage resource name suffix')
param namesuffix string

@description('spacify storage account resource skus')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Standard_RAGZRS'
  'Premium_LRS'
  'Premium_ZRS'
])
param skuName string = 'Standard_LRS'

@allowed([
  'StorageV2'
  'BlobStorage'
  'BlockBlobStorage'
  'FileStorage'
  'Storage'
])
param kind string = 'StorageV2'

@allowed([
  'Hot'
  'Cool'
])
param accessTier string = 'Hot'
param publicIpAddress string
param vnetNameSuffix string = 'vnet'

@description('Specify whether to create new storage account or use existing')
@allowed([
  'new'
  'existing'
])
param stgNewOrExisting string = 'new'
param location string = resourceGroup().location
var vnetname = '${toLower(resourceGroup().name)}${vnetNameSuffix}'
resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name: vnetname
}
var vnetId = vnet.id
var subnet1id = '${vnetId}/subnets/subnet1'
var subnet2Id = '${vnetId}/subnets/subnet2'
var gatewaySubnetId = '${vnetId}/subnets/gatewaySubnet'
var storageaccountName ='${uniqueString(resourceGroup().id)}${namesuffix}'

resource storageaccounts 'Microsoft.Storage/storageAccounts@2021-04-01' = if (stgNewOrExisting == 'new') {
  name:storageaccountName
  location: location
  tags:{
    DisplayName: 'Storage Accounts'
  }
  sku:{
    name: skuName
  }
  kind:kind
  properties:{
    accessTier:accessTier
    allowBlobPublicAccess:true
    allowCrossTenantReplication:true
    allowSharedKeyAccess:true
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly:true
    isNfsV3Enabled:true
    largeFileSharesState:'Enabled'
    isHnsEnabled:true
    networkAcls:{
      defaultAction: 'Deny'
      bypass:'AzureServices'
      virtualNetworkRules:[
        {
          id: gatewaySubnetId
          action:'Allow'
          state:'Succeeded'
        }
        {
          id: subnet1id
          action:'Allow'
          state:'Succeeded'
        }
        {
          id: subnet2Id
          action:'Allow'
          state: 'Succeeded'
        }
      ]
      ipRules:[
        {
          value: publicIpAddress
          action:'Allow'
        }
      ]
    }
  }
}
output name string = storageaccounts.name
output id string = storageaccounts.properties.primaryEndpoints.blob
