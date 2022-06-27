# VM Input Variables Placeholder file.
variable "vm_name" {
  description = "VM Name"
  type = string
}

variable "vm_size" {
  description = "VM Size"
  type = string
}

variable "vm_ssh_pub_key" {
  description = "VM SSH Public Key"
  type = string  
}

variable "vm_admin_username" {
  description = "VM User Name"
  type = string  
}

variable "vm_admin_password" {
  description = "VM Admin Password"
  type = string  
}

variable "resource_group_name" {
  description = "Resource Group to deploy VM to"
  type = string  
}

variable "resource_group_location" {
  description = "Location of Resource Group to deploy VM to"
  type = string  
}

variable "subnet_id" {
  description = "Azure ID of subnet to deploy VM to"
  type = string  
}
