targetScope = 'subscription'

param RGName string = 'rg-vnetpeeringdemo'
param Location string = 'Location'

resource rG 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: RGName
  location: Location
}

module moduleVnet './modules/networking/vnet.bicep'  = {
  name: vNet
  scope: RGName
}
