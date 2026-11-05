output "resource_group_name" {
  description = "Spoke network resource group."
  value       = module.spoke.resource_group_name
}

output "vnet_id" {
  description = "Spoke virtual network ID."
  value       = module.spoke.vnet_id
}

output "subnet_ids" {
  description = "Subnet IDs keyed by short name."
  value       = module.spoke.subnet_ids
}
