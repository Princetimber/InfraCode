module secrets 'secrets.bicep' = {
  name: 'deploysecrets'
  params: {
    secretname:''
    secretvalue:''//specify secrets value
    exp:012//execute unix time for actual value
    nbf:013//execute unixtime script for actual value
  }
}
output secretName string = secrets.outputs.name
