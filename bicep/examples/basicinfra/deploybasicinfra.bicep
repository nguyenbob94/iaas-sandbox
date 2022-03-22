targetScope = 'resourceGroup'

// Use params where possible. This helps declare and reference variables
// Global variables
param defaultCallsign string = 'SimpleDeploy'
param location string = 'AustraliaEast'
param vnetPrefix string = '10.1.0.0/16'
param subnetPrefix string = '10.1.0.0/24'
param vmName string = 'JUMPY01'

//Credentials params for VM. Required to be manually inputed
param vmUsername string

@minLength(8)
@secure()
param vmPassword string


// Always use variables when possible. It helps with referencing resource ids
var vnetcallsign = 'vnet-${defaultCallsign}'
var subnetcallsign = 'subnet-${defaultCallsign}'
var pubipcallsign = 'pubip-${defaultCallsign}'
var intcallsign = 'int-${defaultCallsign}'
var nsgcallsign = 'nsg-${defaultCallsign}'

// References
// When referencing resources to a variable, use the resource symbolic name
var subnetref = '${vnetSimpleDeploy.id}/subnets/${subnetcallsign}'

resource pubIP 'Microsoft.Network/publicIPAddresses@2021-05-01' = {
  name: pubipcallsign
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    publicIPAddressVersion: 'IPv4'
  }
  sku: {
    name: 'Basic'
  }
}

resource vnetSimpleDeploy 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vnetcallsign
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetPrefix
      ]
    }
    subnets: [
      {
        name: subnetcallsign
        properties: {
        addressPrefix: subnetPrefix
        }
      }
    ]
  }
}

resource nsgSimpleDeploy 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: nsgcallsign
  location: location
  properties: {
    securityRules: [
      {
        name: 'Inbound-Rules'
        properties: {
          description: 'Allow whatever'
          priority: 1010
          direction: 'Inbound'
          access:  'Allow'
          protocol: 'Tcp' 
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          // sourcePortRanges: []
          // destinationPortRanges: []
          // sourceAddressPrefixes: []
          // destinationAddressPrefixes: [] 
        }
      }
    ]
  }
}

resource nicSimpleDeploy 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: intcallsign
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig01'
        properties: {
          subnet: {
            // id: '${vnetSimpleDeploy.id}/subnets/${subnetname}'
            id: subnetref
          }
          publicIPAddress: {
            id: pubIP.id
          }
        }
      }
    ]    
    networkSecurityGroup: {
      id: nsgSimpleDeploy.id
    }
  }
}

resource vmJumpy01 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: vmName
  location: location
  properties: {
    osProfile: {
      computerName: vmName
      adminUsername: vmUsername 
      adminPassword: vmPassword
    }
    hardwareProfile: {
      vmSize: 'Standard_B1s'
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nicSimpleDeploy.id
        }
      ]
    }
  }
}
