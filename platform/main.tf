locals {
  name_prefix = var.root_id
  tags        = merge(var.tags, { managed-by = "terraform", component = "platform" })

  # The platform subscriptions are always placed in their management groups.
  # If management and connectivity share one subscription (small or test
  # setups), it goes under Management only.
  subscription_placement = merge(
    var.subscription_placement,
    {
      management = distinct(concat(
        [var.management_subscription_id],
        lookup(var.subscription_placement, "management", []),
      ))
    },
    var.connectivity_subscription_id == var.management_subscription_id ? {} : {
      connectivity = distinct(concat(
        [var.connectivity_subscription_id],
        lookup(var.subscription_placement, "connectivity", []),
      ))
    },
  )
}

module "management_groups" {
  source = "../modules/management-groups"

  root_id                    = var.root_id
  root_name                  = var.root_name
  parent_management_group_id = var.parent_management_group_id
  subscription_placement     = local.subscription_placement
}

module "policy" {
  source = "../modules/policy"

  root_management_group_id    = module.management_groups.management_group_ids["root"]
  corp_management_group_id    = module.management_groups.management_group_ids["corp"]
  sandbox_management_group_id = module.management_groups.management_group_ids["sandbox"]
  allowed_locations           = var.allowed_locations
  required_tags               = var.required_tags
  enforce_required_tags       = var.enforce_required_tags
}

module "logging" {
  source = "../modules/logging"

  name_prefix       = local.name_prefix
  location          = var.primary_location
  retention_in_days = var.log_retention_in_days
  tags              = local.tags
}

module "hub" {
  source = "../modules/hub-network"
  providers = {
    azurerm = azurerm.connectivity
  }

  name_prefix                = local.name_prefix
  location                   = var.primary_location
  address_space              = var.hub_address_space
  firewall_subnet_prefix     = var.hub_subnet_prefixes.firewall
  gateway_subnet_prefix      = var.hub_subnet_prefixes.gateway
  bastion_subnet_prefix      = var.hub_subnet_prefixes.bastion
  shared_subnet_prefix       = var.hub_subnet_prefixes.shared
  enable_firewall            = var.enable_firewall
  firewall_sku_tier          = var.firewall_sku_tier
  enable_bastion             = var.enable_bastion
  availability_zones         = var.availability_zones
  log_analytics_workspace_id = module.logging.log_analytics_workspace_id
  tags                       = local.tags
}
