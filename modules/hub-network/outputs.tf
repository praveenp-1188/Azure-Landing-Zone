output "resource_group_name" {
  description = "Name of the connectivity resource group."
  value       = azurerm_resource_group.this.name
}

output "vnet_id" {
  description = "Resource ID of the hub virtual network."
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "Name of the hub virtual network."
  value       = azurerm_virtual_network.this.name
}

output "firewall_private_ip" {
  description = "Private IP of Azure Firewall, or null when the firewall is disabled."
  value       = try(azurerm_firewall.this[0].ip_configuration[0].private_ip_address, null)
}
