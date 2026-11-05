locals {
  name_prefix = "corp-${var.environment}"
  tags = merge(var.tags, {
    environment = var.environment
    managed-by  = "terraform"
    component   = "landing-zone-corp"
  })
}

module "spoke" {
  source = "../../modules/spoke-network"
  providers = {
    azurerm     = azurerm
    azurerm.hub = azurerm.hub
  }

  name_prefix             = local.name_prefix
  location                = var.location
  address_space           = var.address_space
  subnets                 = var.subnets
  hub_vnet_id             = var.hub_vnet_id
  hub_vnet_name           = var.hub_vnet_name
  hub_resource_group_name = var.hub_resource_group_name
  firewall_private_ip     = var.firewall_private_ip
  dns_servers             = var.firewall_private_ip == null ? [] : [var.firewall_private_ip]
  tags                    = local.tags
}
