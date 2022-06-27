
output "ocp_vnet_rg_name" {
  value = module.resource_group.name
}

output "ocp_vnet_id" {
  value = module.ocp_vnet.id
}

output "bastion_host_name" {
  value = module.bastion_host.linux_vm_name
}

output "bastion_host_public_ip" {
  value = module.bastion_host.linux_vm_public_ip
}

output "management_vnet_rg_name" {
  value = module.resource_group_mgmt_vnet.name
}

output "management_vnet_id" {
  value = module.management_vnet.id
}

output "bastion_host_mgmt_vnet_name" {
  value = module.bastion_host_mgmt.linux_vm_name
}

output "bastion_host_mgmt_vnet_public_ip" {
  value = module.bastion_host_mgmt.linux_vm_public_ip
}

