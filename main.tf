module "resource_group_ocp_vnet" {
  source = "github.com/cloud-native-toolkit/terraform-azure-resource-group"

  resource_group_name = var.resource_group_name
  region              = var.region
  provision           = true
}

module "ocp_vnet" {
  source = "github.com/cloud-native-toolkit/terraform-azure-vpc"

  resource_group_name = module.resource_group_ocp_vnet.name
  name                = var.vnet_name
  region              = module.resource_group_ocp_vnet.region
  name_prefix         = var.vnet_name_prefix
  address_prefix_count = 1
  address_prefixes    = ["10.0.0.0/24"]
  provision           = true
}

module "ocp_subnets" {
  source = "./ocp-subnets"

  resource_group_name = module.resource_group_ocp_vnet.name
  location = module.resource_group_ocp_vnet.region
  vnet_name = module.ocp_vnet.name
  control_plane_subnet_name = var.control_plane_subnet_name
  control_plane_subnet_address = var.control_plane_subnet_address
  worker_subnet_name = var.worker_subnet_name
  worker_subnet_address = var.worker_subnet_address
  management_subnet_name = var.management_subnet_name
  management_subnet_address = var.management_subnet_address
}

module "bastion_host" {
  source = "./azure-linux-vm"

  resource_group_name = module.resource_group_ocp_vnet.name

  vm_name = var.vm_hostname
  vm_size = var.vm_size
  vm_ssh_pub_key = var.vm_ssh_pub_key
  vm_admin_username = var.vm_admin_username
  vm_admin_password = var.vm_admin_password
  resource_group_location = var.region
  subnet_id = module.ocp_subnets.management_subnet_id
}

#################### Testing Separate Mangement VNet ##########

module "resource_group_mgmt_vnet" {
  source = "github.com/cloud-native-toolkit/terraform-azure-resource-group"

  resource_group_name = "rg-jwr-test-airgap-mgmt-vnet"
  region              = var.region
  provision           = true
}

module "management_vnet" {
  source = "github.com/cloud-native-toolkit/terraform-azure-vpc"

  resource_group_name = module.resource_group_mgmt_vnet.name
  name                = "management_vnet"
  region              = module.resource_group_mgmt_vnet.region
  name_prefix         = var.vnet_name_prefix
  address_prefix_count = 1
  address_prefixes    = ["10.1.0.0/24"]
  provision           = true
}

module "management_subnet" {
  source = "./management-subnet"

  resource_group_name = module.resource_group_mgmt_vnet.name
  location = module.resource_group_mgmt_vnet.region
  vnet_name = module.management_vnet.name
  management_subnet_name = "management_subnet"
  management_subnet_address = ["10.1.0.0/27"]
}

module "bastion_host_mgmt" {
  source = "./azure-linux-vm"

  resource_group_name = module.resource_group_mgmt_vnet.name

  vm_name = "linux-bastion-mgmt"
  vm_size = var.vm_size
  vm_ssh_pub_key = var.vm_ssh_pub_key
  vm_admin_username = var.vm_admin_username
  vm_admin_password = var.vm_admin_password
  resource_group_location = module.resource_group_mgmt_vnet.region
  subnet_id = module.management_subnet.management_subnet_id
}

####### Virtual Network Peering #######

module vnet_peering {
  source = "./vnet-peering"

  vnet_1_name = module.ocp_vnet.name
  vnet_1_resourcegroup_name = module.resource_group_ocp_vnet.name
  vnet_1_id = module.ocp_vnet.id

  vnet_2_name = module.management_vnet.name
  vnet_2_resourcegroup_name = module.resource_group_mgmt_vnet.name
  vnet_2_id = module.management_vnet.id
}

###############  DNS ################

module vm_dns {
  source = "./azure-dns"

  dns_zone_name = var.dns_zone_name
  resource_group_name = var.dns_zone_resource_group_name
  dns_resource_name = module.bastion_host.linux_vm_name
  dns_resource_address = module.bastion_host.linux_vm_public_ip
}