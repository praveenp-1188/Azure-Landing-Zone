# ---------- Subscriptions ----------

variable "management_subscription_id" {
  description = "Subscription for management resources (Log Analytics). Also used for management group and policy operations."
  type        = string
}

variable "connectivity_subscription_id" {
  description = "Subscription for the hub network. May equal management_subscription_id in small setups."
  type        = string
}

variable "subscription_placement" {
  description = "Additional subscriptions to place in management groups, e.g. { corp = [\"<sub-id>\"], sandbox = [\"<sub-id>\"] }."
  type        = map(list(string))
  default     = {}
}

# ---------- Management groups and policy ----------

variable "root_id" {
  description = "Short prefix for management group IDs and resource names."
  type        = string
  default     = "alz"
}

variable "root_name" {
  description = "Display name of the top-level management group."
  type        = string
  default     = "Azure Landing Zone"
}

variable "parent_management_group_id" {
  description = "Parent of the top-level management group. Null uses the tenant root group."
  type        = string
  default     = null
}

variable "allowed_locations" {
  description = "Azure regions where resources may be created."
  type        = list(string)
}

variable "required_tags" {
  description = "Tag names every resource group must carry."
  type        = list(string)
  default     = ["environment", "owner", "cost-center"]
}

variable "enforce_required_tags" {
  description = "Deny resource groups that are missing a required tag (otherwise report only)."
  type        = bool
  default     = false
}

# ---------- Management ----------

variable "primary_location" {
  description = "Region for platform resources. Must be in allowed_locations."
  type        = string
}

variable "log_retention_in_days" {
  description = "Log Analytics retention in days."
  type        = number
  default     = 30
}

# ---------- Connectivity ----------

variable "hub_address_space" {
  description = "Address space of the hub virtual network."
  type        = list(string)
  default     = ["10.0.0.0/22"]
}

variable "hub_subnet_prefixes" {
  description = "Hub subnet prefixes. Must fall inside hub_address_space."
  type = object({
    firewall = string
    gateway  = string
    bastion  = string
    shared   = string
  })
  default = {
    firewall = "10.0.0.0/26"
    gateway  = "10.0.0.64/27"
    bastion  = "10.0.0.128/26"
    shared   = "10.0.1.0/24"
  }
}

variable "enable_firewall" {
  description = "Deploy Azure Firewall in the hub (billed hourly)."
  type        = bool
  default     = false
}

variable "firewall_sku_tier" {
  description = "Azure Firewall tier: Basic, Standard or Premium."
  type        = string
  default     = "Standard"
}

variable "enable_bastion" {
  description = "Deploy Azure Bastion in the hub (billed hourly)."
  type        = bool
  default     = false
}

variable "availability_zones" {
  description = "Availability zones for zonal resources. Empty for regions without zones."
  type        = list(string)
  default     = ["1", "2", "3"]
}

variable "tags" {
  description = "Tags applied to every platform resource. Should include every name in required_tags."
  type        = map(string)
  default     = {}
}
