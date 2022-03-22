targetScope =  'subscription'

// Default params
param defaultCallSign string = 'VnetPeeringDemo'
param location string = 'AustraliaEast'

// Default variables
var rgname = 'rg-${defaultCallSign}'

//vnet variables. Contains details for a set of vnets to be used in a loop
var arrayofVnetAndSubnets = [
  {
    name: 'vnet-JumpNet'
    vNetAddressPrefix: '10.0.0.0/24'
    subnetAddressPrefix: '10.0.0.0/27'
  }
  {
    name: 'vnet-Infra'
    vNetAddressPrefix: '10.1.0.0/20'
    subnetAddressPrefix: '10.1.0.0/24'
  }
]

resource rGDefault 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgname
  location: location
}

module vNetSubnetModule 'modules/network/vnetsubnets.bicep' = [for vnet in arrayofVnetAndSubnets: {
  name: 'deploy-${vnet.name}'
  scope: rGDefault
  params: {
    vNetName: vnet.name
    location: location
    vNetAddressPrefix: vnet.vNetAddressPrefix
    subnetAddressPrefix: vnet.subnetAddressPrefix
  }
}]

