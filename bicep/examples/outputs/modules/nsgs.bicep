param arrayNsgs array

resource nsgs 'Microsoft.Network/networkSecurityGroups@2021-05-01' = [for array in arrayNsgs: {
  name: array.name
  location: array.location
  properties: {
    securityRules: array.rules
  }
}]

output nsgsInArray array = [for (id, i) in arrayNsgs: {
  resourceId: nsgs[i].id
  info: nsgs[i].properties.securityRules
}]
