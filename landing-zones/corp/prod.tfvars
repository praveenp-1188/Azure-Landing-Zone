# Corp landing zone: prod
# Replace the placeholder IDs; hub values come from "terraform output" in platform/.

environment = "prod"
location    = "westeurope"

subscription_id              = "33333333-3333-3333-3333-333333333333"
connectivity_subscription_id = "11111111-1111-1111-1111-111111111111"

hub_resource_group_name = "rg-alz-connectivity-westeurope"
hub_vnet_name           = "vnet-alz-hub-westeurope"
hub_vnet_id             = "/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/rg-alz-connectivity-westeurope/providers/Microsoft.Network/virtualNetworks/vnet-alz-hub-westeurope"
firewall_private_ip     = null # e.g. "10.0.0.4" once enable_firewall = true

address_space = ["10.2.0.0/16"]
subnets = {
  app  = { address_prefix = "10.2.0.0/24" }
  data = { address_prefix = "10.2.1.0/24" }
}

tags = {
  owner       = "app-team"
  cost-center = "cc-1234"
}
