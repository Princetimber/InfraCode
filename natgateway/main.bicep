module natgateways 'natgateway.bicep' = {
  name:'natgatewaydeploy'
}
output name string = natgateways.outputs.natgatewayname
output id string = natgateways.outputs.natgatewayId
