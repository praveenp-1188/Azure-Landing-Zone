output "management_group_ids" {
  description = "Management group resource IDs keyed by short name."
  value       = module.management_groups.management_group_ids
}

output "log_analytics_workspace_id" {
  description = "Central Log Analytics workspace."
  value       = module.logging.log_analytics_workspace_id
}

# The values below are the inputs for landing-zones/*.

output "connectivity_subscription_id" {
  description = "Subscription that holds the hub network."
  value       = var.connectivity_subscription_id
}

output "hub_resource_group_name" {
  description = "Resource group of the hub virtual network."
  value       = module.hub.resource_group_name
}

output "hub_vnet_id" {
  description = "Resource ID of the hub virtual network."
  value       = module.hub.vnet_id
}

output "hub_vnet_name" {
  description = "Name of the hub virtual network."
  value       = module.hub.vnet_name
}

output "firewall_private_ip" {
  description = "Private IP of Azure Firewall (null when disabled)."
  value       = module.hub.firewall_private_ip
}
