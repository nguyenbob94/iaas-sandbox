targetScope = 'subscription'

param defaultCallsign string = 'ModulesDemo'
param rGName string = 'rg-modulesdemo'
param location string = 'AustraliaEast'
param vnetPrefix string = '10.0.0.0/16'

var vnetCallsign = 'vnet-${defaultCallsign}'

resource rG 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rGName
  location: location
}

module moduleVnet './modules/networking/vnet.bicep' = {
  name: 'vNetDeploy'
  scope: rG
  params: {
    vnetName: vnetCallsign
    vnetPrefixes: vnetPrefix
    location: location
  }
}
