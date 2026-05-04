variable "aws_region" {
  type        = string
  description = "AWS region for this stack."
  validation {
    condition     = length(trimspace(var.aws_region)) > 0
    error_message = "aws_region must be non-empty."
  }
}

variable "project_name" {
  type        = string
  description = "Short project name used in resource naming."
  validation {
    condition     = length(trimspace(var.project_name)) > 0
    error_message = "project_name must be non-empty."
  }
}

variable "environment" {
  type        = string
  description = "Environment label."
  validation {
    condition     = length(trimspace(var.environment)) > 0
    error_message = "environment must be non-empty."
  }
}

variable "terraform_state_bucket" {
  type        = string
  description = "S3 bucket holding all stack state objects."
  validation {
    condition     = length(trimspace(var.terraform_state_bucket)) > 0
    error_message = "terraform_state_bucket must be set."
  }
}

variable "terraform_state_region" {
  type        = string
  description = "Region of the Terraform state bucket."
  validation {
    condition     = length(trimspace(var.terraform_state_region)) > 0
    error_message = "terraform_state_region must be set."
  }
}

variable "terraform_state_prefix" {
  type        = string
  description = "State key prefix (no trailing slash)."
  validation {
    condition     = length(trimspace(var.terraform_state_prefix)) > 0 && !endswith(var.terraform_state_prefix, "/")
    error_message = "terraform_state_prefix must be non-empty and must not end with '/'."
  }
}

variable "aurora_engine_version" {
  type        = string
  description = "Aurora PostgreSQL engine version (explicit in tfvars)."
  validation {
    condition     = length(trimspace(var.aurora_engine_version)) > 0
    error_message = "aurora_engine_version must be set in tfvars."
  }
}

variable "aurora_skip_final_snapshot" {
  type        = bool
  description = "If true, destroy cluster without a final snapshot (must be explicit in tfvars)."
}
