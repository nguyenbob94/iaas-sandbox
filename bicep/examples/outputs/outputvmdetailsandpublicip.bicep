targetScope = 'resourceGroup'

param location string = 'AustraliaEast'

@description('Password for the Virtual Machine.')
@secure()
param adminPassword string

param adminuser string = 'adminuser'

resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: 'vnet-outputtest'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'subnet-outputtest'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}

resource pubIP 'Microsoft.Network/publicIPAddresses@2021-05-01' = {
  name: 'pubIP-outputtest'
  location: location
  sku: {
    name: 'Basic'
  }
  properties : {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: 'nic-outputtest'
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

resource vm 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: 'testvm01'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B1s'
    }
    osProfile: {
      computerName: 'testvm01'
      adminUsername: adminuser
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}

// Outputs per resource
output publicIPofVMOutput string = pubIP.properties.ipAddress
output vmHostnameOutput string = vm.properties.osProfile.computerName
output vmAdminUsername string = vm.properties.osProfile.adminUsername

// Concated outputs in objects
output objectOutput object = {
  'publicIP': pubIP.properties.ipAddress
  'vmHostnameOutput': vm.properties.osProfile.computerName
  'vmAdminUsername': vm.properties.osProfile.adminUsername
}




