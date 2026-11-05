# Baseline guardrails, all built-in Azure Policy definitions.

locals {
  builtin = {
    allowed_locations       = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"
    allowed_locations_rg    = "/providers/Microsoft.Authorization/policyDefinitions/e765b5de-1225-4ba3-bd56-1ac6695af988"
    require_tag_on_rg       = "/providers/Microsoft.Authorization/policyDefinitions/96670d01-0a4d-4649-9c89-2d3abc0a5025"
    not_allowed_types       = "/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749"
    security_benchmark_init = "/providers/Microsoft.Authorization/policySetDefinitions/1f3afdf9-d0c9-4c3d-847f-89da613e70a8"
  }
}

# Root: resources may only be created in approved regions.
resource "azurerm_management_group_policy_assignment" "allowed_locations" {
  name                 = "allowed-locations"
  display_name         = "Allowed locations for resources"
  management_group_id  = var.root_management_group_id
  policy_definition_id = local.builtin.allowed_locations

  parameters = jsonencode({
    listOfAllowedLocations = { value = var.allowed_locations }
  })
}

# Root: resource groups may only be created in approved regions.
resource "azurerm_management_group_policy_assignment" "allowed_locations_rg" {
  name                 = "allowed-locations-rg"
  display_name         = "Allowed locations for resource groups"
  management_group_id  = var.root_management_group_id
  policy_definition_id = local.builtin.allowed_locations_rg

  parameters = jsonencode({
    listOfAllowedLocations = { value = var.allowed_locations }
  })
}

# Root: every resource group must carry the required tags.
# Defaults to DoNotEnforce (report only) so Azure-created resource groups such
# as NetworkWatcherRG are not blocked. Set enforce_required_tags = true to deny.
resource "azurerm_management_group_policy_assignment" "required_tags" {
  for_each = toset(var.required_tags)

  name                 = substr("req-tag-${lower(replace(each.key, "/[^a-zA-Z0-9-]/", "-"))}", 0, 24)
  display_name         = "Require tag '${each.key}' on resource groups"
  management_group_id  = var.root_management_group_id
  policy_definition_id = local.builtin.require_tag_on_rg
  enforce              = var.enforce_required_tags

  parameters = jsonencode({
    tagName = { value = each.key }
  })
}

# Root: audit against the Microsoft cloud security benchmark.
resource "azurerm_management_group_policy_assignment" "security_benchmark" {
  name                 = "security-benchmark"
  display_name         = "Microsoft cloud security benchmark"
  management_group_id  = var.root_management_group_id
  policy_definition_id = local.builtin.security_benchmark_init
}

# Corp: workloads are private, so public IP addresses are not allowed.
resource "azurerm_management_group_policy_assignment" "corp_deny_public_ip" {
  name                 = "deny-public-ip-corp"
  display_name         = "Deny public IP addresses in Corp landing zones"
  management_group_id  = var.corp_management_group_id
  policy_definition_id = local.builtin.not_allowed_types

  parameters = jsonencode({
    listOfResourceTypesNotAllowed = { value = ["Microsoft.Network/publicIPAddresses"] }
  })
}

# Sandbox: block expensive or network-bridging resource types.
resource "azurerm_management_group_policy_assignment" "sandbox_deny_types" {
  name                 = "deny-types-sandbox"
  display_name         = "Deny connectivity resources in Sandbox"
  management_group_id  = var.sandbox_management_group_id
  policy_definition_id = local.builtin.not_allowed_types

  parameters = jsonencode({
    listOfResourceTypesNotAllowed = {
      value = [
        "Microsoft.Network/expressRouteCircuits",
        "Microsoft.Network/virtualNetworkGateways",
        "Microsoft.Network/vpnGateways",
        "Microsoft.Network/virtualWans",
        "Microsoft.Network/virtualNetworks/virtualNetworkPeerings",
      ]
    }
  })
}
