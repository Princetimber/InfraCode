targetScope = 'subscription'

module rg 'resourcegrp.bicep' = {
  name: 'deployresourcegroup'
  params: {
    name:'labuksrg'
  }
  scope:subscription()
}
output rgname string = rg.outputs.rgname
