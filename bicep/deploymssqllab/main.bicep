targetScope = 'subscription'

param defaultLabel string = 'mssqllab'
param location string = 'AustraliaEast'

param vnetAddressPrefix string = '10.0.0.0/20'
param subnetAddressPrefix string = '10.0.0.0/24'
param pubIPName string = 'pubIP-${defaultLabel}'

param vmHostName string = 'mssqlserver01'
param vmAdminUser string = 'vmadminuser'

var rgName = 'rg-${defaultLabel}'
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

module asdafgfafg './modules/compute.bicep' = {
  name: 'deployComputeModules'
  scope: rG
  params: {
    vmHostName: vmHostName
    nicid: networkModules.outputs.nicIDForVMModule

  }

}
