targetScope = 'subscription'

param defaultCallSign string = 'nsgpilot'
param location string = 'AustraliaEast'

var rgname = 'rg-${defaultCallSign}'
param nsgName string = 'nsg-pilot'

var ruleArray = [
  {
    name: 'nsg-JumpNet'
    location: location
    rules: [
      {
        name: 'AllowRDP'
        properties: {
          priority: '2000'
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          destinationPortRange: '3389'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
  {
    name: 'nsg-Infra'
    location: location
    rules: [
      {
        name: 'AllowRDP'
        properties: {
          priority: '2000'
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          destinationPortRange: '3389'
          sourcePortRange: '*'
          sourceAddressPrefix: '10.0.0.0/20'
          destinationAddressPrefix: '*'
        }
      }
      {
        name: 'Jail'
        properties: {
          priority: '2000'
          access: 'Deny'
          direction: 'Outbound'
          protocol: 'Tcp'
          destinationPortRange: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
]

resource rG 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgname
  location: location
}

module nsgModule 'module/nsg.bicep' = {
  name: nsgName
  scope: rG
  params: {
    ruleArray: ruleArray
  }
}
                                                      