# What is Bicep

Bicep is nothing more than a translative service in a form of a DSL, used to directly translate to ARM templates and to provide a syntax that is clean to work on.

Essentially it provides capabilities to create ARM Templates and makes it seem like you're writing in IaC Terraform. In other words, its designed to minic how Iac would function and make it less complex.

## Prerequesites
- Powershell 7: https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.2#msi
- Bicep CLI: This can be downloaded via chocolatey https://community.chocolatey.org/packages/bicep
- Azure CLI or AZ module for Powershell (5.6+)
- Bicep extension for Vscode

#### Verify Bicep is installed

On Powershell, run the following command. A response should output if installed properly

`bicep --version`

`Bicep CLI version 0.4.1318 (ee0d808f35)`

## File format

A bicep template is denoted with a `.bicep` extension

## Levels of deployments

Using Bicep, you can deploy resources into the following levels

- Resource Group
- Subscription
- Management Group
- Tenant

The levels of deployment are used to declare what type of deployment to use for placing resources. 
Eg, you can deploy to an exusting resource group if you specify resouce groups. Alternatively, you may deploy a resource group by scoping the Subscription.

## Resources

The full list of resources that can be used in Bicep can be found a referenced here https://docs.microsoft.com/en-us/azure/templates/

## Data types

| Type          | Example                                                                                                 |
|---------------|---------------------------------------------------------------------------------------------------------|
| String        | 'StorageV2'                                                                                             |
| Integer       | 100                                                                                                     |
| Booleans      | true or false                                                                                           |
| Secure String | @secure()                                                                                               |
| Array         | [    [   1    'one'   2    'two'   3    'three' ]    ]                                                  |
| Objects       | {   name: 'test'   id: 1234   sku: {          name: 'Standard_LRS'          tier: 'Standard'        } } |

## Parameters

Provides portability when using a template, this is handy in big deployment templates

#### Parameter decorators

Defines the property and the characteristics of a parameter
`
@allowed()
@description()
@metadata()
@minLength()
@maxLength()
@minValue()
@maxValue()
@secure()
`

## Variables and functions

Difference between variables and parameters

- Parameters: Can work outside the bicep template
- Variables: Only work locally inside the template

Variables themselves are useless but they become useful when used with functions

For a list of functions, check https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-functions

#### Unique characters
Unique characters are strings based on from subscription names, resource groups. It is not random.



