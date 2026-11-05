variable "root_id" {
  description = "Short prefix used for every management group ID, e.g. \"alz\"."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{2,10}$", var.root_id))
    error_message = "root_id must be 2-10 characters: letters, digits and hyphens."
  }
}

variable "root_name" {
  description = "Display name of the top-level management group."
  type        = string
}

variable "parent_management_group_id" {
  description = "ID of the parent management group. Null places the hierarchy under the tenant root group."
  type        = string
  default     = null
}

variable "subscription_placement" {
  description = <<-EOT
    Subscriptions to move into the hierarchy, keyed by management group:
    management, connectivity, identity, corp, online, sandbox, decommissioned,
    platform, landingzones or root. A subscription can appear only once.
  EOT
  type        = map(list(string))
  default     = {}

  validation {
    condition = alltrue([
      for k in keys(var.subscription_placement) : contains(
        ["root", "platform", "management", "connectivity", "identity", "landingzones", "corp", "online", "sandbox", "decommissioned"],
        k
      )
    ])
    error_message = "subscription_placement keys must be names of management groups in this hierarchy."
  }
}
