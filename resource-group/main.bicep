targetScope = 'subscription'
param location string = deployment().location
module rg 'resourcegrp.bicep' = {
  name: 'deployresourcegroup'
  params: {
    name:'labuksrg'
    location: location
  }
  scope:subscription()
}
output rgname string = rg.outputs.rgname
