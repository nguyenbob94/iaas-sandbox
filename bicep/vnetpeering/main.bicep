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

var arrayofNsgs = [
  {
    nsgName: 'nsg-JumpNet'
    nsgRuleName: 'AllowRDP'
    nsgRuleDescription: 'Allow RDP from external source'
    nsgRulepriority: 1000
    nsgRuleDirection: 'Inbound'
    nsgRuleAccess: 'Allow'
    nsgRuleProtocol: 'tcp'
    nsgRuleDestPortRange: '3389'
    nsgRuleSourceAddressPref: [
      '*'
    ]
  }
  {
    nsgName: 'nsg-Infra'
    nsgRuleName: 'DenyAccess'
    nsgRuleDescription: 'Prevent access elsewhere except for vnet sources'
    nsgRulepriority: 1001
    nsgRuleDirection: 'Inbound'
    nsgRuleAccess: 'Allow'
    nsgRuleProtocol: 'tcp'
    nsgRuleDestPortRange: '3389'
    nsgRuleSourceAddressPref: [
      '10.0.0.0/24'
      '10.1.0.0/20'
    ]
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

module nsgModule 'modules/network/nsg.bicep' = [for nsg in arrayofNsgs: {
  name: 'deploy-${nsg.nsgName}'
  scope: rGDefault
  params: {
    nsgName: nsg.nsgName
    location: location
    nsgRuleName: nsg.nsgRuleName
    nsgRuleDescription: nsg.nsgRuleDescription
    nsgRulePriority: nsg.nsgRulePriority
    nsgRuleDirection: nsg.nsgRuleDirection
    nsgRuleAccess: nsg.nsgruleAccess
    nsgRuleProtocol: nsg.nsgRuleProtocol
    nsgRuleDestPortRange: nsg.nsgRuleDestPortRange
    nsgRuleSourceAddressPref: nsg.nsgRuleSourceAddressPref
  }
}]
