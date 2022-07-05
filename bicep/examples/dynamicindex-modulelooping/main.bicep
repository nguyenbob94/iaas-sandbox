targetScope = 'resourceGroup'

param location string
param instanceCount int = 1

//Resource params
// When looping modules, don't use arrays. Use object for iterations instead.
// If arrays are used, each loop will create an array for each object. Not what we want.
var collection = [ for i in range(0, instanceCount): {
  pubIPName: 'pubIP-0${i}'
  nicName: 'nic-0${i}'
  ifConfigName: 'ifConfig-0${i}'
}]

resource vnet 'Microsoft.Network/virtualNetworks@2021-08-01' = {
  name: 'vnet01'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'subnet01'
        properties: {
          addressPrefix: '10.1.1.0/24'
        }
      }
    ]
  }
}

module deployCluster './module.bicep' = [for (res, i) in collection: {
  //IMPORTANT: When looping a module, the deployment name must be unique per iteration.
  name: '${i}-deployModuleCluster'
  scope: resourceGroup()
  params: {
    location: location
    pubIPName: res.pubIPName
    nicName: res.nicName  
    ifConfigName: res.ifConfigName
    vnetSubnetId: vnet.properties.subnets[0].id
  }
}]
