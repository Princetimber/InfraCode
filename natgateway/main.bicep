module natgateways 'natgateway.bicep' = {
  name:'natgatewaydeploy'
  params:{
    natgatewayNamesuffix: 'natgateway'
    pubIpNameSuffix: 'pubip'
  }
}
output name string = natgateways.outputs.natgatewayname
output id string = natgateways.outputs.natgatewayId
