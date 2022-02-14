param vmname string
param adminuser string
param location string = resourceGroup().location
@secure()
param adminpass string
param sku string
@allowed([
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_LRS'
  'StandardSSD_LRS'
  'StandardSSD_ZRS'
  'UltraSSD_LRS'
])
param storageAccountType string = 'Standard_LRS'
@minValue(100)
@maxValue(1000)
param diskSizeGB int = 100

@description('Specify VirtualMachine size')
@allowed([
  'Standard_D2_v2'
  'Standard_D2_v3'
  'Standard_D2s_v3'
])
param vmSize string = 'Standard_D2s_v3'
param privateIpAddress string
param availabilitySetsNameSuffix string = 'avset'
param proximityPlacementGroupNameSuffix string = 'ppgrp'
param networkInterfacenameSuffix string = 'nic'
param virtualNetworkNameSuffix string = 'vnet'
param storageAccountNameSuffix string = 'stga'
var vmnic = '${vmname}${networkInterfacenameSuffix}'
var vnetname = '${toLower(resourceGroup().name)}${virtualNetworkNameSuffix}'
resource virtualnetworks 'Microsoft.Network/virtualNetworks@2021-05-01' existing = {
  name: vnetname
}
var vnetid = virtualnetworks.id
var subnetId = '${vnetid}/subnets/subnet1'
var storageaccountname = '${uniqueString(resourceGroup().id)}${storageAccountNameSuffix}'
resource storageaccounts 'Microsoft.Storage/storageAccounts@2021-06-01' existing = {
  name: storageaccountname
}
var storageaccountUrl = storageaccounts.properties.primaryEndpoints.blob
var availabilitysetname = '${toLower(resourceGroup().name)}${availabilitySetsNameSuffix}'
resource availabilitysets 'Microsoft.Compute/availabilitySets@2021-07-01' existing = {
  name: availabilitysetname
}
var availabilitysetId = availabilitysets.id
var proximityplacementgroupname = '${toLower(resourceGroup().name)}${proximityPlacementGroupNameSuffix}'
resource proximityplacementgroups 'Microsoft.Compute/proximityPlacementGroups@2021-07-01' existing = {
  name: proximityplacementgroupname
}
var proximityplacementgroupId = proximityplacementgroups.id
resource networkinterfaces 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name:vmnic
  location: location
  tags:{
    DisplayName: 'Network interface'
  }
  properties:{
    ipConfigurations:[
      {
        name:'Ipconfig'
        properties:{
          primary:true
          privateIPAddress:privateIpAddress
          privateIPAddressVersion:'IPv4'
          privateIPAllocationMethod:'Static'
          subnet:{
            id:subnetId
          }
        }
      }
    ]
  }
}
resource virtualmachine 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name:vmname
  location: location
  tags:{
    DisplayName: 'Virtual machine'
  }
  identity:{
    type:'SystemAssigned'
  }
  properties:{
    availabilitySet:{
      id:availabilitysetId
    }
    proximityPlacementGroup:{
      id:proximityplacementgroupId
    }
    hardwareProfile:{
      vmSize:vmSize
    }
    networkProfile:{
      networkInterfaces:[
        {
          id:networkinterfaces.id
        }
      ]
    }
    osProfile:{
      computerName:vmname
      adminUsername:adminuser
      adminPassword:adminpass
      linuxConfiguration:{
        disablePasswordAuthentication:true
        provisionVMAgent:true
        patchSettings:{
          assessmentMode:'ImageDefault'
          patchMode:'ImageDefault'
        }
        ssh:{
          publicKeys:[
            {
              path:'/home/${adminuser}/.ssh/authorized_keys'
              keyData: adminpass
            }
          ]
        }
      }
    }
    storageProfile:{
      osDisk:{
        name:'${vmname}-osdisk'
        caching:'ReadWrite'
        createOption:'FromImage'
        osType:'Linux'
        diskSizeGB:diskSizeGB
        managedDisk:{
          storageAccountType:storageAccountType
        }
      }
      imageReference:{
        publisher:'Canonical'
        offer:'UbuntuServer'
        sku:sku
        version:'latest'
      }
    }
    diagnosticsProfile:{
      bootDiagnostics:{
        enabled:true
        storageUri:storageaccountUrl
      }
    }
    scheduledEventsProfile:{
      terminateNotificationProfile:{
        enable:true
        notBeforeTimeout:'PT5M'
      }
    }
  }
}
output username string = adminuser
output hostname string = privateIpAddress
output sshcommand string = 'ssh ${adminuser}@${privateIpAddress}'
