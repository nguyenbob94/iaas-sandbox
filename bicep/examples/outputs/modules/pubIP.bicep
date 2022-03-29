param arrayPubIP array

resource pubIP 'Microsoft.Network/publicIPAddresses@2021-05-01' = [for array in arrayPubIP: {
  name: array.name
  location: array.location
  sku: {
    name: array.skuname
  }
  properties: {
    publicIPAddressVersion: array.publicIPAddressVersion
    publicIPAllocationMethod: array.publicIPAllocationMethod
  }
}]

output pubIPsInArray array = [for (id, i) in arrayPubIP: {
  resourceId: pubIP[i].id
  address: pubIP[i].properties.ipAddress
}]
