variable "name_prefix" {
  description = "Prefix used in resource names, e.g. \"corp-dev\"."
  type        = string
}

variable "location" {
  description = "Azure region for the spoke."
  type        = string
}

variable "address_space" {
  description = "Address space of the spoke virtual network. Must not overlap the hub or other spokes."
  type        = list(string)
}

variable "subnets" {
  description = "Subnets to create, keyed by short name (the subnet is named snet-<key>)."
  type = map(object({
    address_prefix = string
  }))
}

variable "dns_servers" {
  description = "Custom DNS servers. Set this to the firewall private IP when the firewall acts as DNS proxy."
  type        = list(string)
  default     = []
}

variable "hub_vnet_id" {
  description = "Resource ID of the hub virtual network."
  type        = string
}

variable "hub_vnet_name" {
  description = "Name of the hub virtual network."
  type        = string
}

variable "hub_resource_group_name" {
  description = "Resource group of the hub virtual network."
  type        = string
}

variable "firewall_private_ip" {
  description = "Private IP of the hub firewall. When set, all subnets route 0.0.0.0/0 through it."
  type        = string
  default     = null
}

variable "use_remote_gateways" {
  description = "Use the hub's VPN/ExpressRoute gateway. Requires a gateway to exist in the hub."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags applied to every resource."
  type        = map(string)
  default     = {}
}
