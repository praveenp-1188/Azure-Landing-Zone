variable "name_prefix" {
  description = "Prefix used in resource names."
  type        = string
}

variable "location" {
  description = "Azure region for the management resources."
  type        = string
}

variable "retention_in_days" {
  description = "Log Analytics retention in days (30-730)."
  type        = number
  default     = 30

  validation {
    condition     = var.retention_in_days >= 30 && var.retention_in_days <= 730
    error_message = "retention_in_days must be between 30 and 730."
  }
}

variable "daily_quota_gb" {
  description = "Daily ingestion cap in GB. -1 means unlimited."
  type        = number
  default     = -1
}

variable "tags" {
  description = "Tags applied to every resource."
  type        = map(string)
  default     = {}
}
