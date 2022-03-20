targetScope = 'resourceGroup'

// Use params where possible. This helps declare and reference variables
// Global variables
param DefaultName string = 'SimpleDeploy'
param Location string = 'AustraliaEast'
param VnetPrefix string = '10.1.0.0/16'
param SubnetPrefix string = '10.1.0.0/24'
param VMName string = 'JUMPY01'

//Credentials params for VM. Required to be manually inputed
param VMUsername string

@minLength(8)
@secure()
param VMPassword string


// Always use variables when possible. It helps with referencing resource ids
var vnetname = 'vnet-${DefaultName}'
var subnetname = 'subnet-${DefaultName}'
var pubipname = 'pubip-${DefaultName}'
var intname = 'int-${DefaultName}'
var nsgname = 'nsg-${DefaultName}'

// References
// When referencing resources to a variable, use the resource symbolic name
var subnetref = '${vnetSimpleDeploy.id}/subnets/${subnetname}'

resource pubIP 'Microsoft.Network/publicIPAddresses@2021-05-01' = {
  name: pubipname 
  location: Location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    publicIPAddressVersion: 'IPv4'
  }
  sku: {
    name: 'Basic'
  }
}

resource vnetSimpleDeploy 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: vnetname
  location: Location
  properties: {
    addressSpace: {
      addressPrefixes: [
        VnetPrefix
      ]
    }
    subnets: [
      {
        name: subnetname
        properties: {
        addressPrefix: SubnetPrefix
        }
      }
    ]
  }
}

resource nsgSimpleDeploy 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: nsgname
  location: Location
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
  name: intname
  location: Location
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
  name: VMName
  location: Location
  properties: {
    osProfile: {
      computerName: VMName
      adminUsername: VMUsername 
      adminPassword: VMPassword
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
