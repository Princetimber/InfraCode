param location string = resourceGroup().location
module natgateways 'natgateway.bicep' = {
  name:'natgatewaydeploy'
  params:{
    location:location
    natgatewayNamesuffix: 'natgateway'
    pubIpNameSuffix: 'pubip'
  }
}
output name string = natgateways.outputs.natgatewayname
output id string = natgateways.outputs.natgatewayId
