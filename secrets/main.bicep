module secrets 'secrets.bicep' = {
  name: 'deploysecrets'
  params: {
    secretvalue:''//specify secrets value
  }
}
output secretName string = secrets.outputs.name
