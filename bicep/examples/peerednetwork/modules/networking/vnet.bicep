resource vNet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vnet
  location: Location
  properties: {
    addressSpace: {
      addressPrefixes: [
        VnetPrefixes
      ]
    }
  }
}
