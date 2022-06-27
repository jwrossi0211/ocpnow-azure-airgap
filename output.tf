
output "rg-name" {
  value = module.resource_group.name
}

output "bastion_host_name" {
  value = module.bastion_host.linux_vm_name
}

output "bastion_host_public_ip" {
  value = module.bastion_host.linux_vm_public_ip
}

