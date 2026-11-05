output "resource_group_name" {
  description = "Name of the management resource group."
  value       = azurerm_resource_group.this.name
}

output "log_analytics_workspace_id" {
  description = "Resource ID of the central Log Analytics workspace."
  value       = azurerm_log_analytics_workspace.this.id
}

output "log_analytics_workspace_name" {
  description = "Name of the central Log Analytics workspace."
  value       = azurerm_log_analytics_workspace.this.name
}
