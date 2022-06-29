
data "azurerm_dns_zone" "dns_zone" {
  name                = var.dns_zone_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_dns_a_record" "dns_a_record" {
  name                = var.dns_resource_name
  zone_name           = data.azurerm_dns_zone.dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = ["${var.dns_resource_address}"]
}


