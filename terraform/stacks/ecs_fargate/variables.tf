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

variable "ecs_desired_count" {
  type        = number
  description = "Desired Fargate task count (explicit in tfvars)."
  validation {
    condition     = var.ecs_desired_count >= 0
    error_message = "ecs_desired_count must be >= 0."
  }
}

variable "container_image" {
  type        = string
  description = "Container image reference (explicit in tfvars)."
  validation {
    condition     = length(trimspace(var.container_image)) > 0
    error_message = "container_image must be set in tfvars."
  }
}

variable "container_port" {
  type        = number
  description = "Container listen port; must match security_groups stack and target group."
  default     = 80
}
