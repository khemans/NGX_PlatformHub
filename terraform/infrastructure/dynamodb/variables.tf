variable "aws_region" {
  type        = string
  description = "AWS region where the lock table lives (must match S3 state bucket region for Terraform backend)."
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
  description = "Used for default tags and naming conventions."
  validation {
    condition     = length(trimspace(var.environment)) > 0
    error_message = "environment must be non-empty."
  }
}

variable "table_name" {
  type        = string
  description = "Globally unique per AWS account and region. Use a distinct name per account (e.g. org-project-env-tf-locks). Same VPC can share one regional table; separate accounts need separate applies of this root."

  validation {
    condition     = length(trimspace(var.table_name)) > 0
    error_message = "table_name must be set in tfvars."
  }
}

variable "billing_mode" {
  type        = string
  description = "DynamoDB billing mode for the lock table."
  default     = "PAY_PER_REQUEST"
}

variable "point_in_time_recovery_enabled" {
  type        = bool
  description = "Enable PITR on the lock table."
  default     = false
}
