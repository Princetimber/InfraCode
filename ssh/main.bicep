param location string = resourceGroup().location
module ssh 'sshkey.bicep'= {
  name: 'deploy-sshkey'
  params: {
    location: location
    name: 'MySecureKey'
  }
}
