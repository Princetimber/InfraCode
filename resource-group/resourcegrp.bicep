targetScope = 'subscription'

@description('specify resource group name')
param name string
param location string = deployment().location


resource resourcegroups 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: name
  location:location
  
}
output rgname string = resourcegroups.name
