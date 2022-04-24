targetScope =  'resourceGroup'

param location string

// General VM params
@secure()
param vmPassword string
param vmUsername string
param vmName string

//Image Reference params
param vmPublisher string = 'readymind'
param vmOffer string = 'ubuntults20_docker'
param vmSku string = 'docker_ubuntu20lts1'



var vnetProperties = {
  addressSpace: {
    addressPrefixes: [
      '10.69.0.0/16'
    ]
  }
  subnets: [
    {
      name: 'buildstuffSubnet'
      properties: {
        addressPrefix: '10.69.0.0/24'
        networkSecurityGroup: {
          id: nsg.id
        }
      }
    }
  ]
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: 'nsg-buildstuff'
  location: location
  properties: {
    securityRules: [
      {
        name: 'default-nsgrule'
        properties: {
          access: 'Allow'
          description: 'Default rule for http, https and ssh'
          destinationAddressPrefix: '10.69.0.0/24'
          destinationPortRanges: [
            '22'
            '80'
            '443'
          ]
          direction: 'Inbound'
          priority: 1337
          protocol: 'Tcp'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
        }
      }
      {
        name: 'allow-ping'
        properties: {
          access: 'Allow'
          description: 'Allows ping to the nic'
          destinationAddressPrefix: 'VirtualNetwork'
          destinationPortRange: '*'
          direction: 'Inbound'
          priority: 1338
          protocol: 'Icmp'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
        }
      }
    ]
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: 'vnet-buildstuff'
  location: location
  properties: vnetProperties
}

resource pubIP 'Microsoft.Network/publicIPAddresses@2021-05-01' = {
  name: 'pubIPBuildStuff'
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: 'nic-buildstuff'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig01'
        properties: {
          publicIPAddress: {
            id: pubIP.id
          }
          subnet: {
            id: vnet.properties.subnets[0].id
          }
        }
      }
    ]
  }
}

resource linuxVM 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: vmName
  location: location
  plan: {
    // Details can be found under the description of the plan in Azure Marketplace web page
    name: 'Docker_Ubuntu20LTS1'
    publisher: 'readymind'
    // Product ID is the same as the offer ID in imageReference
    product: vmOffer
  }
  properties: {
    //priority: 'Spot'
    //evictionPolicy: 'Deallocate'
    //billingProfile: {
    //    maxPrice: -1
    //}
    hardwareProfile: {
      vmSize: 'Standard_DS3_v2'
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
      imageReference: {
        publisher: vmPublisher
        offer: vmOffer
        sku: vmSku
        //version: 'latest'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
    osProfile: {
      computerName: vmName
      adminUsername: vmUsername
      adminPassword: vmPassword
    }
  }
}

output vmPublicIPAddress string = pubIP.properties.ipAddress
output vmHostName string = linuxVM.properties.osProfile.computerName
output vmUserName string = linuxVM.properties.osProfile.adminUsername
