variable "table_name" {
  type        = string
  description = "DynamoDB table name for Terraform S3 backend state locking. Must be unique per AWS account and region. Deploy once per account/region you use for Terraform."

  validation {
    condition     = length(trimspace(var.table_name)) > 0 && length(var.table_name) <= 255
    error_message = "table_name must be non-empty and at most 255 characters."
  }
}

variable "billing_mode" {
  type        = string
  description = "Use PAY_PER_REQUEST for Terraform state locks (low, bursty traffic)."
  default     = "PAY_PER_REQUEST"

  validation {
    condition     = var.billing_mode == "PAY_PER_REQUEST"
    error_message = "Only PAY_PER_REQUEST is supported for this module."
  }
}

variable "point_in_time_recovery_enabled" {
  type        = bool
  description = "Enable PITR for the lock table (recommended for production accounts)."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Additional tags for the table."
  default     = {}
}
