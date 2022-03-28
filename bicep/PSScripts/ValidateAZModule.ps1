function DeployBicepTemplate
{}


# Check if Azure module is installed on Powershell before running script
$CheckPSModule = (Get-InstalledModule -Name az).Name

if($CheckPSModule -eq "az")
{
  # Check Azure session on Powershell before running script
  $CheckAzSession = Get-AzAccessToken -ErrorAction Ignore

  # If session is available, start deployment. If not, call the Login-AZAccount cmdlet to authenticate with Azure admin account
  if($CheckAzSession)
  {
    Write-Output "Azure session found on Powershell"
    Get-AZAccessToken
    DeployBicepTemplate
  }
  else
  {
    Logout-AZAccount
    Login-AZAccount
    DeployBicepTemplate
  }
}
else
{
  Write-Output "Az Powershell Module is not found, imported or installed. Please install the az Powershell module then run this script again"
  Write-Output "Run the following cmdlet to install: Install-Module -Name az -Scope CurrentUser -AllowClobber"
  exit
}

