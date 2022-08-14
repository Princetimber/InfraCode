param location string = resourceGroup().location
module stga 'storage.bicep' = {
  name: 'deploystorage'
  params: {
    namesuffix:''
    publicIpAddress: ''
    location:location
  }
}
output name string = stga.outputs.name
output id string = stga.outputs.id
