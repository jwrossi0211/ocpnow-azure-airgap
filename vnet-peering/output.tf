
output "peer_vnet1_to_vnet2_name" {
  description = "name of the peering between vnet1 and vnet2"
  value = azurerm_virtual_network_peering.peer-vnet1-to-vnet2.name
}

output "peer_vnet2_to_vnet1_name" {
  description = "name of the peering between vnet1 and vnet2"
  value = azurerm_virtual_network_peering.peer-vnet2-to-vnet1.name
}