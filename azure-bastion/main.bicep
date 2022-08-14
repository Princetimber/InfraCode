param Location string = resourceGroup().location
module bastion 'azure-bastion.bicep' = {
  name: 'azure_bastion_deploy'
  params: {
    location: Location
  }
}
