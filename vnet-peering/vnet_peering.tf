resource "azurerm_virtual_network_peering" "peer-vnet1-to-vnet2" {
    name                      = "peer-${var.vnet_1_name}-to-${var.vnet_2_name}"
    resource_group_name       = var.vnet_1_resourcegroup_name
    virtual_network_name      = var.vnet_1_name
    remote_virtual_network_id = var.vnet_2_id
    allow_virtual_network_access = true
    allow_forwarded_traffic   = true
    allow_gateway_transit     = true
    use_remote_gateways       = false
}

resource "azurerm_virtual_network_peering" "peer-vnet2-to-vnet1" {
    name                      = "peer-${var.vnet_2_name}-to-${var.vnet_1_name}"
    resource_group_name       = var.vnet_2_resourcegroup_name
    virtual_network_name      = var.vnet_2_name
    remote_virtual_network_id = var.vnet_1_id
    allow_virtual_network_access = true
    allow_forwarded_traffic   = true
    allow_gateway_transit     = true
    use_remote_gateways       = false
}
