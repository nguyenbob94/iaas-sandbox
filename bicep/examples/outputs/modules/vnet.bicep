param location string
param arrayOfSubnetsForVnet array

resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: 'vnet-outputtest'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [ for subnet in arrayOfSubnetsForVnet: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.subnetAddressPrefix
        networkSecurityGroup: {
          id: subnet.nsgid
        }
      }
    }]
  }
}

output subnetsInVnetArray array = [for (id, i) in arrayOfSubnetsForVnet: {
  resourceId: vnet.properties.subnets[i].id
  address: vnet.properties.subnets[i].properties.addressPrefix
}]




