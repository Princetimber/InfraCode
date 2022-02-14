module stga 'storage.bicep' = {
  name: 'deploystorage'
  params: {
    namesuffix:''
    publicIpAddress: ''
  }
}
output name string = stga.outputs.name
output id string = stga.outputs.id
