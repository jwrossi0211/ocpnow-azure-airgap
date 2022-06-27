

## Management Subnet ID
output "management_subnet_id" {
  description = "Managemenet Subnet ID"
  value = azurerm_subnet.management_subnet.id
}

## Control Plane Subnet ID
output "control_plane_subnet_id" {
  description = "Control Plane Subnet ID"
  value = azurerm_subnet.control_plane_subnet.id
}

## Worker Subnet ID
output "worker_subnet_id" {
  description = "Worker Subnet ID"
  value = azurerm_subnet.worker_subnet.id
}

