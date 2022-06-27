

## Management Subnet ID
output "management_subnet_id" {
  description = "Managemenet Subnet ID"
  value = azurerm_subnet.management_subnet.id
}

