module stga 'storage.bicep' = {
  name: 'deploystorage'
  params: {
    publicIpAddress: '62.31.74.157'
  }
}
output name string = stga.outputs.name
output id string = stga.outputs.id
