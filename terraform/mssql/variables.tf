// VM Details
// Change values or over write them if you want to use a different VM and username
// Password will be randomly generated and outputed in main.tf
variable vmname {
  type = string
  default = "mssqlserver01"
}

variable vmadminusername {
  type = string
  default = "vmadminuser"
}

variable vmsize {
  type = string
  default = "Standard_F2"
}

//sql admin username
variable sqladminusername {
  type = string
  default = "sqllogin"
}

// Image reference details
// Note these may be subjected to change
// Use Get-AZVMImagePublisher, Get-AZVMImageOffer and Get-AZVMImageSKU to obtain details
variable vmimagepublisher {
  type = string
  default = "MicrosoftSQLServer"
}

variable vmimageoffer {
  type = string
  default = "sql2019-ws2019"
}

variable vmimagesku {
  type = string
  default = "Standard"
}

variable vmimageversion {
  type = string
  default = "latest"
}