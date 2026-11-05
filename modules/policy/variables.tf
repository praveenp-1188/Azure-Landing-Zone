variable "root_management_group_id" {
  description = "Resource ID of the top-level landing zone management group."
  type        = string
}

variable "corp_management_group_id" {
  description = "Resource ID of the Corp landing zones management group."
  type        = string
}

variable "sandbox_management_group_id" {
  description = "Resource ID of the Sandbox management group."
  type        = string
}

variable "allowed_locations" {
  description = "Azure regions where resources and resource groups may be created."
  type        = list(string)

  validation {
    condition     = length(var.allowed_locations) > 0
    error_message = "Provide at least one allowed location."
  }
}

variable "required_tags" {
  description = "Tag names every resource group must carry."
  type        = list(string)
  default     = []
}

variable "enforce_required_tags" {
  description = "Deny resource groups missing a required tag. When false, non-compliance is only reported."
  type        = bool
  default     = false
}
