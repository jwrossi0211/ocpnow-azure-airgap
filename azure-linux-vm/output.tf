output "linux_vm_name" {
  value = azurerm_linux_virtual_machine.linux_vm.name
}


output "linux_vm_public_ip" {
  value = azurerm_linux_virtual_machine.linux_vm.public_ip_address
}
