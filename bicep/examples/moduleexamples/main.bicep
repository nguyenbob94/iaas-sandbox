targetScope = 'subscription'

param DefaultName string = 'ModulesDemo'
param RGName string = 'rg-modulesdemo'
param Location string = 'AustraliaEast'
param VnetPrefix string = '10.0.0.0/16'

var vnetname = 'vnet-${DefaultName}'

resource rG 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: RGName
  location: Location
}

module moduleVnet './modules/networking/vnet.bicep' = {
  name: 'vNetDeploy'
  scope: rG
  params: {
    vnetName: vnetname
    vnetPrefixes: VnetPrefix
    location: Location
  }
}
