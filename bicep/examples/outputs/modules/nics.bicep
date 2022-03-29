param arrayNics array

resource nic 'Microsoft.Network/networkInterfaces@2021-05-01' = [for array in arrayNics: {
  name: array.name
  location: array.location
  properties: {
    ipConfigurations: array.ipconfig
  }
}]
