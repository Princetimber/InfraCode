param vaultnamesuffix string = 'keystore'
param location string = resourceGroup().location
var vaultname = '${toLower(resourceGroup().name)}${vaultnamesuffix}'
resource vault 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = {
  name: vaultname
}
module linux 'Linux-vm.bicep' = {
  name: 'linux'
  params: {
    location: location
    adminpass: vault.getSecret('sshkeys') // TODO: change this to ssh key in keyvault
    adminuser:''// TODO: add admin user
    privateIpAddress: ''// TODO: add private ip
    sku:'18_04-lts-gen2' // TODO: add sku e.g. '18_04-lts-gen2'
    vmname:''// TODO: add vm name
  }
}
output username string = linux.outputs.username
output sshcommand string =  linux.outputs.sshcommand
