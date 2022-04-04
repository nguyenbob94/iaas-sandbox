param vmUsername string
@secure()
param vmPassword string
param vmName string
param location string
param runCommandName string
// Here is the secret formula
var scriptContent = loadTextContent('./path/to/script.sh')

resource linuxVM 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: vmName
  location: location
  properties: {
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
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '19.04'
        version: 'latest'
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

// Don't bother, this will only work when it decides to.
// 90% of the time it doesnt deploy, 40% of the time it will deploy and miss out commands. 10% of the time it will actually work
resource runCommandVM 'Microsoft.Compute/virtualMachines/runCommands@2021-11-01' = {
  name: runCommandName
  location: location
  parent: linuxVM
  properties: {
    asyncExecution: false
    parameters: [
      {
        // bash scripts do not require name. This is fine
        value: vmUsername
      }
    ]
    source: {
      commandId: 'RunShellScript'
      script: scriptContent
    }
  }
}
