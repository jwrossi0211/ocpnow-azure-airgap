module "resource_group_ocp_vnet" {
  source = "github.com/cloud-native-toolkit/terraform-azure-resource-group"

  resource_group_name = var.resource_group_name
  region              = var.region
  provision           = true
}

module "ocp_vnet" {
  source = "github.com/cloud-native-toolkit/terraform-azure-vpc"

  resource_group_name  = module.resource_group_ocp_vnet.name
  name                 = var.vnet_name
  region               = module.resource_group_ocp_vnet.region
  name_prefix          = var.vnet_name_prefix
  address_prefix_count = 1
  address_prefixes     = var.vnet_address_space
  provision            = var.provision
}
module "ocpvnet_management_subnet" {
  source = "github.com/cloud-native-toolkit/terraform-azure-subnets"

  resource_group_name = module.resource_group_ocp_vnet.name
  region              = module.resource_group_ocp_vnet.region
  _count              = 1
  label               = "management"
  subnet_name         = var.management_subnet_name
  vpc_name            = module.ocp_vnet.name
  ipv4_cidr_blocks    = var.management_subnet_address
  provision           = var.provision
  acl_rules = [{
    name        = "ssh-inbound"
    action      = "Allow"
    direction   = "Inbound"
    source      = "*"
    destination = "*"
    tcp = {
      destination_port_range = "22"
      source_port_range      = "*"
    }
    },
  ]
}

module "ocpvnet_control_plane_subnet" {
  source = "github.com/cloud-native-toolkit/terraform-azure-subnets"

  resource_group_name = module.resource_group_ocp_vnet.name
  region              = module.resource_group_ocp_vnet.region
  _count              = 1
  label               = "control_plane"
  subnet_name         = var.control_plane_subnet_name
  vpc_name            = module.ocp_vnet.name
  ipv4_cidr_blocks    = var.control_plane_subnet_address
  provision           = var.provision
  acl_rules = [{
    name        = "http-inbound"
    action      = "Allow"
    direction   = "Inbound"
    source      = "*"
    destination = "*"
    tcp = {
      destination_port_range = "80"
      source_port_range      = "*"
    }
    },
    {
      name        = "https-inbound"
      action      = "Allow"
      direction   = "Inbound"
      source      = "*"
      destination = "*"
      tcp = {
        destination_port_range = "443"
        source_port_range      = "*"
      }
    },
    {
      name        = "ssh-inbound"
      action      = "Allow"
      direction   = "Inbound"
      source      = "*"
      destination = "*"
      tcp = {
        destination_port_range = "22"
        source_port_range      = "*"
      }
    },
    {
      name        = "internet-outbound"
      action      = "Deny"
      direction   = "Outbound"
      source      = "*"
      destination = "Internet"
      Any = {
        destination_port_range = "*"
        source_port_range      = "*"
      }
    },
  ]
}
module "ocpvnet_worker_subnet" {
  source = "github.com/cloud-native-toolkit/terraform-azure-subnets"

  resource_group_name = module.resource_group_ocp_vnet.name
  region              = module.resource_group_ocp_vnet.region
  _count              = 1
  label               = "worker"
  subnet_name         = var.worker_subnet_name
  vpc_name            = module.ocp_vnet.name
  ipv4_cidr_blocks    = var.worker_subnet_address
  provision           = var.provision
  acl_rules = [{
    name        = "http-inbound"
    action      = "Allow"
    direction   = "Inbound"
    source      = "*"
    destination = "*"
    tcp = {
      destination_port_range = "80"
      source_port_range      = "*"
    }
    },
    {
      name        = "https-inbound"
      action      = "Allow"
      direction   = "Inbound"
      source      = "*"
      destination = "*"
      tcp = {
        destination_port_range = "443"
        source_port_range      = "*"
      }
    },
    {
      name        = "ssh-inbound"
      action      = "Allow"
      direction   = "Inbound"
      source      = "*"
      destination = "*"
      tcp = {
        destination_port_range = "22"
        source_port_range      = "*"
      }
    },
    {
      name        = "internet-outbound"
      action      = "Deny"
      direction   = "Outbound"
      source      = "*"
      destination = "Internet"
      Any = {
        destination_port_range = "*"
        source_port_range      = "*"
      }
    },
  ]
}

module "bastion_host" {
  source = "./azure-linux-vm"

  resource_group_name = module.resource_group_ocp_vnet.name

  vm_name                 = var.vm_hostname
  vm_size                 = var.vm_size
  vm_ssh_pub_key          = var.vm_ssh_pub_key
  vm_admin_username       = var.vm_admin_username
  vm_admin_password       = var.vm_admin_password
  resource_group_location = var.region
  subnet_id               = module.ocpvnet_management_subnet.id
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

  resource_group_name  = module.resource_group_mgmt_vnet.name
  name                 = "management_vnet"
  region               = module.resource_group_mgmt_vnet.region
  name_prefix          = var.vnet_name_prefix
  address_prefix_count = 1
  address_prefixes     = ["10.1.0.0/24"]
  provision            = true
}

module "management_network_subnet" {
  source = "github.com/cloud-native-toolkit/terraform-azure-subnets"

  resource_group_name = module.resource_group_mgmt_vnet.name
  region              = module.resource_group_mgmt_vnet.region
  _count              = 1
  subnet_name         = var.management_subnet_name
  vpc_name            = module.management_vnet.name
  label               = "mgmt"
  ipv4_cidr_blocks    = ["10.1.0.0/27"]
  provision           = var.provision
  acl_rules = [{
    name        = "ssh-inbound"
    action      = "Allow"
    direction   = "Inbound"
    source      = "*"
    destination = "*"
    tcp = {
      destination_port_range = "22"
      source_port_range      = "*"
    }
    }
  ]
}

module "bastion_host_mgmt" {
  source = "./azure-linux-vm"

  resource_group_name = module.resource_group_mgmt_vnet.name

  vm_name                 = "linux-bastion-mgmt"
  vm_size                 = var.vm_size
  vm_ssh_pub_key          = var.vm_ssh_pub_key
  vm_admin_username       = var.vm_admin_username
  vm_admin_password       = var.vm_admin_password
  resource_group_location = module.resource_group_mgmt_vnet.region
  subnet_id               = module.management_network_subnet.id
}

####### Virtual Network Peering #######

module "vnet_peering" {
  source = "./vnet-peering"

  vnet_1_name               = module.ocp_vnet.name
  vnet_1_resourcegroup_name = module.resource_group_ocp_vnet.name
  vnet_1_id                 = module.ocp_vnet.id

  vnet_2_name               = module.management_vnet.name
  vnet_2_resourcegroup_name = module.resource_group_mgmt_vnet.name
  vnet_2_id                 = module.management_vnet.id
}

###############  DNS ################

module "vm_dns" {
  source = "./azure-dns"

  dns_zone_name        = var.dns_zone_name
  resource_group_name  = var.dns_zone_resource_group_name
  dns_resource_name    = module.bastion_host.linux_vm_name
  dns_resource_address = module.bastion_host.linux_vm_public_ip
}