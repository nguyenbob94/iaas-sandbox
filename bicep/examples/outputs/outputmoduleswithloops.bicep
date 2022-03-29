targetScope = 'subscription'

param rgName string = 'rg-outputwithmodules'
param location string = 'AustraliaEast'

var arrayOfSubnetsForVnet = [
{
  name: 'subnet01'
  subnetAddressPrefix: '10.0.1.0/24'
  nsgid: nsgModule.outputs.nsgsInArray[0].resourceId
}
{
  name: 'subnet02'
  subnetAddressPrefix: '10.0.2.0/24'
  nsgid: nsgModule.outputs.nsgsInArray[1].resourceId
}
{
  name: 'subnet03'
  subnetAddressPrefix: '10.0.3.0/24'
  nsgid: nsgModule.outputs.nsgsInArray[2].resourceId
}
]

var arrayNsgs = [
{
  name: 'AllowRDPFromExt01'
  location: location
  rules: [
    {
      name: 'rule01'
      properties: {
        access: 'Allow'
        destinationAddressPrefix: '*'
        destinationPortRange: '3389'
        direction: 'Inbound'
        priority: 1337
        protocol: 'Tcp'
        sourceAddressPrefix: '*'
        sourcePortRange: '*'
      }
    }
  ]
}
{
  name: 'AllowRDPFromExt02'
  location: location
  rules: [
    {
      name: 'rule01'
      properties: {
        access: 'Allow'
        destinationAddressPrefix: '*'
        destinationPortRange: '3389'
        direction: 'Inbound'
        priority: 1378
        protocol: 'Tcp'
        sourceAddressPrefix: '*'
        sourcePortRange: '*'
      }
    }
  ]
}
{
  name: 'AllowRDPFromExt03'
  location: location
  rules: [
    {
      name: 'rule01'
      properties: {
        access: 'Allow'
        destinationAddressPrefix: '*'
        destinationPortRanges: [
          '3389'
          '22'
          '1499'
        ]
        direction: 'Inbound'
        priority: 1999
        protocol: 'Tcp'
        sourceAddressPrefix: '*'
        sourcePortRange: '*'
      }
    }
  ]
}
]

var arrayPubIP = [
{
  name: 'pubIP01'
  location: location
  skuname: 'Standard'
  publicIPAddressVersion: 'IPv4'
  publicIPAllocationMethod: 'Static'
}
{
  name: 'pubIP02'
  location: location
  skuname: 'Standard'
  publicIPAddressVersion: 'IPv4'
  publicIPAllocationMethod: 'Static'
}
{
  name: 'pubIP03'
  location: location
  skuname: 'Standard'
  publicIPAddressVersion: 'IPv4'
  publicIPAllocationMethod: 'Static'
}
]

var arrayNics = [
{
  name: 'nic01'
  location: location
  ipconfig: [
    {
      name: 'ipconfig01'
      properties: {
        publicIPAddress: {
          id: pubIPModule.outputs.pubIPsInArray[0].resourceId
        }
        subnet: {
          id: vnetModule.outputs.subnetsInVnetArray[0].resourceId
        }
      }
    }
  ]
}
{
  name: 'nic02'
  location: location
  ipconfig: [
    {
      name: 'ipconfig02'
      properties: {
        publicIPAddress: {
          id: pubIPModule.outputs.pubIPsInArray[1].resourceId
        }
        subnet: {
          id: vnetModule.outputs.subnetsInVnetArray[1].resourceId
        }
      }
    }
  ]
}
{
  name: 'nic03'
  location: location
  ipconfig: [
    {
      name: 'ipconfig01'
      properties: {
        publicIPAddress: {
          id: pubIPModule.outputs.pubIPsInArray[2].resourceId
        }
        subnet: {
          id: vnetModule.outputs.subnetsInVnetArray[2].resourceId
        }
      }
    }
  ]
}
]

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
}

module vnetModule './modules/vnet.bicep' = {
  name: 'deployVnetModule'
  scope: rg
  params: {
    location: location
    arrayOfSubnetsForVnet: arrayOfSubnetsForVnet 
  }
}

module nsgModule './modules/nsgs.bicep' = {
  name: 'deployNSGModule'
  scope: rg
  params: {
    arrayNsgs: arrayNsgs
  }
}

module pubIPModule './modules/pubIP.bicep' = {
  name: 'deployPubIPModule'
  scope: rg
  params: {
    arrayPubIP: arrayPubIP
  }
}

module nicModule './modules/nics.bicep' = {
  name: 'deployNicModule'
  scope: rg
  params: {
    arrayNics: arrayNics
  }
}

// Spit out object outputs
output resource01output object = {
  subnet: vnetModule.outputs.subnetsInVnetArray[0].address
  publicipaddress: pubIPModule.outputs.pubIPsInArray[0].address
  nsgs: nsgModule.outputs.nsgsInArray[0].info
}

output resource02output object = {
  subnet: vnetModule.outputs.subnetsInVnetArray[1].address
  publicipaddress: pubIPModule.outputs.pubIPsInArray[1].address
  nsgs: nsgModule.outputs.nsgsInArray[1].info
}

output resource03output object = {
  subnet: vnetModule.outputs.subnetsInVnetArray[2].address
  publicipaddress: pubIPModule.outputs.pubIPsInArray[2].address
  nsgs: nsgModule.outputs.nsgsInArray[2].info
}

//Experimental - Spit out an array of outputs
output arrayOutput array = [
  {
    subnet: vnetModule.outputs.subnetsInVnetArray[0].address
    publicipaddress: pubIPModule.outputs.pubIPsInArray[0].address
    nsgs: nsgModule.outputs.nsgsInArray[0].info
  }
  {
    subnet: vnetModule.outputs.subnetsInVnetArray[1].address
    publicipaddress: pubIPModule.outputs.pubIPsInArray[1].address
    nsgs: nsgModule.outputs.nsgsInArray[1].info
  }
  {
    subnet: vnetModule.outputs.subnetsInVnetArray[2].address
    publicipaddress: pubIPModule.outputs.pubIPsInArray[2].address
    nsgs: nsgModule.outputs.nsgsInArray[2].info
  }
]
