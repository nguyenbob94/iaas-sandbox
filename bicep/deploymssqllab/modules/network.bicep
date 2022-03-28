param location string
param vNetName string

param nsgName string
param nicName string
param nsgRuleName string
param pubIPName string
param vnetAddressPrefix string
param subnetAddressPrefix string

// So apparently if you want to get a resource ID of a resource, you reference the name (label of the resource)
var shortenedVnetName = uniqueString(resourceId('Microsoft.Network/VirtualNetworks', vNetName))
var subnetName = 'subnet-${shortenedVnetName}'
// And if you reference properties, you reference the symbolic name of the resource. What..?
var vnetSubnetID = '${vNet.id}/subnets/${subnetName}'

resource vNet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vNetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetAddressPrefix
        }
      }
    ]
  }  
}

resource pubIP 'Microsoft.Network/publicIPAddresses@2021-05-01' = {
  name: pubIPName
  location: location
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
  }
  sku: {
    name: 'Basic'
  }
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [
      {
        name: nsgRuleName
        properties: { 
          priority: 1337
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          destinationPortRanges: [
            '3389'
            '1433'
            '443'
            '5671-5672'
            //'5672'
            '9350-9354'
            //'9351'
            //'9352'
            //'9353'
            //'9354'
          ]
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipConfig'
        properties: {
          publicIPAddress: {
            id: pubIP.id
          }
          subnet: {
            id: vnetSubnetID
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: nsg.id
    }
  }
}

//Output nic id to pass onto vm module
output nicIDForVMModule string = nic.id

//Output public IP Address of VM
output publicIPAddressOutput string = pubIP.properties.ipAddress
