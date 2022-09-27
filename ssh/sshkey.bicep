param name string
param location string = resourceGroup().location
resource sshkeys 'Microsoft.Compute/sshPublicKeys@2021-07-01' = {
  name: name
  location: location
  tags:{
    DisplayName: 'SSH Key'
  }
  properties:{
    publicKey:''
  }
}
