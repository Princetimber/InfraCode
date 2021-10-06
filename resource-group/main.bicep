targetScope = 'subscription'

module rg 'resourcegrp.bicep' = {
  name: 'deployresourcegroup'
  params: {
    name:'devlabftsuksrg'
  }
  scope:subscription()
}
output rgname string = rg.outputs.rgname
