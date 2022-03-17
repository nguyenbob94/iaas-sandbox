# If you are new to Terraform please read this to understand how it works

## Using Terraform CLI

Before you can even use Terraform CLI, it needs to authenticate with an Azure account to know where its resources will deploy to. Details of the provider such as tenant ID, client ID and secret, subscription ID are required to be passed before `terraform plan` and `apply` can be used. This is achieved by passing environment variables on your computer which represents those values through to Terraform. Alternatively the parameters can also be predefined with Terraform cloud. 

#### Instructions for creating Azure environment variables for TF
https://learn.hashicorp.com/tutorials/terraform/azure-build

#### Instructions for setting up Terraform cloud for Azure environment
https://learn.hashicorp.com/tutorials/terraform/cloud-sign-up?in=terraform/cloud-get-started
