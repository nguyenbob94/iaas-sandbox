// Global params
param vNetName string
param location string
param vNetAddressPrefix string
param subnetAddressPrefix string

// Nonclemature for subnet resource
var vnetID = uniqueString(resourceId('Microsoft.Network/VirtualNetworks', vNetName))
var subnetname = 'subnet-${vnetID}'

resource vNet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vNetName 
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vNetAddressPrefix
      ]
    }
    subnets: [
      {
        name: subnetname
        properties: {
          addressPrefix: subnetAddressPrefix
        }
      }
    ]
  }
}
