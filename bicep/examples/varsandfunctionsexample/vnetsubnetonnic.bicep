//This is an example on how to reference a resource that has been created under another resource.
//An example use case would to reference a subnet created under the vnet resource on a nic.

targetScope = 'resourceGroup'

// Default params
param defaultCallsign string = 'SimpleDeploy'
param location string = 'AustraliaEast'
param vnetPrefix string = '10.1.0.0/16'
param subnetPrefix string = '10.1.0.0/24'

var vnetName = 'vnet-${defaultCallsign}'
var subnetname = 'subnet-${defaultCallsign}'
var nicname = 'nic-${defaultCallsign}'

// Reference to the subnet created in the vnet resource. To be used on nic
var subnetref = '${vnet.id}/subnets/${subnetname}'


resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetPrefix
      ]
    }
    subnets: [
      {
        name: subnetname
        properties: {
        addressPrefix: subnetPrefix
        }
      }
    ]
  }
}

resource nicSimpleDeploy 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: nicname
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig01'
        properties: {
          subnet: {
            id: subnetref
            // vnet.properties.subnets[0].id // also works too. Remember to use index if there is an array
          }
        }
      }
    ] 
  }
}
