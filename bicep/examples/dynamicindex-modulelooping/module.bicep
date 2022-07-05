// For a module subjected to looping. There should be no hard coded loops here. All the looping are all done within the parent module (main.bicep)
param location string
param vnetSubnetId string

//Resource names for looping mechanism from main.bicep
//param resourceArray array
param pubIPName string
param nicName string
param ifConfigName string


resource pubIP 'Microsoft.Network/publicIPAddresses@2021-08-01' = {
  name: pubIPName
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2021-08-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: ifConfigName
        properties: {
          publicIPAddress: {
            id: pubIP.id
          }
          subnet: {
            id: vnetSubnetId
          }
        }
      }
    ]
  }
}
