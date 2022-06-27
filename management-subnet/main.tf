###### Management Subnet and NSG ############

# Create management Tier Subnet
resource "azurerm_subnet" "management_subnet" {
  name                 = var.management_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.management_subnet_address  
}

# Create Management Network Security Group (NSG)
resource "azurerm_network_security_group" "management_subnet_nsg" {
  name                = "${azurerm_subnet.management_subnet.name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
}

# Associate Management NSG and Subnet
resource "azurerm_subnet_network_security_group_association" "management_subnet_nsg_associate" {
  depends_on = [ azurerm_network_security_rule.management_nsg_rule_inbound]  
  subnet_id                 = azurerm_subnet.management_subnet.id
  network_security_group_id = azurerm_network_security_group.management_subnet_nsg.id
}

#  Create NSG Rules
#  Locals Block for Security Rules
locals {
  management_inbound_ports_map = {
    "100" : "22"
  } 
}

# NSG Inbound Rule for management Subnetß
resource "azurerm_network_security_rule" "management_nsg_rule_inbound" {
  for_each = local.management_inbound_ports_map
  name                        = "Rule-Port-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value 
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.management_subnet_nsg.name
}
