//Param for array of securityRules
param ruleArray array

resource nsg 'Microsoft.Network/networkSecurityGroups@2021-05-01' = [for array in ruleArray: {
  name: array.name
  location: array.location
  properties: {
    securityRules: array.rules
  }
}]
