module "resource_group" {
  source = "github.com/cloud-native-toolkit/terraform-azure-resource-group"

  resource_group_name = var.resource_group_name
  region              = var.region
  provision           = true
}

module "vnet" {
  source = "github.com/cloud-native-toolkit/terraform-azure-vpc"

  resource_group_name = module.resource_group.name
  name                = var.vnet_name
  region              = module.resource_group.region
  name_prefix         = var.vnet_name_prefix
  address_prefix_count = 1
  address_prefixes    = ["10.0.0.0/24"]
  provision           = true
}

module "ocp_subnets" {
  source = "./azure-subnets"

  resource_group_name = module.resource_group.name
  vnet_name = module.vnet.name
  control_plane_subnet_name = var.control_plane_subnet_name
  control_plane_subnet_address = var.control_plane_subnet_address
  worker_subnet_name = var.worker_subnet_name
  worker_subnet_address = var.worker_subnet_address
  management_subnet_name = var.management_subnet_name
  management_subnet_address = var.management_subnet_address
}

module "bastion_host" {
  source = "./azure-linux-vm"

  resource_group_name = module.resource_group.name

  vm_name = var.vm_hostname
  vm_size = var.vm_size
  vm_ssh_pub_key = var.vm_ssh_pub_key
  vm_admin_username = var.vm_admin_username
  vm_admin_password = var.vm_admin_password
  resource_group_location = var.region
  subnet_id = module.ocp_subnets.management_subnet_id
}

module "bastion_host_cp" {
  source = "./azure-linux-vm"

  resource_group_name = module.resource_group.name

  vm_name = "linux-bastion-cp"
  vm_size = var.vm_size
  vm_ssh_pub_key = var.vm_ssh_pub_key
  vm_admin_username = var.vm_admin_username
  vm_admin_password = var.vm_admin_password
  resource_group_location = var.region
  subnet_id = module.ocp_subnets.control_plane_subnet_id
}


