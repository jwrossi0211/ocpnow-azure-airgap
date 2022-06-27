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


###### Control Plane Subnet and NSG ############

# Create control plane Subnet
resource "azurerm_subnet" "control_plane_subnet" {
  name                 = var.control_plane_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.control_plane_subnet_address  
}

# Create control plane Network Security Group (NSG)
resource "azurerm_network_security_group" "control_plane_subnet_nsg" {
  name                = "${azurerm_subnet.control_plane_subnet.name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
}

# Associate control plane NSG and Subnet
resource "azurerm_subnet_network_security_group_association" "control_plane_subnet_nsg_associate" {
  depends_on = [ azurerm_network_security_rule.control_plane_nsg_rule_inbound]  
  subnet_id                 = azurerm_subnet.control_plane_subnet.id
  network_security_group_id = azurerm_network_security_group.control_plane_subnet_nsg.id
}

#  Create NSG Rules
#  Locals Block for Security Rules
locals {
  control_plane_inbound_ports_map = {
    "100" : "80",
    "110" : "443",
    "120" : "6443"
  } 
}

# NSG Inbound Rule for control plane Subnet
resource "azurerm_network_security_rule" "control_plane_nsg_rule_inbound" {
  for_each = local.control_plane_inbound_ports_map
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
  network_security_group_name = azurerm_network_security_group.control_plane_subnet_nsg.name
}

# NSG Outbound Rule for control plane Subnet
resource "azurerm_network_security_rule" "control_plane_nsg_rule_outbound" {
  name                        = "Deny Internet Outbound"
  priority                    = "100"
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*" 
  source_address_prefix       = "*"
  destination_address_prefix  = "Internet"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.control_plane_subnet_nsg.name
}

###### Worker Subnet and NSG ############

# Create worker Subnet
resource "azurerm_subnet" "worker_subnet" {
  name                 = var.worker_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.worker_subnet_address  
}

# Create worker Network Security Group (NSG)
resource "azurerm_network_security_group" "worker_subnet_nsg" {
  name                = "${azurerm_subnet.worker_subnet.name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
}

# Associate control plane NSG and Subnet
resource "azurerm_subnet_network_security_group_association" "worker_subnet_nsg_associate" {
  depends_on = [ azurerm_network_security_rule.worker_nsg_rule_inbound]  
  subnet_id                 = azurerm_subnet.worker_subnet.id
  network_security_group_id = azurerm_network_security_group.worker_subnet_nsg.id
}

#  Create NSG Rules
#  Locals Block for Security Rules
locals {
  worker_inbound_ports_map = {
    "100" : "80",
    "110" : "443",
    "120" : "6443"
  } 
}

# NSG Inbound Rule for control plane Subnet
resource "azurerm_network_security_rule" "worker_nsg_rule_inbound" {
  for_each = local.worker_inbound_ports_map
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
  network_security_group_name = azurerm_network_security_group.worker_subnet_nsg.name
}

# NSG Outbound Rule for workder Subnet
resource "azurerm_network_security_rule" "worker_nsg_rule_outbound" {
  name                        = "Deny Internet Outbound"
  priority                    = "100"
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*" 
  source_address_prefix       = "*"
  destination_address_prefix  = "Internet"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.worker_subnet_nsg.name
}