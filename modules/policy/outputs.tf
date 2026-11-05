output "assignment_ids" {
  description = "Policy assignment IDs created by this module."
  value = merge(
    {
      allowed_locations    = azurerm_management_group_policy_assignment.allowed_locations.id
      allowed_locations_rg = azurerm_management_group_policy_assignment.allowed_locations_rg.id
      security_benchmark   = azurerm_management_group_policy_assignment.security_benchmark.id
      corp_deny_public_ip  = azurerm_management_group_policy_assignment.corp_deny_public_ip.id
      sandbox_deny_types   = azurerm_management_group_policy_assignment.sandbox_deny_types.id
    },
    { for k, a in azurerm_management_group_policy_assignment.required_tags : "required_tag_${k}" => a.id },
  )
}
