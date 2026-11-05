variable "environment" {
  description = "Environment name, e.g. dev or prod."
  type        = string
}

variable "location" {
  description = "Azure region for the landing zone."
  type        = string
}

variable "subscription_id" {
  description = "Landing zone (workload) subscription. Place it in the Corp management group via the platform's subscription_placement."
  type        = string
}

variable "connectivity_subscription_id" {
  description = "Subscription that holds the hub network (platform output connectivity_subscription_id)."
  type        = string
}

variable "hub_vnet_id" {
  description = "Platform output hub_vnet_id."
  type        = string
}

variable "hub_vnet_name" {
  description = "Platform output hub_vnet_name."
  type        = string
}

variable "hub_resource_group_name" {
  description = "Platform output hub_resource_group_name."
  type        = string
}

variable "firewall_private_ip" {
  description = "Platform output firewall_private_ip. Null when the hub has no firewall."
  type        = string
  default     = null
}

variable "address_space" {
  description = "Spoke address space. Must not overlap the hub or other spokes."
  type        = list(string)
}

variable "subnets" {
  description = "Spoke subnets keyed by short name."
  type = map(object({
    address_prefix = string
  }))
}

variable "tags" {
  description = "Tags applied to every resource (environment is added automatically)."
  type        = map(string)
  default     = {}
}
