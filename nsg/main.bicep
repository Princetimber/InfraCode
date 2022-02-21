param location string = resourceGroup().location
module nsgdeploy 'nsg.bicep' = {
  name: 'nsgdeploy'
  params: {
    location: location
    destinationAddressPrefix:'63.31.74.157'//specify PublicIpAddress
    sourceAddressPrefixes:[
      '10.0.1.0/24'
      '10.0.2.0/24'
      '10.0.3.0/24'
      '50.101.100.0/24'
    ]// Specify Private IpAddress space on Local network using CIDR notation
  }
}
