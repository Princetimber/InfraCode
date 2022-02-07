param vaultnamesuffix string = 'keyvault'
var vaultname = '${toLower(resourceGroup().name)}${vaultnamesuffix}'
resource vault 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = {
  name: vaultname
}
module linux 'Linux-vm.bicep' = {
  name: 'linux'
  params: {
    adminpass: vault.getSecret('sshKey') // TODO: change this to ssh key in keyvault
    adminuser:''// TODO: add admin user
    privateIpAddress: ''// TODO: add private ip
    sku:'' // TODO: add sku e.g. '18_04-lts-gen2'
    vmname:''// TODO: add vm name
  }
}
output username string = linux.outputs.username
output sshcommand string =  linux.outputs.sshcommand
