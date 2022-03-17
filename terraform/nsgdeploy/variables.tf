// These variables are used to provide value to the resources in main.tf
// Do not change values here
// If you wish to overwrite the default variables, use environment variables or tfvars

// Resource group variables
variable "rg_name" {
  type = string
  default = "rg-infrasandbox"
}

variable "rg_location" {
  type = string
  default = "AustraliaEast"
}

// Nsg config variables
variable "nsgs" {
  type = map(object({
    nsgname = string
    rulename = string
    priority = number
    direction = string
    access = string
    protocol = string
    source_port_range = string
    destination_port_ranges = list(string)
    source_address_prefix = string
    destination_address_prefix = string
  }))
  default = {
    "nsg_inrule_jump01" = {
      nsgname = "nsg-jump01"
      rulename = "nsg-inrule-jump01"
      priority = 100
      direction = "Inbound"
      access = "Allow"
      protocol = "TCP"
      source_port_range = "*"
      destination_port_ranges = ["3389","443","1433"]
      source_address_prefix = "*"
      destination_address_prefix = "*"
    }
    "nsg_inrule_sql01" = {
      nsgname = "nsg-sql01"
      rulename = "nsg-inrule-sql01"
      priority = 100
      direction = "Inbound"
      access = "Allow"
      protocol = "TCP"
      source_port_range = "*"
      destination_port_ranges = ["3389","443","1433"]
      source_address_prefix = "10.1.0.0/23"
      destination_address_prefix = "*"
    }
  }
}