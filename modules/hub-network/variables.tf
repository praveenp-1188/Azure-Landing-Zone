variable "name_prefix" {
  description = "Prefix used in resource names."
  type        = string
}

variable "location" {
  description = "Azure region for the hub."
  type        = string
}

variable "address_space" {
  description = "Address space of the hub virtual network."
  type        = list(string)
}

variable "firewall_subnet_prefix" {
  description = "Prefix for AzureFirewallSubnet (/26 or larger)."
  type        = string
}

variable "gateway_subnet_prefix" {
  description = "Prefix for GatewaySubnet (/27 or larger)."
  type        = string
}

variable "bastion_subnet_prefix" {
  description = "Prefix for AzureBastionSubnet (/26 or larger)."
  type        = string
}

variable "shared_subnet_prefix" {
  description = "Prefix for the shared services subnet."
  type        = string
}

variable "dns_servers" {
  description = "Custom DNS servers for the hub. Empty uses Azure-provided DNS."
  type        = list(string)
  default     = []
}

variable "enable_firewall" {
  description = "Deploy Azure Firewall in the hub and route spoke traffic through it."
  type        = bool
  default     = false
}

variable "firewall_sku_tier" {
  description = "Azure Firewall tier: Basic, Standard or Premium."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.firewall_sku_tier)
    error_message = "firewall_sku_tier must be Basic, Standard or Premium."
  }
}

variable "enable_bastion" {
  description = "Deploy Azure Bastion in the hub."
  type        = bool
  default     = false
}

variable "availability_zones" {
  description = "Availability zones for the firewall and its public IP. Empty for regions without zones."
  type        = list(string)
  default     = ["1", "2", "3"]
}

variable "log_analytics_workspace_id" {
  description = "Workspace that receives firewall logs. Null disables diagnostics."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags applied to every resource."
  type        = map(string)
  default     = {}
}
