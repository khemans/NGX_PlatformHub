variable "name_prefix" {
  type        = string
  description = "Prefix for resource Name tags and identifiers."
}

variable "cidr_block" {
  type        = string
  description = "IPv4 CIDR for the VPC (use /16 so cidrsubnet layout yields four /20 subnets)."

  validation {
    condition     = can(cidrhost(var.cidr_block, 0))
    error_message = "cidr_block must be a valid IPv4 CIDR."
  }
}

variable "availability_zones" {
  type        = list(string)
  description = "Exactly two AZ names for public/private subnet pairs."

  validation {
    condition     = length(var.availability_zones) == 2
    error_message = "Provide exactly two availability zones (public/private subnet pairs)."
  }
}

variable "single_nat_gateway" {
  type        = bool
  description = "If true, one NAT gateway is shared by all private subnets (lower cost)."
  default     = true
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "enable_dns_support" {
  type    = bool
  default = true
}
