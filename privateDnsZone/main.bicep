module privatednszone 'privatedns.bicep' = {
  name:'deployPrivateDnsZone'
  params:{
    privateDnsZonename:'labukrg.local'//Specify Private DNS Zone name e.g. Contoso.com
    registrationEnabled:true // Specify whether to enable automatic VM registration. Acceptable values are true or false
  }
}
output dnsZoneName string = privatednszone.outputs.dnszonename
