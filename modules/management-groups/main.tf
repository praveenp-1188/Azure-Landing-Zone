# Management group hierarchy based on the Azure landing zone reference design:
#
#   <root>
#   ├── Platform
#   │   ├── Management
#   │   ├── Connectivity
#   │   └── Identity
#   ├── Landing Zones
#   │   ├── Corp
#   │   └── Online
#   ├── Sandbox
#   └── Decommissioned

resource "azurerm_management_group" "root" {
  name                       = var.root_id
  display_name               = var.root_name
  parent_management_group_id = var.parent_management_group_id
}

resource "azurerm_management_group" "platform" {
  name                       = "${var.root_id}-platform"
  display_name               = "Platform"
  parent_management_group_id = azurerm_management_group.root.id
}

resource "azurerm_management_group" "platform_children" {
  for_each = toset(["management", "connectivity", "identity"])

  name                       = "${var.root_id}-${each.key}"
  display_name               = title(each.key)
  parent_management_group_id = azurerm_management_group.platform.id
}

resource "azurerm_management_group" "landing_zones" {
  name                       = "${var.root_id}-landingzones"
  display_name               = "Landing Zones"
  parent_management_group_id = azurerm_management_group.root.id
}

resource "azurerm_management_group" "landing_zone_children" {
  for_each = toset(["corp", "online"])

  name                       = "${var.root_id}-${each.key}"
  display_name               = title(each.key)
  parent_management_group_id = azurerm_management_group.landing_zones.id
}

resource "azurerm_management_group" "sandbox" {
  name                       = "${var.root_id}-sandbox"
  display_name               = "Sandbox"
  parent_management_group_id = azurerm_management_group.root.id
}

resource "azurerm_management_group" "decommissioned" {
  name                       = "${var.root_id}-decommissioned"
  display_name               = "Decommissioned"
  parent_management_group_id = azurerm_management_group.root.id
}

locals {
  management_group_ids = merge(
    {
      root           = azurerm_management_group.root.id
      platform       = azurerm_management_group.platform.id
      landingzones   = azurerm_management_group.landing_zones.id
      sandbox        = azurerm_management_group.sandbox.id
      decommissioned = azurerm_management_group.decommissioned.id
    },
    { for k, mg in azurerm_management_group.platform_children : k => mg.id },
    { for k, mg in azurerm_management_group.landing_zone_children : k => mg.id },
  )

  subscription_associations = {
    for a in flatten([
      for mg, subs in var.subscription_placement : [
        for sub in subs : { key = "${mg}/${sub}", mg = mg, sub = sub }
      ]
    ]) : a.key => a
  }
}

resource "azurerm_management_group_subscription_association" "this" {
  for_each = local.subscription_associations

  management_group_id = local.management_group_ids[each.value.mg]
  subscription_id     = "/subscriptions/${each.value.sub}"
}
