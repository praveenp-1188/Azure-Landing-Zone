output "management_group_ids" {
  description = "Management group resource IDs keyed by short name (root, platform, management, connectivity, identity, landingzones, corp, online, sandbox, decommissioned)."
  value       = local.management_group_ids
}
