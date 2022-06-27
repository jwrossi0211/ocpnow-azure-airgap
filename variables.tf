variable "resource_group_name" {
  description = "RG name"
  type        = string
  default = "rg-jwr-test-airgap"
}

variable "region" {
  description = "Region"
  type        = string
  default = "eastus"
}

variable "vnet_name" {
  description = "Virtual network name"
  type        = string
  default = "ocp-vnet"
}

variable "control_plane_subnet_name" {
  description = "Control Plane subnet name"
  type        = string
  default = "control-plane-subnet"
}

variable "control_plane_subnet_address" {
  description = "Control Plane subnet address"
  type = list(string)
  default = ["10.0.0.0/27"]
}

variable "worker_subnet_name" {
  description = "Worker subnet name"
  type        = string
  default = "worker-subnet"
}

variable "worker_subnet_address" {
  description = "Worker subnet address"
  type = list(string)
  default = ["10.0.0.32/27"]
}

variable "management_subnet_name" {
  description = "Management subnet name"
  type        = string
  default = "management-subnet"
}

variable "management_subnet_address" {
  description = "Management subnet address"
  type = list(string)
  default = ["10.0.0.64/27"]
}

variable "vm_hostname" {
  description = "VM Host name"
  type        = string
  default     = "lnuxBastion"
}

variable "vm_admin_username" {
  description = "VM User name"
  type        = string
  default     = "ocpAdmin"
}

variable "vm_admin_password" {
  description = "VM Password"
  type        = string
  default     = "ILoveRHELandIBM@1!"
}

variable "vm_size" {
  description = "VM Password"
  type        = string
  default     = "Standard_B2ms" 
}

variable "vm_ssh_pub_key" {
  description = "VM ssh pub key"
  type        = string
  default     = "~/.ssh/id_rsa_openshift_ipi.pub"
}


variable "vnet_name_prefix" {
  type        = string
  description = "The name of the vpc resource"
  default = "name-prefix"
}