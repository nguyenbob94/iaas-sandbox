// Global params
param nsgName string 
param location string 

// Rules param
param nsgRuleName string
param nsgRuleDescription string
param nsgRulePriority int
param nsgRuleDirection string
param nsgRuleAccess string
param nsgRuleProtocol string
param nsgRuleDestPortRange string 
param nsgRuleSourceAddressPref array

resource nsg 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: [
      {
        name: nsgRuleName
        properties: {
          description: nsgRuleDescription
          priority: nsgRulePriority
          direction: nsgRuleDirection
          access: nsgRuleAccess
          protocol: nsgRuleProtocol
          sourcePortRange: '*'
          destinationPortRange: nsgRuleDestPortRange
          sourceAddressPrefixes: nsgRuleSourceAddressPref
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}
        

