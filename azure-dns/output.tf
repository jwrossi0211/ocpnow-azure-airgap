

## Management Subnet ID
output "dns_record_fqdn" {
  description = "FQDN of the DNS A record "
  value = azurerm_dns_a_record.dns_a_record.fqdn
}

