variable "vnet_1_name" {
  description = "Name of the first Virtual Network to peer"
  type = string
}

variable "vnet_1_resourcegroup_name" {
  description = "Resource Group Name of the first Virtual Network to peer"
  type = string
}

variable "vnet_1_id"  {
  description = "Azure ID of the first Virtual Network to peer"
  type = string
}

variable "vnet_2_name" {
  description = "Name of the second Virtual Network to peer"
  type = string
}

variable "vnet_2_resourcegroup_name" {
  description = "Resource Group Name of the second Virtual Network to peer"
  type = string
}

variable "vnet_2_id"  {
  description = "Azure ID of the second Virtual Network to peer"
  type = string
}
