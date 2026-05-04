variable "aws_region" {
  type        = string
  description = "AWS region for this stack (set in env *.core.tfvars)."
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
  description = "Environment label (dev, staging, prod)."
  validation {
    condition     = length(trimspace(var.environment)) > 0
    error_message = "environment must be non-empty."
  }
}

variable "vpc_cidr" {
  type        = string
  description = "VPC IPv4 CIDR; use /16 for the default subnet layout baked into the vpc module."
  default     = "10.0.0.0/16"
}

variable "single_nat_gateway" {
  type        = bool
  description = "If true, one NAT gateway is shared by all private subnets (cost tuning)."
  default     = true
}
