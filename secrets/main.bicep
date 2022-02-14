module secrets 'secrets.bicep' = {
  name: 'deploysecrets'
  params: {
    secretname:''
    secretvalue:''//specify secrets value
  }
}
output secretName string = secrets.outputs.name
