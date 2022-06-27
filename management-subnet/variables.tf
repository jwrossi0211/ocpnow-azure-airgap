variable "resource_group_name" {
  description = "RG name"
  type        = string
}

variable "location" {
  description = "Region"
  type        = string
}


# Virtual Network, Subnets and Subnet NSG's

## Virtual Network
variable "vnet_name" {
  description = "Virtual Network name"
  type = string
}

# Management Subnet Name
variable "management_subnet_name" {
  description = "Virtual Network Management Subnet Name"
  type = string
}

# Managemenet Subnet Address Space
variable "management_subnet_address" {
  description = "Virtual Network Management Subnet Address Spaces"
  type = list(string)
}

