module vnet 'virtualnetwork.bicep' = {
  name: 'vnetdeploy'
  params:{
    vnetnameSuffix:'vnet'
    vnetSettings:{
      addressPrefixes:[
        '50.171.100.0/16'
      ]
    }
     subnets:[
       {
         name: 'subnet1'
         addressPrefix: '50.171.101.0/24'
       }
       {
          name: 'subnet2'
          addressPrefix: '50.171.102.0/24'
       }
     ]
  }
}
output vnet string = vnet.outputs.networkname
output Id string = vnet.outputs.networkId
