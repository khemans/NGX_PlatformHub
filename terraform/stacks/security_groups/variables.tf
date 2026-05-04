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
    error_message = "terraform_state_bucket must be set (env remote_state tfvars)."
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
  description = "State key prefix inside the bucket (no trailing slash), e.g. ngx-platform-hub/dev."
  validation {
    condition     = length(trimspace(var.terraform_state_prefix)) > 0 && !endswith(var.terraform_state_prefix, "/")
    error_message = "terraform_state_prefix must be non-empty and must not end with '/'."
  }
}

variable "container_port" {
  type        = number
  description = "Container port on ECS tasks (must match ecs_fargate stack and image)."
  default     = 80
}

variable "alb_ingress_cidrs" {
  type        = list(string)
  description = "CIDRs allowed to reach the ALB on port 80 (network tuning)."
  default     = ["0.0.0.0/0"]
}
