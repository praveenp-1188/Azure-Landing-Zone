output "resource_group_name" {
  description = "Name of the spoke network resource group."
  value       = azurerm_resource_group.this.name
}

output "vnet_id" {
  description = "Resource ID of the spoke virtual network."
  value       = azurerm_virtual_network.this.id
}

output "subnet_ids" {
  description = "Subnet resource IDs keyed by short name."
  value       = { for k, s in azurerm_subnet.this : k => s.id }
}

output "network_security_group_ids" {
  description = "NSG resource IDs keyed by subnet short name."
  value       = { for k, n in azurerm_network_security_group.this : k => n.id }
}
