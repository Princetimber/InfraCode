module nsgdeploy 'nsg.bicep' = {
  name: 'nsgdeploy'
  params: {
    destinationAddressPrefix:''//specify PublicIpAddress
    sourceAddressPrefixes:[

    ]// Specify Private IpAddress space on Local network
  }
}
