param location string
param nicid string
param vmHostName string 
param vmAdminUser string
param vmAdminPassword 




resource vm 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: vmHostName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DS2_v2'
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
      imageReference: {
        publisher: 'microsoftsqlserver'
        offer: 'sql2019-ws2019'
        sku: 'sqldev-gen2'
        version: 'latest'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nicid
        }
      ]
    }
    osProfile: {
      computerName: vmHostName
      adminUsername: vmAdminUser
      adminPassword: vmAdminPassword
    }
  }
}


Standard_DS2_v2

publisher microsoftsqlserver
offer sql2019-ws2019
sku  sqldev-gen2    
