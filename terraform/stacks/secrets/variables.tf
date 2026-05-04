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

variable "secrets_recovery_window_in_days" {
  type        = number
  description = "Secrets Manager recovery window; 0 deletes immediately on secret removal (operational tuning)."
  default     = 0
}
