targetScope = 'subscription'

param defaultLabel string = 'mssqllab'

// ResourceGroup params. Left blank intentionally as default details are passed through via Powershell Script
param rgName string
param location string

param vnetAddressPrefix string = '10.0.0.0/20'
param subnetAddressPrefix string = '10.0.0.0/24'
param pubIPName string = 'pubIP-${defaultLabel}'

// VM Detail params. Left blank intentionally as default details are passed through via Powershell Script
param vmHostName string 
param vmAdminUser string

@minLength(8)
@secure()
param vmAdminPassword string

var vNetName = 'vnet-${defaultLabel}'
//var subnetName = 'subnet-${defaultLabel}'
var nicName = 'nic-${defaultLabel}'
var nsgName = 'nsg-${defaultLabel}'
var nsgRuleName = 'AllowInboundServices'

resource rG 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
}

module networkModules './modules/network.bicep' = {
  name: 'deployNetworkModules'
  scope: rG
  params: {
    location: location
    vNetName: vNetName
    nsgName: nsgName
    nsgRuleName: nsgRuleName
    nicName: nicName
    pubIPName: pubIPName
    vnetAddressPrefix: vnetAddressPrefix
    subnetAddressPrefix: subnetAddressPrefix
  }
}

module computeModules './modules/compute.bicep' = {
  name: 'deployComputeModules'
  scope: rG
  params: {
    vmHostName: vmHostName
    location: location
    vmAdminUser: vmAdminUser
    vmAdminPassword: vmAdminPassword
    nicid: networkModules.outputs.nicIDForVMModule
  }
}

output publicIPAddressOutput string = networkModules.outputs.publicIPAddressOutput
