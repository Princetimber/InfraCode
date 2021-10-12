@description('specify machine names')
param virtualMachineName string = 'dc'

@description('specify virtualmachine sku')
@allowed([
  '2022-Datacenter-core'
  '2022-Datacenter'
  '2022-Datacenter-g2'
  '2022-Datacenter-core-g2'
])
param sku string = '2022-Datacenter-core-g2'

@description('Specify the default storageAccount type')
@allowed([
  'Standard_LRS'
  'Premium_LRS'
])
param storageAccountType string = 'Standard_LRS'

@description('specify virtualMachine Size')
@allowed([
  'Standard_DS1_v2'
  'Standard_DS2_v2'
])
param vmSize string = 'Standard_DS1_v2'

@description('Specify computer account username')
param adminUsername string

@description('Specify adminUserPassword')
@secure()
param adminPassword string

@description('Specify VirtualMachine DiskSize in gigabytes')
@minValue(50)
@maxValue(100)
param diskSizeGB int = 100

@description('Specify VirtualMachine count')
@minValue(1)
param virtualmachineCount int

param availabilitySetNameSuffix string = 'avset'
param proximityPlacementGroupNameSuffix string = 'ppgrp'
param virtualNetworkNameSuffix string = 'vnet'
param storageAccountNamePreffix string = 'stga'
param keyvaultNameSuffix string = 'keyVault'
param networkInterfaceNameSuffix string = '-nic'
param licenseType string = 'Windows_Server'
param publisher string = 'MicrosoftWindowsServer'
param offer string = 'WindowsServer'
param virtualMachineExtensionCustomScriptUri string

var location = resourceGroup().location
var virtualMachineCountRange = range(0,virtualmachineCount)
var availabilitySetName = '${toLower(resourceGroup().name)}${availabilitySetNameSuffix}'
var proximityPlacementGroupName = '${toLower(resourceGroup().name)}${proximityPlacementGroupNameSuffix}'
var virtualNetworkName = '${toLower(resourceGroup().name)}${virtualNetworkNameSuffix}'
var storageAccountName = '${storageAccountNamePreffix}${uniqueString(resourceGroup().id)}'
var vaultName = '${toLower(resourceGroup().name)}${keyvaultNameSuffix}'

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name: virtualNetworkName
}
var vnetId = vnet.id
var subnetId = '${vnetId}/subnets/subnet1'
resource storage 'Microsoft.Storage/storageAccounts@2021-04-01' existing = {
  name: storageAccountName
}
var storageUri = storage.properties.primaryEndpoints.blob
resource vaults 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = {
  name: vaultName
}
var vaultId = vaults.id
var vaultUri = vaults.properties.vaultUri
var certificateUrl = '${vaultUri}/secrets/FTSCERT/216d00068f504969924e9f1dc3d99e25'//Specify key Version

resource ppgrp 'Microsoft.Compute/proximityPlacementGroups@2021-04-01' = {
  name:proximityPlacementGroupName
  location:location
  tags:{
    DisplayName:'ProximityPlacement Group'
  }
  properties:{
    proximityPlacementGroupType:'Standard'
  }
}
resource avset 'Microsoft.Compute/availabilitySets@2021-04-01' = {
  name: availabilitySetName
  tags:{
    DisplayName:'Availability Set'
  }
  location:location
  properties:{
    platformFaultDomainCount:2
    platformUpdateDomainCount: 5
    proximityPlacementGroup:{
      id:ppgrp.id
    }
  }
}
resource vmnic 'Microsoft.Network/networkInterfaces@2021-02-01' = [for i in virtualMachineCountRange: {
  name:'${virtualMachineName}${i+1}${networkInterfaceNameSuffix}'
  location:location
  tags:{
    DisplayName:'Network Interface'
  }
  properties:{
    ipConfigurations:[
      {
        name:'IpConfiguration'
        properties:{
          primary:true
          subnet:{
            id:subnetId
          }
          privateIPAddressVersion:'IPv4'
          privateIPAllocationMethod:'Dynamic'
        }
      }
    ]
  }
}]
resource virtualmachine 'Microsoft.Compute/virtualMachines@2021-04-01' = [for i in  virtualMachineCountRange:{
  name:'${virtualMachineName}${i+1}'
  location:location
  tags:{
    DisplayName:'VirtualMachine'
  }
  properties:{
    availabilitySet:{
      id:avset.id
    }
    proximityPlacementGroup:{
      id:ppgrp.id
    }
    diagnosticsProfile:{
      bootDiagnostics:{
        enabled:true
        storageUri:storageUri
      }
    }
    hardwareProfile:{
      vmSize:vmSize
    }
    licenseType:licenseType
    networkProfile:{
      networkInterfaces:[
        {
          id:resourceId('Microsoft.network/NetworkInterfaces','${virtualMachineName}${i+1}${networkInterfaceNameSuffix}')
        }
      ]
    }
    osProfile:{
      adminUsername:adminUsername
      adminPassword:adminPassword
      computerName:'${virtualMachineName}${i+1}'
      allowExtensionOperations:true
      windowsConfiguration:{
        provisionVMAgent: true
        enableAutomaticUpdates:true
        timeZone:'GMT Standard Time'
        winRM:{
          listeners:[
            {
              certificateUrl:certificateUrl
              protocol:'Https'
            }
          ]
        }
      }
      secrets:[
        {
          sourceVault:{
            id:vaultId
          }
          vaultCertificates:[
            {
              certificateStore:'My'
              certificateUrl:certificateUrl
            }
          ]
        }
      ]
    }
    storageProfile:{
      dataDisks:[
        {
          lun: 0
          createOption:'Empty'
          caching:'ReadWrite'
          diskSizeGB:diskSizeGB
          managedDisk:{
            storageAccountType:storageAccountType
          }
          name:'${virtualMachineName}{i+1}_datadisk'
        }
      ]
      imageReference:{
        offer:offer
        publisher:publisher
        sku:sku
        version:'Latest'
      }
      osDisk:{
        createOption: 'FromImage'
        caching:'ReadWrite'
        name:'${virtualMachineName}${i+1}'
         managedDisk:{
           storageAccountType:storageAccountType
         }
         osType:'Windows'
      }
    }
    scheduledEventsProfile:{
      terminateNotificationProfile:{
        enable:true
        notBeforeTimeout:'PT5M'
      }
    }
  }
  identity:{
    type:'SystemAssigned'
  }
}]
resource virtualMachineExtensions 'Microsoft.Compute/virtualMachines/extensions@2021-04-01' =[for i in virtualMachineCountRange: {
  name:'${virtualMachineName}${i+1}/config-app'
  location:location
  properties:{
    publisher:'Microsft.Compute'
    type:'CustomScriptExtension'
    typeHandlerVersion:'1.10'
    autoUpgradeMinorVersion:true
    settings:{
      fileUris:[
        virtualMachineExtensionCustomScriptUri
      ]
      commandToExecute:'powerShell -ExecutionPolicy ByPass -file ./${last(split(virtualMachineExtensionCustomScriptUri,'/'))}'
    }
  }

}]
