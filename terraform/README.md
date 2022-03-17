# If you are new to Terraform please read this to understand how it works

## Using Terraform CLI

Before you can even use Terraform CLI, it needs to authenticate with an Azure account to know where its resources will deploy to. Details of the provider such as tenant ID, client ID and secret, subscription ID are required to be passed before `terraform plan` and `apply` can be used. This is achieved by passing environment variables on your computer which represents those values through to Terraform. Alternatively the parameters can also be predefined with Terraform cloud. 

#### Instructions for creating Azure environment variables for TF
https://learn.hashicorp.com/tutorials/terraform/azure-build

#### Instructions for setting up Terraform cloud for Azure environment
https://learn.hashicorp.com/tutorials/terraform/cloud-sign-up?in=terraform/cloud-get-started

## Authenticate Azure with Terraform CLI using a Powershell script
The purpose of this script is to prestore the Azure account information into environment variables so that Terraform can call it when deploying resources. This saves the effort of typing out environment variables each time you open a new CLI session.

#### Edit the script
Lines: 3,4,5,6. 

Replace the XXXX values and secret ID with your Azure account details.

#### Example of direct parameter usage
`.\azure-auth-tf.ps1 -ClientID "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" -ClientSecret "clientsectetbsgfbrb;;'32" -SubscriptionID ""xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" -TenantID ""xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"`

Once these environment variables are set, you can then run Terraform to deploy your tf templates.

## Parameters
Parameter      | Detail
-------------  | -------------
ClientID       | Represent the service principal app ID of Terraform on Azure AD 
ClientSecret   | Represent the secret generated key of the service principal app ID of Terraform on Azure AD
SubscriptionID | Represent the subscription ID in Azure where the resources will be deployed to
TenantID       | Represent the Tenant ID of your Azure account (Directory ID)

tl;dr: The script does not run Terraform, it only stores data so that Terraform can be used when run.
