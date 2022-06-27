variable "resource_group_name" {
  description = "RG name"
  type        = string
}

variable "location" {
  description = "Region"
  type        = string
  default = "eastus"
}


# Virtual Network, Subnets and Subnet NSG's

## Virtual Network
variable "vnet_name" {
  description = "Virtual Network name"
  type = string
  default = "vnet-ocp-marriott"
}

# controlplane Subnet Name
variable "control_plane_subnet_name" {
  description = "Virtual Network controlplane Subnet Name"
  type = string
  default = "controlplanesubnet"
}
# controlplane Subnet Address Space
variable "control_plane_subnet_address" {
  description = "Virtual Network controlplane Subnet Address Spaces"
  type = list(string)
  default = ["10.0.0.0/27"]
}

# worker Subnet Name
variable "worker_subnet_name" {
  description = "Virtual Network worker Subnet Name"
  type = string
  default = "workersubnet"
}
# worker Subnet Address Space
variable "worker_subnet_address" {
  description = "Virtual Network worker Subnet Address Spaces"
  type = list(string)
  default = ["10.0.0.32/27"]
}

# Management Subnet Name
variable "management_subnet_name" {
  description = "Virtual Network Management Subnet Name"
  type = string
  default = "workersubnet"
}
# Managemenet Subnet Address Space
variable "management_subnet_address" {
  description = "Virtual Network Management Subnet Address Spaces"
  type = list(string)
  default = ["10.0.0.64/27"]
}

