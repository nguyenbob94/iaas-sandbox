// For internal use only. Not for clients
// Minimal use of variables here
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

resource "azurerm_resource_group" "rgSandbox" {
  name = var.rg_name
  location = var.rg_location
}

resource "azurerm_network_security_group" "nsgs" {
  for_each = var.nsgs
  name = each.value["nsgname"]
  location = azurerm_resource_group.rgSandbox.location
  resource_group_name = azurerm_resource_group.rgSandbox.name
  
  security_rule {
    name = each.value["rulename"]
    priority = each.value["priority"]
    direction = each.value["direction"]
    access = each.value["access"]
    protocol = each.value["protocol"]
    source_port_range = each.value["source_port_range"]
    destination_port_ranges = each.value["destination_port_ranges"]
    source_address_prefix = each.value["source_address_prefix"]
    destination_address_prefix = each.value["destination_address_prefix"]
  }
}


