// define where to deploy the resource of this bicep file (Eg, ManagementGroup, ResourceGroup, Subscription, Tenant)
targetScope = <scopename>

// The decorator is used to define the conditions for the parameter. (Eg, char size, range)
@minLength(3)
@maxLength(11)
// Parameters are used to pass a value through to a resource to define its attributes for deployment  
// Default values are optional
// If a parameter is left blank, it can be passed on through the Powershell cmdbet NewAZResource* -parametername <value>
param <parameter-name> <parameter-data-type> = <default-value>

// Varaibles are used to to represent an expression into a string. They work with functions to create a unique string
var <variable-name> = <variable-value>
//Examples
var uniqueId = uniqueString(resourceGroup().id, deployment().name)

//Take only the 5 characters of the UniqueID variable
var uniqueIdShort = take(uniqueId,5)

//Conbining variables with strings
var combinedString = '${UniqueId}Somerandomstring'

// For a list of resources, check https://docs.microsoft.com/en-us/azure/templates/
// symbolic name only accepts alphabetical characters
resource <resource-symbolic-name> '<resource-type>@<api-version>' = {
  <resource-properties>
}

// Modules are used to call a resource from another existing bicep file. Use this for reusuability 
module <module-symbolic-name> '<path-to-file>' = {
  name: '<linked-deployment-name>'
  params: {
    <parameter-names-and-values>
  }
}

// Outputs.. Again nothing much to say here. The function name says it
output <output-name> <output-data-type> = <output-value>
