terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.97.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "random" {}

resource "random_string" "adminpassword" {
  length = 10
  special = true
}

locals {
  adminpassword = random_string.adminpassword.result
}

resource "azurerm_resource_group" "rg-mssql-sandbox" {
  name = "rg-mssql-sandbox"
  location = "AustraliaEast"
}

resource "azurerm_network_security_group" "nsg" {
  name = "nsg-sandbox"
  location = azurerm_resource_group.rg-mssql-sandbox.location
  resource_group_name = azurerm_resource_group.rg-mssql-sandbox.name

  security_rule {
    name = "nsg-rule"
    priority = 100
    direction = "Inbound"
    access = "Allow"
    protocol = "TCP"
    source_port_range = "*"
    destination_port_ranges = ["3389","443","1433"]
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_virtual_network" "vnet-sandbox" {
  name = "vnet-sandbox"
  location = azurerm_resource_group.rg-mssql-sandbox.location
  resource_group_name = azurerm_resource_group.rg-mssql-sandbox.name
  address_space = ["10.0.0.0/16"]

  subnet {
    name = "subnet-sandbox"
    address_prefix = "10.0.1.0/24"
    security_group = azurerm_network_security_group.nsg.id
  }
}

resource "azurerm_network_interface" "nic" {
  name = "nic-sandbox"
  location = azurerm_resource_group.rg-mssql-sandbox.location
  resource_group_name = azurerm_resource_group.rg-mssql-sandbox.name
  
  ip_configuration {
    name = "ipconfig-sandbox"
    subnet_id = azurerm_virtual_network.vnet-sandbox.subnet.*.id[0]
    public_ip_address_id = azurerm_public_ip.pubip.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_public_ip" "pubip" {
  name = "pubip-sandbox"
  location = azurerm_resource_group.rg-mssql-sandbox.location
  resource_group_name = azurerm_resource_group.rg-mssql-sandbox.name
  allocation_method = "Static"
  sku = "Standard"
}


resource "azurerm_windows_virtual_machine" "vm" {
  name                = var.vmname
  location = azurerm_resource_group.rg-mssql-sandbox.location
  resource_group_name = azurerm_resource_group.rg-mssql-sandbox.name
  size                = var.vmsize
  admin_username      = var.vmadminusername
  admin_password      = local.adminpassword
  network_interface_ids = [azurerm_network_interface.nic.id]

  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.vmimagepublisher
    offer = var.vmimageoffer
    sku = var.vmimagesku
    version = var.vmimageversion
  }
}

resource "azurerm_mssql_virtual_machine" "mssql" {
  virtual_machine_id = azurerm_windows_virtual_machine.vm.id
  sql_license_type = "PAYG"
  r_services_enabled = true
  sql_connectivity_port = 1433
  sql_connectivity_type = "PRIVATE"
  sql_connectivity_update_password = local.adminpassword
  sql_connectivity_update_username = var.sqladminusername
}

output public_ipaddress_vm {
  value = azurerm_public_ip.pubip.ip_address
}

output VMinfo {
  value = [{
    admin_username: var.vmadminusername
    admin_password: local.adminpassword
    server_name: azurerm_windows_virtual_machine.vm.name
    server_ip_address: azurerm_windows_virtual_machine.vm.private_ip_address 
  }]
}

output MSSQLinfo {
  value = [{
    sqladminusername = var.sqladminusername
    sqladminpassword = local.adminpassword
  }]
}

