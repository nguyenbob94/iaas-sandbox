param location string
param vnetPrefixes string
param vnetName string

resource vNet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetPrefixes
      ]
    }
  }
}
