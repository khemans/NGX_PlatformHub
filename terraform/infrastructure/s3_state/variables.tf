variable "aws_region" {
  type        = string
  description = "AWS region for the state bucket (must match all other Terraform backends using this bucket)."
  validation {
    condition     = length(trimspace(var.aws_region)) > 0
    error_message = "aws_region must be non-empty."
  }
}

variable "project_name" {
  type        = string
  description = "Used for default tags."
  validation {
    condition     = length(trimspace(var.project_name)) > 0
    error_message = "project_name must be non-empty."
  }
}

variable "environment" {
  type        = string
  description = "Used for default tags."
  validation {
    condition     = length(trimspace(var.environment)) > 0
    error_message = "environment must be non-empty."
  }
}

variable "bucket_name" {
  type        = string
  description = "Globally unique bucket name for all Terraform state objects in this account/region for this program."

  validation {
    condition     = length(trimspace(var.bucket_name)) > 0
    error_message = "bucket_name must be set in tfvars."
  }
}

variable "enable_versioning" {
  type        = bool
  description = "Versioning on the state bucket (recommended)."
  default     = true
}

variable "force_destroy" {
  type        = bool
  description = "Allow non-empty bucket delete (non-prod only)."
  default     = false
}

variable "deny_insecure_transport" {
  type        = bool
  description = "Deny non-TLS S3 API access to this bucket."
  default     = true
}

variable "prevent_destroy" {
  type        = bool
  description = "If true, block Terraform destroy of the bucket resource."
  default     = false
}
