param vNetCallsign string
param location string
param vnetAddressPrefix string

resource vNet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vNetCallsign
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
  }
}
