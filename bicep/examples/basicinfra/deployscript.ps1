# Default values can be overwritten
param(
  [string]$RGName = "rg-simpledeploy",
  [string]$VMUsername,
  [string]$VMPassword,
  [string]$VMName,
  [string]$Location,
  [string]$BicepTemplatePath = ".\deploybasicinfra.bicep"
)

# Function for creating a new RG if it doesn't exist
function Create-NewRG
{
  if(!$Location)
  {
    (Get-AZLocation).Location
    $Location = Read-Host "Enter Location param for Resource Group. Type in one of the locations from the list above"
  }
 
  New-AzResourceGroup `
  -Name $RGName `
  -Location $Location
}

# Function to check for RG existance and deployment of bicep template
function Deploy-BicepTemplate
{
  # Checks if the resource group exists. If it doesn't, it will call the Create-NewRG fucntion to create it
  $CheckIfRGExist = Get-AzResourceGroup -ResourceGroupName $RGName -ErrorAction Ignore

  if(!$CheckIfRGExist)
  {
    Write-Output "$RGName does not exist. Creating RG"
    Create-NewRG
  }

  # Initial bicep deployment
  #If default value is defined, or else overwrite it.
  Write-Output "VMName is $VMName"

  if($VMName -ne "JUMPY01")
  {
    New-AzResourceGroupDeployment `
    -Verbose `
    -ResourceGroupName $RGName `
    -TemplateFile $BicepTemplatePath `
    -VMUsername $VMUsername `
    -VMPassword $PasswordSecure `
    -VMName $VMName `
    -Mode Complete
  }
  else
  {
    New-AzResourceGroupDeployment `
    -Verbose `
    -ResourceGroupName $RGName `
    -TemplateFile $BicepTemplatePath `
    -VMUsername $VMUsername `
    -VMPassword $PasswordSecure `
    -Mode Complete
  }
}

# Prompt for server admin username and password
if(!$VMUsername)
{
  $VMUsername = Read-Host -Prompt "Enter username for the VM"
}
if(!$VMPassword)
{
  $VMPassword = Read-Host -Prompt "Enter password for the VM"
}

#Convert password string to secureString
$PasswordSecure = $VMPassword | ConvertTo-SecureString -AsPlainText -Force

# Check Azure session on Powershell
$CheckAzSession = Get-AzAccessToken -ErrorAction Ignore

# If session is available, start deployment. If not, call the Login-AZAccount cmdlet to authenticate with Azure admin account
if($CheckAzSession)
{
  Get-AZAccessToken
  Deploy-BicepTemplate
}
else
{
  Logout-AZAccount
  Login-AZAccount
  Deploy-BicepTemplate
}
